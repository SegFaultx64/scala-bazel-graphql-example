package main

import sangria.execution._
import sangria.marshalling.circe._
import sangria.macros._
import sangria.schema._

import io.circe.Json

import scala.concurrent.duration._
import scala.concurrent.{Future, Await}
import scala.concurrent.ExecutionContext.Implicits.global

import graphql.{TripSchema, Queries, Ctx}
import services.{Triposo, WorldWeatherOnline, InMemoryCaching}
import config.Config

object Main extends App {
  val config = Config.fromFile(args(0))

  val triposo = new Triposo(config.triposo.key, config.triposo.secret)
    with InMemoryCaching
  val wwo = new WorldWeatherOnline(config.wwo.key)
    with InMemoryCaching
  
  val ctx = new Ctx(triposo, wwo)

  val query =
  graphql"""
    query MyLocation {
      georgia: locations(country: "ge") {
        name
        description

        climate {
          months(months:["January","february","March"]) {
            name
            avgDailyRainfall
          }
        }
      }
      montenegro: locations(country: "me") {
        name
        description

        climate {
          months(months:["January","february","March"]) {
            name
            avgDailyRainfall
          }
        }
      }
    }
  """

  val result: Future[Json] =
    Executor.execute(TripSchema.schema, query, ctx)

  for (error <- result.failed) {
    println(error)
  }

  println(Await.result(result, 30 seconds))
}

