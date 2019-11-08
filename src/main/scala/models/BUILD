load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library", "scala_binary", "scala_test")

scala_library(
    name = "models",
    srcs = glob(["*.scala"]),
    visibility = ["//visibility:public"],
    deps = [
        "//src/main/scala/services",
        "//3rdparty/jvm/com/softwaremill/sttp/client:core",
        "//3rdparty/jvm/io/circe:circe_core",
        "//3rdparty/jvm/io/circe:circe_generic",
        "//3rdparty/jvm/io/circe:circe_parser",
        "//3rdparty/jvm/com/chuusai:shapeless",
        "//3rdparty/jvm/org/typelevel:cats_core"
    ],
)