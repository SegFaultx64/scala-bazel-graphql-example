package services

import sttp.client._
import io.circe._, io.circe.generic.auto._, io.circe.parser._, io.circe.syntax._

class Triposo(accountId: String, token: String) extends ThirdPartyService {
  this: CachingBehavior =>

  def withAuth[T, S](
      request: RequestT[Identity, T, S]
  ): RequestT[Identity, T, S] = {
    request
      .header("X-Triposo-Account", accountId)
      .header("X-Triposo-Token", token)
  }

  val locationsForCountry = cachable((countrycode: String) => {
    type Response = TriposoResponse[TriposoLocation]
    fetch[Response](
      uri"https://www.triposo.com/api/20190906/location.json?countrycode=$countrycode&count=15"
    )
  })

  val locationsFromID = cachable((id: String) => {
    type Response = TriposoResponse[TriposoLocation]
    fetch[Response](
      uri"https://www.triposo.com/api/20190906/location.json?id=$id"
    )
  })
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