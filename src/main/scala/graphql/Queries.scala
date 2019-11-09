package graphql

import sangria.schema._
import models.{Location}
import services.{Triposo, WorldWeatherOnline}

case class Ctx(triposo: Triposo, wwo: WorldWeatherOnline)

object Queries {

  val Country = Argument("country", StringType)

  val CountryQuery = ObjectType(
    "Query",
    fields[Ctx, Unit](
      Field(
        "locations",
        OptionType(ListType(Types.LocationType)),
        description = Some("Returns a Locations with specific `country`."),
        arguments = Country :: Nil,
        resolve = c ⇒ {
          c.ctx.triposo.locationsForCountry(c.arg(Country)) match {
            case None => None
            case Some(data) => {
              Some(
                data.results.map(loc => Location.fromTriposo(loc).withClimate()(c.ctx.wwo))
              )
            }
          }
        }
      )
    )
  )

}
