load("@io_bazel_rules_scala//scala:scala_import.bzl", "scala_import")
load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library", "scala_binary", "scala_test")
scala_import(
    name = "akka_actor",
    exports = [
        "//3rdparty/jvm/com/typesafe:config",
        "//3rdparty/jvm/org/scala_lang/modules:scala_java8_compat",
        "//3rdparty/jvm/org/scala_lang:scala_library"
    ],
    jars = [
        "//external:jar/com/typesafe/akka/akka_actor_2_12"
    ],
    visibility = [
        "//3rdparty/jvm:__subpackages__"
    ]
)



scala_import(
    name = "akka_http",
    exports = [
        "//3rdparty/jvm/org/scala_lang:scala_library",
        ":akka_http_core"
    ],
    jars = [
        "//external:jar/com/typesafe/akka/akka_http_2_12"
    ],
    visibility = [
        "//visibility:public"
    ]
)



scala_import(
    name = "akka_http_core",
    exports = [
        "//3rdparty/jvm/org/scala_lang:scala_library",
        ":akka_parsing"
    ],
    jars = [
        "//external:jar/com/typesafe/akka/akka_http_core_2_12"
    ],
    visibility = [
        "//3rdparty/jvm:__subpackages__"
    ]
)



scala_import(
    name = "akka_parsing",
    exports = [
        "//3rdparty/jvm/org/scala_lang:scala_library"
    ],
    jars = [
        "//external:jar/com/typesafe/akka/akka_parsing_2_12"
    ],
    visibility = [
        "//3rdparty/jvm:__subpackages__"
    ]
)



scala_import(
    name = "akka_protobuf",
    exports = [
        "//3rdparty/jvm/org/scala_lang:scala_library"
    ],
    jars = [
        "//external:jar/com/typesafe/akka/akka_protobuf_2_12"
    ],
    visibility = [
        "//3rdparty/jvm:__subpackages__"
    ]
)



scala_import(
    name = "akka_stream",
    exports = [
        "//3rdparty/jvm/com/typesafe:ssl_config_core",
        "//3rdparty/jvm/org/reactivestreams:reactive_streams",
        "//3rdparty/jvm/org/scala_lang:scala_library",
        ":akka_actor",
        ":akka_protobuf"
    ],
    jars = [
        "//external:jar/com/typesafe/akka/akka_stream_2_12"
    ],
    visibility = [
        "//visibility:public"
    ]
)


