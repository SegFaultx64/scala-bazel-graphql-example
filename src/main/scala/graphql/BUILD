load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library", "scala_binary", "scala_test")

scala_library(
    name = "graphql",
    srcs = glob(["*.scala"]),
    visibility = ["//visibility:public"],
    deps = [
        "//3rdparty/jvm/org/sangria_graphql:sangria",
        "//src/main/scala/services",
        "//src/main/scala/models",
    ],
)