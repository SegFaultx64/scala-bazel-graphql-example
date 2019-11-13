load("@io_bazel_rules_scala//scala:scala.bzl", "scala_test")

scala_test(
    name = "caching",
    srcs = glob(["*.scala"]),
    visibility = ["//visibility:public"],
    deps = [
        "//src/main/scala/services",
        "//3rdparty/jvm/org/scalatest:scalatest"
    ]
)