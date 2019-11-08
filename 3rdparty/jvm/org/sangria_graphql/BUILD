load("@io_bazel_rules_scala//scala:scala_import.bzl", "scala_import")
load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library", "scala_binary", "scala_test")
scala_import(
    name = "macro_visit",
    exports = [
        "//3rdparty/jvm/org/scala_lang:scala_library",
        "//3rdparty/jvm/org/scala_lang:scala_reflect"
    ],
    jars = [
        "//external:jar/org/sangria_graphql/macro_visit_2_12"
    ],
    visibility = [
        "//3rdparty/jvm:__subpackages__"
    ]
)



scala_import(
    name = "sangria",
    exports = [
        "//3rdparty/jvm/org/parboiled:parboiled",
        "//3rdparty/jvm/org/scala_lang:scala_library",
        "//3rdparty/jvm/org/scala_lang:scala_reflect",
        ":macro_visit",
        ":sangria_marshalling_api",
        ":sangria_streaming_api"
    ],
    jars = [
        "//external:jar/org/sangria_graphql/sangria_2_12"
    ],
    visibility = [
        "//visibility:public"
    ]
)



scala_import(
    name = "sangria_circe",
    exports = [
        "//3rdparty/jvm/io/circe:circe_core",
        "//3rdparty/jvm/org/scala_lang:scala_library",
        ":sangria_marshalling_api"
    ],
    jars = [
        "//external:jar/org/sangria_graphql/sangria_circe_2_12"
    ],
    visibility = [
        "//visibility:public"
    ]
)



scala_import(
    name = "sangria_marshalling_api",
    exports = [
        "//3rdparty/jvm/org/scala_lang:scala_library"
    ],
    jars = [
        "//external:jar/org/sangria_graphql/sangria_marshalling_api_2_12"
    ],
    visibility = [
        "//3rdparty/jvm:__subpackages__"
    ]
)



scala_import(
    name = "sangria_streaming_api",
    exports = [
        "//3rdparty/jvm/org/scala_lang:scala_library"
    ],
    jars = [
        "//external:jar/org/sangria_graphql/sangria_streaming_api_2_12"
    ],
    visibility = [
        "//3rdparty/jvm:__subpackages__"
    ]
)


