load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library", "scala_binary", "scala_test")

scala_binary(
    name = "trip-app",
    srcs = glob(["*.scala"]),
    deps = [
        "//src/main/scala/services",
        "//src/main/scala/models",
        "//src/main/scala/graphql",
        "//src/main/scala/config",
        "//3rdparty/jvm/com/softwaremill/sttp/client:core",
        "//3rdparty/jvm/io/circe:circe_core",
        "//3rdparty/jvm/io/circe:circe_yaml",
        "//3rdparty/jvm/io/circe:circe_generic",
        "//3rdparty/jvm/io/circe:circe_parser",
        "//3rdparty/jvm/com/chuusai:shapeless",
        "//3rdparty/jvm/org/typelevel:cats_core",
        "//3rdparty/jvm/org/sangria_graphql:sangria",
        "//3rdparty/jvm/org/sangria_graphql:sangria_circe",
        "//3rdparty/jvm/com/typesafe/akka:akka_http",
        "//3rdparty/jvm/com/typesafe/akka:akka_stream",
        "//3rdparty/jvm/de/heikoseeberger:akka_http_circe",
    ],
    main_class = "main.Main",
    visibility = ["//visibility:public"],
)