package services

import sttp.client._
import io.circe._, io.circe.generic.auto._, io.circe.parser._, io.circe.syntax._

trait ThirdPartyService {
  this: CachingBehavior =>

  def withAuth[T, S](req: RequestT[Identity, T, S]): RequestT[Identity, T, S]

  def fetch[T](
      uri: sttp.model.Uri
  )(implicit evidence: Decoder[T]): Option[T] = {
    val request = withAuth(basicRequest.get(uri))

    implicit val backend = HttpURLConnectionBackend()
    val response = request.send()

    response.body match {
      case Left(error) => None
      case Right(body) => decode[T](body) match {
        case Left(_) => None
        case Right(body) => Some(body)
      }
    }
  }

}