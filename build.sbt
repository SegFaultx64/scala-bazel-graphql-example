// Only needed for metals

scalaVersion := "2.12.8"

name := "scala-bazel-graphql-example"
organization := "me.maxwalker"
version := "1.0"

libraryDependencies += "org.typelevel" %% "cats-core" % "2.0.0"
libraryDependencies += "com.softwaremill.sttp.client" %% "core" % "2.0.0-M9"
libraryDependencies += "io.circe" % "circe-core_2.12" % "0.12.3"
libraryDependencies += "io.circe" % "circe-generic_2.12" % "0.12.3"
libraryDependencies += "io.circe" % "circe-parser_2.12" % "0.12.3"
libraryDependencies += "org.sangria-graphql" % "sangria_2.12" % "2.0.0-M1"
libraryDependencies += "org.sangria-graphql" % "sangria-circe_2.12" % "1.3.0"
libraryDependencies += "io.circe" %% "circe-yaml" % "0.10.0"
libraryDependencies += "org.scalatest" %% "scalatest" % "3.0.8"

libraryDependencies += "com.typesafe.akka" %% "akka-http" % "10.1.10"
libraryDependencies += "de.heikoseeberger" %% "akka-http-circe" % "1.29.1"
