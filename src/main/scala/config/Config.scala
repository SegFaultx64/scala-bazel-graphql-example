package config

import cats.syntax.either._
import scala.io.Source
import io.circe.yaml.parser
import io.circe._, io.circe.generic.auto._

case class Config(triposo: TriposoConfig, wwo: WWOConfig)
object Config {
  def fromFile(path: String): Config = {
    val configText = Source.fromFile(path).mkString
    parser.parse(configText)
      .leftMap(err => err: Error)
      .flatMap(_.as[Config])
      .valueOr(throw _)
  }
}
case class TriposoConfig(key: String, secret: String)
case class WWOConfig(key: String)