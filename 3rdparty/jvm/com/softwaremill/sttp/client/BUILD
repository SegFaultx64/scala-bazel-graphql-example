load("@io_bazel_rules_scala//scala:scala_import.bzl", "scala_import")
load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library", "scala_binary", "scala_test")
scala_import(
    name = "core",
    exports = [
        "//3rdparty/jvm/org/scala_lang:scala_library",
        ":model"
    ],
    jars = [
        "//external:jar/com/softwaremill/sttp/client/core_2_12"
    ],
    visibility = [
        "//visibility:public"
    ]
)



scala_import(
    name = "model",
    exports = [
        "//3rdparty/jvm/org/scala_lang:scala_library"
    ],
    jars = [
        "//external:jar/com/softwaremill/sttp/client/model_2_12"
    ],
    visibility = [
        "//3rdparty/jvm:__subpackages__"
    ]
)


