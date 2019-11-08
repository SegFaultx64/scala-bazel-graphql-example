# Do not edit. bazel-deps autogenerates this file from dependencies.yaml.
def _jar_artifact_impl(ctx):
    jar_name = "%s.jar" % ctx.name
    ctx.download(
        output=ctx.path("jar/%s" % jar_name),
        url=ctx.attr.urls,
        sha256=ctx.attr.sha256,
        executable=False
    )
    src_name="%s-sources.jar" % ctx.name
    srcjar_attr=""
    has_sources = len(ctx.attr.src_urls) != 0
    if has_sources:
        ctx.download(
            output=ctx.path("jar/%s" % src_name),
            url=ctx.attr.src_urls,
            sha256=ctx.attr.src_sha256,
            executable=False
        )
        srcjar_attr ='\n    srcjar = ":%s",' % src_name

    build_file_contents = """
package(default_visibility = ['//visibility:public'])
java_import(
    name = 'jar',
    tags = ['maven_coordinates={artifact}'],
    jars = ['{jar_name}'],{srcjar_attr}
)
filegroup(
    name = 'file',
    srcs = [
        '{jar_name}',
        '{src_name}'
    ],
    visibility = ['//visibility:public']
)\n""".format(artifact = ctx.attr.artifact, jar_name = jar_name, src_name = src_name, srcjar_attr = srcjar_attr)
    ctx.file(ctx.path("jar/BUILD"), build_file_contents, False)
    return None

jar_artifact = repository_rule(
    attrs = {
        "artifact": attr.string(mandatory = True),
        "sha256": attr.string(mandatory = True),
        "urls": attr.string_list(mandatory = True),
        "src_sha256": attr.string(mandatory = False, default=""),
        "src_urls": attr.string_list(mandatory = False, default=[]),
    },
    implementation = _jar_artifact_impl
)

def jar_artifact_callback(hash):
    src_urls = []
    src_sha256 = ""
    source=hash.get("source", None)
    if source != None:
        src_urls = [source["url"]]
        src_sha256 = source["sha256"]
    jar_artifact(
        artifact = hash["artifact"],
        name = hash["name"],
        urls = [hash["url"]],
        sha256 = hash["sha256"],
        src_urls = src_urls,
        src_sha256 = src_sha256
    )
    native.bind(name = hash["bind"], actual = hash["actual"])


def list_dependencies():
    return [
    {"artifact": "com.chuusai:shapeless_2.12:2.3.3", "lang": "scala", "sha1": "6041e2c4871650c556a9c6842e43c04ed462b11f", "sha256": "312e301432375132ab49592bd8d22b9cd42a338a6300c6157fb4eafd1e3d5033", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/com/chuusai/shapeless_2.12/2.3.3/shapeless_2.12-2.3.3.jar", "source": {"sha1": "02511271188a92962fcf31a9a217b8122f75453a", "sha256": "2d53fea1b1ab224a4a731d99245747a640deaa6ef3912c253666aa61287f3d63", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/com/chuusai/shapeless_2.12/2.3.3/shapeless_2.12-2.3.3-sources.jar"} , "name": "com_chuusai_shapeless_2_12", "actual": "@com_chuusai_shapeless_2_12//jar:file", "bind": "jar/com/chuusai/shapeless_2_12"},
    {"artifact": "com.softwaremill.sttp.client:core_2.12:2.0.0-M9", "lang": "scala", "sha1": "930c7dbca4f4a4a305ab683dd9ebc90bb9445a7e", "sha256": "8e43a1cd8db4525e1c6673cbe4dcd078e050593d79e403c23b94408b603fed16", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/com/softwaremill/sttp/client/core_2.12/2.0.0-M9/core_2.12-2.0.0-M9.jar", "source": {"sha1": "579c8d0eedc20bb26f19f9135c2c16cc925255e4", "sha256": "85327727c28eb88e275983e9bd3cfe8f9cd3e540572f2f72aa3d427a1948145f", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/com/softwaremill/sttp/client/core_2.12/2.0.0-M9/core_2.12-2.0.0-M9-sources.jar"} , "name": "com_softwaremill_sttp_client_core_2_12", "actual": "@com_softwaremill_sttp_client_core_2_12//jar:file", "bind": "jar/com/softwaremill/sttp/client/core_2_12"},
    {"artifact": "com.softwaremill.sttp.client:model_2.12:2.0.0-M9", "lang": "scala", "sha1": "2090c8c8c0581dcee27a28df1d01787f65727707", "sha256": "70466a620432cacf069c682be581fad254d57fa81cc5f87fd57643051d9bd99e", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/com/softwaremill/sttp/client/model_2.12/2.0.0-M9/model_2.12-2.0.0-M9.jar", "source": {"sha1": "36da5460aac86ce9cbac28502395df175111232d", "sha256": "f991e607aab7f95a5f4e7399a14b7330b9543be9708d3a64e67855e8fb1730c4", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/com/softwaremill/sttp/client/model_2.12/2.0.0-M9/model_2.12-2.0.0-M9-sources.jar"} , "name": "com_softwaremill_sttp_client_model_2_12", "actual": "@com_softwaremill_sttp_client_model_2_12//jar:file", "bind": "jar/com/softwaremill/sttp/client/model_2_12"},
# duplicates in io.circe:circe-core_2.12 fixed to 0.12.3
# - io.circe:circe-generic_2.12:0.12.3 wanted version 0.12.3
# - io.circe:circe-jawn_2.12:0.12.3 wanted version 0.12.3
# - io.circe:circe-parser_2.12:0.12.3 wanted version 0.12.3
# - io.circe:circe-yaml_2.12:0.10.0 wanted version 0.11.1
# - org.sangria-graphql:sangria-circe_2.12:1.3.0 wanted version 0.12.3
    {"artifact": "io.circe:circe-core_2.12:0.12.3", "lang": "scala", "sha1": "30adafb5e4b68aac7d326107e00c8c4149e9806e", "sha256": "76d4f0f17612d3c35edf49d61ce00ba92348700985caa525787d21ff819be4e3", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/io/circe/circe-core_2.12/0.12.3/circe-core_2.12-0.12.3.jar", "source": {"sha1": "a6c8de14c40c1ba1f9cc7adc8e629194e2232508", "sha256": "509b3f559dc8cc6c8078ab38cdd76aa8d0bf5169bb0a23d5548636fa63c7929a", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/io/circe/circe-core_2.12/0.12.3/circe-core_2.12-0.12.3-sources.jar"} , "name": "io_circe_circe_core_2_12", "actual": "@io_circe_circe_core_2_12//jar:file", "bind": "jar/io/circe/circe_core_2_12"},
    {"artifact": "io.circe:circe-generic_2.12:0.12.3", "lang": "scala", "sha1": "b2ca9cb33a6dade0058bd817fed7da68f68e4982", "sha256": "fe6a3be8a9c5d90d3a1c53b31b579f30dffa97492a7e6b09c41806fa314b9b36", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/io/circe/circe-generic_2.12/0.12.3/circe-generic_2.12-0.12.3.jar", "source": {"sha1": "756d3f84019a7f8b48e29013c2cf2365d8398943", "sha256": "a0cb1774578bd3a6a519054860eb7456430d9023af33261d5683e7caf118cb48", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/io/circe/circe-generic_2.12/0.12.3/circe-generic_2.12-0.12.3-sources.jar"} , "name": "io_circe_circe_generic_2_12", "actual": "@io_circe_circe_generic_2_12//jar:file", "bind": "jar/io/circe/circe_generic_2_12"},
    {"artifact": "io.circe:circe-jawn_2.12:0.12.3", "lang": "scala", "sha1": "8cfd44053f9aba6f3c35f462fdc33fbc6c883f11", "sha256": "230426508fc55f5dfc63ccf29b05719a545d73d5ae79c96812e54b748877ff77", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/io/circe/circe-jawn_2.12/0.12.3/circe-jawn_2.12-0.12.3.jar", "source": {"sha1": "4b8214409d530124092b3a6d798b0357d3ba341f", "sha256": "df1c689c8e1cc8a2369ae4fc030a4e559603ec871bcc3d854a99a30eb093408e", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/io/circe/circe-jawn_2.12/0.12.3/circe-jawn_2.12-0.12.3-sources.jar"} , "name": "io_circe_circe_jawn_2_12", "actual": "@io_circe_circe_jawn_2_12//jar:file", "bind": "jar/io/circe/circe_jawn_2_12"},
    {"artifact": "io.circe:circe-numbers_2.12:0.12.3", "lang": "scala", "sha1": "49983243e497138378dc24642e461013d6a545d6", "sha256": "1623d8235150de91054461d8b5390dd32ab8dc133f3005ed06179599423d6576", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/io/circe/circe-numbers_2.12/0.12.3/circe-numbers_2.12-0.12.3.jar", "source": {"sha1": "b14407190ba24de9bc1f9077a5a6844799d0a4ac", "sha256": "11e59be9c076c02ba3fb1b439abfbdda6cb5871e749fddfe3437b94f72afe0ef", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/io/circe/circe-numbers_2.12/0.12.3/circe-numbers_2.12-0.12.3-sources.jar"} , "name": "io_circe_circe_numbers_2_12", "actual": "@io_circe_circe_numbers_2_12//jar:file", "bind": "jar/io/circe/circe_numbers_2_12"},
    {"artifact": "io.circe:circe-parser_2.12:0.12.3", "lang": "scala", "sha1": "1ca756f9fcc261e89823a85ea4476b8d414c85ce", "sha256": "c6b25097bb54710df9411835798ca40ce8f52e14a4c2630b930a119045bbc930", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/io/circe/circe-parser_2.12/0.12.3/circe-parser_2.12-0.12.3.jar", "source": {"sha1": "96f8d44bcafe4b45a12baf813bd4d31387ab0b90", "sha256": "ec6065753332e81790806839d3dd8d22a61fdc08ea5edef741011e4ec179a32d", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/io/circe/circe-parser_2.12/0.12.3/circe-parser_2.12-0.12.3-sources.jar"} , "name": "io_circe_circe_parser_2_12", "actual": "@io_circe_circe_parser_2_12//jar:file", "bind": "jar/io/circe/circe_parser_2_12"},
    {"artifact": "io.circe:circe-yaml_2.12:0.10.0", "lang": "scala", "sha1": "26cf4031481709361967b0f97846885e62c803c7", "sha256": "72948d62ed794c3ea97cbf7411a4a0b4d85bc4114cc09e454cad49fe3b6277c0", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/io/circe/circe-yaml_2.12/0.10.0/circe-yaml_2.12-0.10.0.jar", "source": {"sha1": "cc3d233e89d9f7b604da5414eeaa30bbed7711c1", "sha256": "2c5ca14d1ecd8c8f69b1d1d41c64abf30d6ad56d938a844c6fa4eb7b087c759b", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/io/circe/circe-yaml_2.12/0.10.0/circe-yaml_2.12-0.10.0-sources.jar"} , "name": "io_circe_circe_yaml_2_12", "actual": "@io_circe_circe_yaml_2_12//jar:file", "bind": "jar/io/circe/circe_yaml_2_12"},
    {"artifact": "org.parboiled:parboiled_2.12:2.1.8", "lang": "scala", "sha1": "6943b39efb08faf127f5afa10a03c392e22c1209", "sha256": "c2ff500fe1df7544b8f7f267ed040edd3205cb8dc10b916e17d74c600d356a11", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/parboiled/parboiled_2.12/2.1.8/parboiled_2.12-2.1.8.jar", "source": {"sha1": "1d3aeb00623e402c54336d994661e2f2d80d3d02", "sha256": "b66000a3a40d616f6d95dd83d2692c79ce8f47c18e49b26e9dd19892d76f8e27", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/parboiled/parboiled_2.12/2.1.8/parboiled_2.12-2.1.8-sources.jar"} , "name": "org_parboiled_parboiled_2_12", "actual": "@org_parboiled_parboiled_2_12//jar:file", "bind": "jar/org/parboiled/parboiled_2_12"},
    {"artifact": "org.sangria-graphql:macro-visit_2.12:0.1.2", "lang": "scala", "sha1": "8ff423ec74dfee284daa237358161d370d14ebc0", "sha256": "48b674d4aecc153336b53d8b5df047e32dc9b75f4fb7638f6281ab55d37b77de", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/sangria-graphql/macro-visit_2.12/0.1.2/macro-visit_2.12-0.1.2.jar", "source": {"sha1": "6e8135c95ca2fc37e3952e287cec56271f4f6965", "sha256": "d82d6560a8adaf12b7280a9ced4afe84714e14515d35a983533f3843e545dfb2", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/sangria-graphql/macro-visit_2.12/0.1.2/macro-visit_2.12-0.1.2-sources.jar"} , "name": "org_sangria_graphql_macro_visit_2_12", "actual": "@org_sangria_graphql_macro_visit_2_12//jar:file", "bind": "jar/org/sangria_graphql/macro_visit_2_12"},
    {"artifact": "org.sangria-graphql:sangria-circe_2.12:1.3.0", "lang": "scala", "sha1": "1d5b6ff6cbd5c294fd88fe5516b485e39b9c3ee8", "sha256": "e2e85712ad7ca999dc4cd6bee922f4ef2fc63d3da6cd065e59c1da29034d1479", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/sangria-graphql/sangria-circe_2.12/1.3.0/sangria-circe_2.12-1.3.0.jar", "source": {"sha1": "c629bebd2d2d311d4ed3420a2487cc2d636d9fd7", "sha256": "82122064a37126d366d1511f9766825844a8e9f7295903d8ec5c2c89ea1386ef", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/sangria-graphql/sangria-circe_2.12/1.3.0/sangria-circe_2.12-1.3.0-sources.jar"} , "name": "org_sangria_graphql_sangria_circe_2_12", "actual": "@org_sangria_graphql_sangria_circe_2_12//jar:file", "bind": "jar/org/sangria_graphql/sangria_circe_2_12"},
    {"artifact": "org.sangria-graphql:sangria-marshalling-api_2.12:1.0.4", "lang": "scala", "sha1": "2a0097888c5578e9dddfb3088adc6b1c70be627c", "sha256": "322dd7e4a4b60dae8dc1b68035eee2344bfd7583e4824da5981207359cc8b577", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/sangria-graphql/sangria-marshalling-api_2.12/1.0.4/sangria-marshalling-api_2.12-1.0.4.jar", "source": {"sha1": "3ec03d13785505dabe81c058c9ee5c8235fc01e9", "sha256": "3106842c6d0f9a01a2f0909276270e1e5f246ad756543238c32f555b74c38335", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/sangria-graphql/sangria-marshalling-api_2.12/1.0.4/sangria-marshalling-api_2.12-1.0.4-sources.jar"} , "name": "org_sangria_graphql_sangria_marshalling_api_2_12", "actual": "@org_sangria_graphql_sangria_marshalling_api_2_12//jar:file", "bind": "jar/org/sangria_graphql/sangria_marshalling_api_2_12"},
    {"artifact": "org.sangria-graphql:sangria-streaming-api_2.12:1.0.1", "lang": "scala", "sha1": "0561c016f27853b364313d3b31cad62c406618ad", "sha256": "56a871278e4e20477e689199652504f0797e8e42fa003c74e4ee190c04dd3ca0", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/sangria-graphql/sangria-streaming-api_2.12/1.0.1/sangria-streaming-api_2.12-1.0.1.jar", "source": {"sha1": "53af33d223fc1e2df98d84eda0effb956bc2667a", "sha256": "4ea1080e85cd4d19775c1b5a1939d1eb59b2b080e190b5287c0258a2e08e8c74", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/sangria-graphql/sangria-streaming-api_2.12/1.0.1/sangria-streaming-api_2.12-1.0.1-sources.jar"} , "name": "org_sangria_graphql_sangria_streaming_api_2_12", "actual": "@org_sangria_graphql_sangria_streaming_api_2_12//jar:file", "bind": "jar/org/sangria_graphql/sangria_streaming_api_2_12"},
    {"artifact": "org.sangria-graphql:sangria_2.12:2.0.0-M1", "lang": "scala", "sha1": "8dd223a61f7fbb7e13f49c7740a915c93f982b19", "sha256": "66cfbb0c5db788d8ca2a8f26c96390d8cb0f37678d36da83a4d6d231eed348eb", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/sangria-graphql/sangria_2.12/2.0.0-M1/sangria_2.12-2.0.0-M1.jar", "source": {"sha1": "cb97568453fdb80012c1cfd9e155a5d361e05450", "sha256": "bd65cbb4a2cc60e11e576b873ecf90ef163a06027318fee3d09c0abfb01e2bc4", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/sangria-graphql/sangria_2.12/2.0.0-M1/sangria_2.12-2.0.0-M1-sources.jar"} , "name": "org_sangria_graphql_sangria_2_12", "actual": "@org_sangria_graphql_sangria_2_12//jar:file", "bind": "jar/org/sangria_graphql/sangria_2_12"},
    {"artifact": "org.typelevel:cats-core_2.12:2.0.0", "lang": "scala", "sha1": "b15de4ed2b0f31b118acab7d12cab4962df2130c", "sha256": "65d828985463e6f14761a6451b419044b9f06507f292ac7ebc04133912b01339", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/typelevel/cats-core_2.12/2.0.0/cats-core_2.12-2.0.0.jar", "source": {"sha1": "b5f015d7c5908c4b68d01927f38a49e1906060e7", "sha256": "e6c7b838d4734acba23df9bf3e633300cbe998bcf724c8fcb2a5f1e866585505", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/typelevel/cats-core_2.12/2.0.0/cats-core_2.12-2.0.0-sources.jar"} , "name": "org_typelevel_cats_core_2_12", "actual": "@org_typelevel_cats_core_2_12//jar:file", "bind": "jar/org/typelevel/cats_core_2_12"},
    {"artifact": "org.typelevel:cats-kernel_2.12:2.0.0", "lang": "scala", "sha1": "c570a566ca5ed9def6f73adc2308d9d3260f49d5", "sha256": "e9d8fa3381b3d8e66261437227f9c926a5a4109c4448f6c4bb98f9575e9c38c5", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/typelevel/cats-kernel_2.12/2.0.0/cats-kernel_2.12-2.0.0.jar", "source": {"sha1": "f9c9abdbad4849b79a80c01ac653493e776a1b57", "sha256": "7ba77aea45ba5685cf9ada6437ef56fe726af09ccd8f3f48ecb842479d1c2eee", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/typelevel/cats-kernel_2.12/2.0.0/cats-kernel_2.12-2.0.0-sources.jar"} , "name": "org_typelevel_cats_kernel_2_12", "actual": "@org_typelevel_cats_kernel_2_12//jar:file", "bind": "jar/org/typelevel/cats_kernel_2_12"},
    {"artifact": "org.typelevel:cats-macros_2.12:2.0.0", "lang": "scala", "sha1": "5b86236c7f39ae44a5b26b552283fe678aaff449", "sha256": "f730fcd0d679e7e13a56a2b5777f53204456a934d90ffc3be4d6bb10ce19919a", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/typelevel/cats-macros_2.12/2.0.0/cats-macros_2.12-2.0.0.jar", "source": {"sha1": "aaded5d8dc45e1ae9fd2f41045dacb60df5ff9cc", "sha256": "ef8a1aeb76e02f62f3b546ff74734da3991d304552bbcef1715f34dd02160049", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/typelevel/cats-macros_2.12/2.0.0/cats-macros_2.12-2.0.0-sources.jar"} , "name": "org_typelevel_cats_macros_2_12", "actual": "@org_typelevel_cats_macros_2_12//jar:file", "bind": "jar/org/typelevel/cats_macros_2_12"},
    {"artifact": "org.typelevel:jawn-parser_2.12:0.14.2", "lang": "scala", "sha1": "47c7bbb52a7b5c6b652c9ca8fcd60dc5e3583c2c", "sha256": "0b95b9089ec3bb42384abff52e0e3087a05710a69b50d708e106ab280684a270", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/typelevel/jawn-parser_2.12/0.14.2/jawn-parser_2.12-0.14.2.jar", "source": {"sha1": "5bcc7d5b81693ab5244834d7fa98f28eba383466", "sha256": "fe6e9bdb096fa8a1eddc80b9ea9619b25f17f7fd34d395cc2b675c4e97e18959", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/typelevel/jawn-parser_2.12/0.14.2/jawn-parser_2.12-0.14.2-sources.jar"} , "name": "org_typelevel_jawn_parser_2_12", "actual": "@org_typelevel_jawn_parser_2_12//jar:file", "bind": "jar/org/typelevel/jawn_parser_2_12"},
    {"artifact": "org.typelevel:macro-compat_2.12:1.1.1", "lang": "scala", "sha1": "ed809d26ef4237d7c079ae6cf7ebd0dfa7986adf", "sha256": "8b1514ec99ac9c7eded284367b6c9f8f17a097198a44e6f24488706d66bbd2b8", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/typelevel/macro-compat_2.12/1.1.1/macro-compat_2.12-1.1.1.jar", "source": {"sha1": "ade6d6ec81975cf514b0f9e2061614f2799cfe97", "sha256": "c748cbcda2e8828dd25e788617a4c559abf92960ef0f92f9f5d3ea67774c34c8", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/typelevel/macro-compat_2.12/1.1.1/macro-compat_2.12-1.1.1-sources.jar"} , "name": "org_typelevel_macro_compat_2_12", "actual": "@org_typelevel_macro_compat_2_12//jar:file", "bind": "jar/org/typelevel/macro_compat_2_12"},
    {"artifact": "org.yaml:snakeyaml:1.24", "lang": "java", "sha1": "13a9c0d6776483c3876e3ff9384f9bb55b17001b", "sha256": "d3f7f09989d5b0ce5c4791818ef937ee7663f1e359c2ef2d312f938aad0763da", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/yaml/snakeyaml/1.24/snakeyaml-1.24.jar", "source": {"sha1": "a394a18181ce1d4d429be7ec38fc9497dc1a1f88", "sha256": "2ca4a62e017fb92f4ddd57692a71dfe2be23a2482bf0bd8b6821a08506fe04fe", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/yaml/snakeyaml/1.24/snakeyaml-1.24-sources.jar"} , "name": "org_yaml_snakeyaml", "actual": "@org_yaml_snakeyaml//jar", "bind": "jar/org/yaml/snakeyaml"},
    ]

def maven_dependencies(callback = jar_artifact_callback):
    for hash in list_dependencies():
        callback(hash)
