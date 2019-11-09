package main

import sangria.execution._
import sangria.marshalling.circe._
import sangria.marshalling.InputUnmarshaller
import sangria.macros._
import sangria.schema._
import sangria.validation._
import sangria.parser.{QueryParser, SyntaxError}

import scala.util.control.NonFatal

import scala.util.{Try, Success, Failure}

import io.circe.Json
import io.circe._, io.circe.generic.auto._, io.circe.parser._, io.circe.syntax._
import de.heikoseeberger.akkahttpcirce.ErrorAccumulatingCirceSupport._

import scala.concurrent.duration._
import scala.concurrent.{Future, Await}
import scala.concurrent.ExecutionContext.Implicits.global

import graphql.{TripSchema, Queries, Ctx}
import services.{Triposo, WorldWeatherOnline, InMemoryCaching}
import config.Config

import scala.io.StdIn

// Akka
import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.http.scaladsl.model.StatusCodes._
import akka.http.scaladsl.server.Directives._
import akka.http.scaladsl.model.MediaTypes._
import akka.http.scaladsl.server._
import akka.stream.ActorMaterializer

object Main extends App {
  val config = Config.fromFile(args(0))

  implicit val system = ActorSystem("sangria-server")
  implicit val materializer = ActorMaterializer()

  import system.dispatcher

  val triposo = new Triposo(config.triposo.key, config.triposo.secret)
    with InMemoryCaching
  val wwo = new WorldWeatherOnline(config.wwo.key)
    with InMemoryCaching
  
  val ctx = new Ctx(triposo, wwo)

  val routes = path("graphql") {
    post {
      entity(as[Query]) { query =>
        val temp = QueryParser.parse(query.query) match {
          case Failure(error) => {
            Future.failed(error)
          }
          case Success(document) => {
            Executor.execute(TripSchema.schema, document, ctx, operationName = query.operationName, variables = query.variables.getOrElse(Json.obj())).map(result => {
              result
            })
          }
        }

        onComplete(temp) {
          case Success(done) => complete(done)
          case Failure(error) => complete(BadRequest, formatError(error))
        }
      }
    }
  }
  
  val bindingFuture = Http().bindAndHandle(routes, "localhost", 1337)
  println(s"Server online at http://localhost:1337/\nPress RETURN to stop...")
  StdIn.readLine() // let it run until user presses return
  bindingFuture
    .flatMap(_.unbind()) // trigger unbinding from the port
    .onComplete(_ => system.terminate()) // and shutdown when done

  def formatError(error: Throwable): Json = error match {
    case syntaxError: SyntaxError ⇒
      Json.obj("errors" → Json.arr(
      Json.obj(
        "message" → Json.fromString(syntaxError.getMessage),
        "locations" → Json.arr(Json.obj(
          "line" → Json.fromBigInt(syntaxError.originalError.position.line),
          "column" → Json.fromBigInt(syntaxError.originalError.position.column))))))
    case validationError: ValidationError ⇒
      Json.obj("errors" → Json.arr(
      Json.obj(
        "message" → Json.fromString(validationError.getMessage),
        "locations" → validationError.violations.map(v => {
          v match {
            case a: AstNodeViolation => a.locations.map(l => {
              l.asJson
            })
          }
        }).asJson
      )))
    case e ⇒
      println(e)
      throw e
  }
}

case class Query(query: String, operationName: Option[String], variables: Option[Json])