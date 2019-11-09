package services

import sttp.client._
import io.circe.generic.auto._

class WorldWeatherOnline(key: String) extends ThirdPartyService {
  this: CachingBehavior =>

  def withAuth[T, S](
      request: RequestT[sttp.client.Identity, T, S]
  ): RequestT[sttp.client.Identity, T, S] = {
    request.copy[Identity, T, S](
      uri = request.uri
        .querySegment(sttp.model.Uri.QuerySegment.KeyValue("key", key))
    )
  }

  val weatherForCity = cachable((cityName: String) => {
    type Response = WWOResponse[WWOClimateAverages]
    fetch[Response](
      uri"http://api.worldweatheronline.com/premium/v1/weather.ashx?q=$cityName&format=json&mca=yes"
    )
  })

  val weatherForLatLong = cachable((coords: (Double, Double)) => {
    type Response = WWOResponse[WWOClimateAverages]
    fetch[Response](
      uri"http://api.worldweatheronline.com/premium/v1/weather.ashx?q=${coords._1},${coords._2}&format=json&mca=yes"
    )
  })
}

case class WWOResponse[A](data: A)
case class WWOClimateAverages(`ClimateAverages`: List[WWOMonthHolder])
case class WWOMonthHolder(month: List[WWOClimateMonth])
case class WWOClimateMonth(name: String, avgDailyRainfall: Float)
