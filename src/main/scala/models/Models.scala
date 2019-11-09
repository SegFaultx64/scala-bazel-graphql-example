package models

import services.{WorldWeatherOnline, WWOClimateAverages, TriposoLocation, TriposoImage, TriposoCoord}

case class Location(
    name: String,
    locationType: String,
    coordinates: LatLong,
    description: String,
    images: List[Image],
    climate: Climate
) {
  def withClimate()(implicit wwoClient: WorldWeatherOnline): Location = {
    wwoClient.weatherForLatLong((coordinates.latitude, coordinates.longitude)) match {
      case Some(climate) => {
        this.copy(climate = climate.data)
      }
      case None => this
    }
  }
}

object Location {
  implicit def fromTriposo(t: TriposoLocation): Location = {
    new Location(
      t.name,
      t.`type`,
      t.coordinates,
      t.snippet,
      t.images.map((a: TriposoImage) => a: Image),
      Climate(Nil)
    )
  }
}

case class Image(url: String, caption: String)
object Image {
  implicit def fromTriposo(t: TriposoImage): Image = {
    Image(t.source_url, t.caption.getOrElse(""))
  }
}

case class LatLong(latitude: Double, longitude: Double) {
  override def toString(): String = {
    s"$latitude,$longitude"
  }
}

object LatLong {
  implicit def fromTriposo(a: TriposoCoord): LatLong = {
    LatLong(a.latitude, a.longitude)
  }
}

case class Climate(months: List[ClimateMonth])
object Climate {
  implicit def fromWWO(w: WWOClimateAverages): Climate = {
    Climate(
      w.ClimateAverages(0)
        .month
        .map(m => ClimateMonth(m.name, m.avgDailyRainfall))
    )
  }
}
case class ClimateMonth(name: String, avgDailyRainfall: Double)
