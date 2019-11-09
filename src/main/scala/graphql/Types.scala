package graphql

import sangria.macros.derive._
import sangria.schema._

import models.{Location, LatLong, Image, Climate, ClimateMonth}

object Types {
  implicit val LatLongType =
    deriveObjectType[Unit, LatLong](Interfaces(), IncludeMethods())

  implicit val ImageType =
    deriveObjectType[Unit, Image](Interfaces(), IncludeMethods())

  implicit val ClimateMonthType =
    deriveObjectType[Unit, ClimateMonth](Interfaces(), IncludeMethods())

  val MonthArg = Argument("months", OptionInputType(ListInputType(StringType)))

  implicit val ClimateType =
    deriveObjectType[Unit, Climate](
      ExcludeFields("months"),
      AddFields(
        Field(
          "months",
          ListType(ClimateMonthType),
          arguments = MonthArg :: Nil,
          resolve = ctx ⇒ {
            ctx.arg(MonthArg) match {
              case None => ctx.value.months
              case Some(months) => {
                ctx.value.months.filter(
                  month =>
                    months
                      .map(_.toLowerCase())
                      .contains(month.name.toLowerCase())
                )
              }
            }
          }
        )
      )
    )

  implicit val LocationType =
    deriveObjectType[Unit, Location](Interfaces(), IncludeMethods())
}
