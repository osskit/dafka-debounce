java_library(
    name = "connect_api",
    exports = [
        "//external:jar/org/apache/kafka/connect_api"
    ],
    runtime_deps = [
        "//3rdparty/jvm/javax/ws/rs:javax_ws_rs_api",
        "//3rdparty/jvm/org/slf4j:slf4j_api",
        ":kafka_clients"
    ],
    visibility = [
        "//3rdparty/jvm:__subpackages__"
    ]
)



java_library(
    name = "connect_json",
    exports = [
        "//external:jar/org/apache/kafka/connect_json"
    ],
    runtime_deps = [
        "//3rdparty/jvm/com/fasterxml/jackson/core:jackson_databind",
        "//3rdparty/jvm/com/fasterxml/jackson/datatype:jackson_datatype_jdk8",
        "//3rdparty/jvm/org/slf4j:slf4j_api",
        ":connect_api"
    ],
    visibility = [
        "//visibility:public"
    ]
)



java_library(
    name = "kafka_clients",
    exports = [
        "//external:jar/org/apache/kafka/kafka_clients"
    ],
    runtime_deps = [
        "//3rdparty/jvm/com/github/luben:zstd_jni",
        "//3rdparty/jvm/org/lz4:lz4_java",
        "//3rdparty/jvm/org/slf4j:slf4j_api",
        "//3rdparty/jvm/org/xerial/snappy:snappy_java"
    ],
    visibility = [
        "//visibility:public"
    ]
)



java_library(
    name = "kafka_streams",
    exports = [
        "//external:jar/org/apache/kafka/kafka_streams"
    ],
    runtime_deps = [
        "//3rdparty/jvm/com/fasterxml/jackson/core:jackson_annotations",
        "//3rdparty/jvm/com/fasterxml/jackson/core:jackson_databind",
        "//3rdparty/jvm/org/rocksdb:rocksdbjni",
        "//3rdparty/jvm/org/slf4j:slf4j_api",
        ":kafka_clients"
    ],
    visibility = [
        "//visibility:public"
    ]
)


