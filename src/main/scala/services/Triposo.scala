package services

import sttp.client._
import io.circe.generic.auto._

class Triposo(accountId: String, token: String) extends ThirdPartyService {
  this: CachingBehavior =>

  def withAuth[T, S](
      request: RequestT[Identity, T, S]
  ): RequestT[Identity, T, S] = {
    request
      .header("X-Triposo-Account", accountId)
      .header("X-Triposo-Token", token)
  }

  type ==>[K, V] = Cachable[K, V]
  type LocationResponse = TriposoResponse[TriposoLocation]
  type LocationRequest = String ==> Option[LocationResponse]

  val locationsForCountry: LocationRequest = (countrycode: String) => {
    fetch[LocationResponse](
      uri"https://www.triposo.com/api/20190906/location.json?countrycode=$countrycode&count=15"
    )
  }

  val locationsFromID: LocationRequest = (id: String) => {
    fetch[LocationResponse](
      uri"https://www.triposo.com/api/20190906/location.json?id=$id"
    )
  }
}

case class TriposoLocation(
    name: String,
    `type`: String,
    coordinates: TriposoCoord,
    snippet: String,
    images: List[TriposoImage]
)
case class TriposoCoord(latitude: Float, longitude: Float)
case class TriposoImage(caption: Option[String], `source_url`: String)
case class TriposoResponse[A](results: List[A])