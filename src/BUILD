load("@io_bazel_rules_docker//java:image.bzl", "java_image")

java_library(
    name = "lib",
    srcs = glob(["main/java/**/*.java"]),
    resources = glob(["main/resources/*"]),
    deps = [
        "@third_party//3rdparty/jvm/ch/qos/logback:logback_core",
        "@third_party//3rdparty/jvm/ch/qos/logback/contrib:logback_jackson",
        "@third_party//3rdparty/jvm/ch/qos/logback/contrib:logback_json_classic",
        "@third_party//3rdparty/jvm/com/fasterxml/jackson/core:jackson_databind",
        "@third_party//3rdparty/jvm/com/fasterxml/jackson/core:jackson_core",
        "@third_party//3rdparty/jvm/com/google/guava",
        "@third_party//3rdparty/jvm/io/github/cdimascio:java_dotenv",
        "@third_party//3rdparty/jvm/io/prometheus:simpleclient",
        "@third_party//3rdparty/jvm/io/prometheus:simpleclient_hotspot",
        "@third_party//3rdparty/jvm/io/prometheus:simpleclient_httpserver",
        "@third_party//3rdparty/jvm/org/jetbrains:annotations",
        "@third_party//3rdparty/jvm/org/json",
        "@third_party//3rdparty/jvm/org/apache/kafka:kafka_streams",
        "@third_party//3rdparty/jvm/org/apache/kafka:kafka_clients",
        "@third_party//3rdparty/jvm/org/apache/kafka:connect_json",
        "@third_party//3rdparty/jvm/org/slf4j:slf4j_api",
        "@third_party//3rdparty/jvm/org/rocksdb:rocksdbjni",
    ],
)

java_image(
    name = "image",
    base = "@java_base_image//image",
    main_class = "src.main.java.Main",
    runtime_deps = [":lib"],
)
