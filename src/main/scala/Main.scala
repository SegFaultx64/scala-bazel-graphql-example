import sttp.client._
import cats.syntax.either._
import scala.io.Source
import io.circe._, io.circe.generic.auto._, io.circe.parser._, io.circe.syntax._
import sangria.execution._
import sangria.marshalling.circe._
import sangria.macros._
import sangria.macros.derive._
import sangria.schema._

import scala.language.postfixOps
import scala.concurrent.duration._
import scala.concurrent.{Future, Await}

import scala.concurrent.ExecutionContext.Implicits.global

import io.circe.Json
import io.circe.yaml.parser


import services._
import models.{Location, LatLong, Image, Climate, ClimateMonth}

class Temp() {

}

case class Config(triposo: TriposoConfig, wwo: WWOConfig)
case class TriposoConfig(key: String, secret: String)
case class WWOConfig(key: String)

object Main extends App {
  println(new java.io.File(".").getAbsolutePath())

  val configText = Source.fromFile(args(0)).mkString
  val config: Config = parser.parse(configText)
    .leftMap(err => err: Error)
    .flatMap(_.as[Config])
    .valueOr(throw _)

  val triposo = new Triposo(config.triposo.key, config.triposo.secret)
    with InMemoryCaching
  implicit val wwo = new WorldWeatherOnline(config.wwo.key)
    with InMemoryCaching

  implicit val LatLongType =
    deriveObjectType[Unit, LatLong](
      Interfaces(), 
      IncludeMethods())

  implicit val ImageType =
    deriveObjectType[Unit, Image](
      Interfaces(), 
      IncludeMethods())

  implicit val ClimateMonthType =
    deriveObjectType[Unit, ClimateMonth](
      Interfaces(), 
      IncludeMethods())

  val MonthArg = Argument("months", OptionInputType(ListInputType(StringType)))

  implicit val ClimateType =
    deriveObjectType[Unit, Climate](
      ExcludeFields("months"),
      AddFields(
        Field("months", ListType(ClimateMonthType), arguments = MonthArg :: Nil, resolve = ctx ⇒ {
          ctx.arg(MonthArg) match {
            case None => ctx.value.months
            case Some(months) => {
              ctx.value.months.filter(month => months.map(_.toLowerCase()).contains(month.name.toLowerCase()))
            }
          }
        })
      )
    )


  val LocationType =
    deriveObjectType[Unit, Location](
      Interfaces(), 
      IncludeMethods())


val Country = Argument("country", StringType)

  val QueryType = ObjectType("Query", fields[Temp, Unit](
  Field("locations", OptionType(ListType(LocationType)),
    description = Some("Returns a Locations with specific `country`."),
    arguments = Country :: Nil,
    resolve = c ⇒ {
      triposo.locationsForCountry(c.arg(Country))match {
        case None => None
        case Some(data) => {
          Some(data.results.map(loc => Location.fromTriposo(loc).withClimate))
        }
      }
    }
  )
))

val schema = Schema(QueryType)


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
    Executor.execute(schema, query, new Temp())

  for (error <- result.failed) {
    println(error)
  }

  println(Await.result(result, 30 seconds))
}

