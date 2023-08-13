# Do not edit. bazel-deps autogenerates this file from.
_JAVA_LIBRARY_TEMPLATE = """
java_library(
  name = "{name}",
  exports = [
      {exports}
  ],
  runtime_deps = [
    {runtime_deps}
  ],
  visibility = [
      "{visibility}"
  ]
)\n"""

_SCALA_IMPORT_TEMPLATE = """
scala_import(
    name = "{name}",
    exports = [
        {exports}
    ],
    jars = [
        {jars}
    ],
    runtime_deps = [
        {runtime_deps}
    ],
    visibility = [
        "{visibility}"
    ]
)
"""

_SCALA_LIBRARY_TEMPLATE = """
scala_library(
    name = "{name}",
    exports = [
        {exports}
    ],
    runtime_deps = [
        {runtime_deps}
    ],
    visibility = [
        "{visibility}"
    ]
)
"""


def _build_external_workspace_from_opts_impl(ctx):
    build_header = ctx.attr.build_header
    separator = ctx.attr.separator
    target_configs = ctx.attr.target_configs

    result_dict = {}
    for key, cfg in target_configs.items():
      build_file_to_target_name = key.split(":")
      build_file = build_file_to_target_name[0]
      target_name = build_file_to_target_name[1]
      if build_file not in result_dict:
        result_dict[build_file] = []
      result_dict[build_file].append(cfg)

    for key, file_entries in result_dict.items():
      build_file_contents = build_header + '\n\n'
      for build_target in file_entries:
        entry_map = {}
        for entry in build_target:
          elements = entry.split(separator)
          build_entry_key = elements[0]
          if elements[1] == "L":
            entry_map[build_entry_key] = [e for e in elements[2::] if len(e) > 0]
          elif elements[1] == "B":
            entry_map[build_entry_key] = (elements[2] == "true" or elements[2] == "True")
          else:
            entry_map[build_entry_key] = elements[2]

        exports_str = ""
        for e in entry_map.get("exports", []):
          exports_str += "\"" + e + "\",\n"

        jars_str = ""
        for e in entry_map.get("jars", []):
          jars_str += "\"" + e + "\",\n"

        runtime_deps_str = ""
        for e in entry_map.get("runtimeDeps", []):
          runtime_deps_str += "\"" + e + "\",\n"

        name = entry_map["name"].split(":")[1]
        if entry_map["lang"] == "java":
            build_file_contents += _JAVA_LIBRARY_TEMPLATE.format(name = name, exports=exports_str, runtime_deps=runtime_deps_str, visibility=entry_map["visibility"])
        elif entry_map["lang"].startswith("scala") and entry_map["kind"] == "import":
            build_file_contents += _SCALA_IMPORT_TEMPLATE.format(name = name, exports=exports_str, jars=jars_str, runtime_deps=runtime_deps_str, visibility=entry_map["visibility"])
        elif entry_map["lang"].startswith("scala") and entry_map["kind"] == "library":
            build_file_contents += _SCALA_LIBRARY_TEMPLATE.format(name = name, exports=exports_str, runtime_deps=runtime_deps_str, visibility=entry_map["visibility"])
        else:
            print(entry_map)

      ctx.file(ctx.path(key + "/BUILD"), build_file_contents, False)
    return None

build_external_workspace_from_opts = repository_rule(
    attrs = {
        "target_configs": attr.string_list_dict(mandatory = True),
        "separator": attr.string(mandatory = True),
        "build_header": attr.string(mandatory = True),
    },
    implementation = _build_external_workspace_from_opts_impl
)




def build_header():
 return """"""

def list_target_data_separator():
 return "|||"

def list_target_data():
    return {
"3rdparty/jvm/ch/qos/logback:logback_classic": ["lang||||||java","name||||||//3rdparty/jvm/ch/qos/logback:logback_classic","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/ch/qos/logback/logback_classic","runtimeDeps|||L|||//3rdparty/jvm/ch/qos/logback:logback_core|||//3rdparty/jvm/org/slf4j:slf4j_api","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/ch/qos/logback:logback_core": ["lang||||||java","name||||||//3rdparty/jvm/ch/qos/logback:logback_core","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/ch/qos/logback/logback_core","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/ch/qos/logback/contrib:logback_jackson": ["lang||||||java","name||||||//3rdparty/jvm/ch/qos/logback/contrib:logback_jackson","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/ch/qos/logback/contrib/logback_jackson","runtimeDeps|||L|||//3rdparty/jvm/ch/qos/logback/contrib:logback_json_core","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/ch/qos/logback/contrib:logback_json_classic": ["lang||||||java","name||||||//3rdparty/jvm/ch/qos/logback/contrib:logback_json_classic","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/ch/qos/logback/contrib/logback_json_classic","runtimeDeps|||L|||//3rdparty/jvm/ch/qos/logback:logback_classic|||//3rdparty/jvm/ch/qos/logback/contrib:logback_json_core","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/ch/qos/logback/contrib:logback_json_core": ["lang||||||java","name||||||//3rdparty/jvm/ch/qos/logback/contrib:logback_json_core","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/ch/qos/logback/contrib/logback_json_core","runtimeDeps|||L|||//3rdparty/jvm/ch/qos/logback:logback_core","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/fasterxml/jackson/core:jackson_annotations": ["lang||||||java","name||||||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_annotations","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/com/fasterxml/jackson/core/jackson_annotations","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/fasterxml/jackson/core:jackson_core": ["lang||||||java","name||||||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_core","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/com/fasterxml/jackson/core/jackson_core","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/fasterxml/jackson/core:jackson_databind": ["lang||||||java","name||||||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_databind","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/com/fasterxml/jackson/core/jackson_databind","runtimeDeps|||L|||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_core|||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_annotations","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/fasterxml/jackson/datatype:jackson_datatype_jdk8": ["lang||||||java","name||||||//3rdparty/jvm/com/fasterxml/jackson/datatype:jackson_datatype_jdk8","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/com/fasterxml/jackson/datatype/jackson_datatype_jdk8","runtimeDeps|||L|||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_core|||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_databind","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/github/luben:zstd_jni": ["lang||||||java","name||||||//3rdparty/jvm/com/github/luben:zstd_jni","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/com/github/luben/zstd_jni","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/google/code/findbugs:jsr305": ["lang||||||java","name||||||//3rdparty/jvm/com/google/code/findbugs:jsr305","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/com/google/code/findbugs/jsr305","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/google/errorprone:error_prone_annotations": ["lang||||||java","name||||||//3rdparty/jvm/com/google/errorprone:error_prone_annotations","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/com/google/errorprone/error_prone_annotations","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/google/guava:failureaccess": ["lang||||||java","name||||||//3rdparty/jvm/com/google/guava:failureaccess","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/com/google/guava/failureaccess","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/google/guava:guava": ["lang||||||java","name||||||//3rdparty/jvm/com/google/guava:guava","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/com/google/guava/guava","runtimeDeps|||L|||//3rdparty/jvm/com/google/errorprone:error_prone_annotations|||//3rdparty/jvm/com/google/guava:failureaccess|||//3rdparty/jvm/com/google/code/findbugs:jsr305|||//3rdparty/jvm/org/codehaus/mojo:animal_sniffer_annotations|||//3rdparty/jvm/com/google/guava:listenablefuture|||//3rdparty/jvm/com/google/j2objc:j2objc_annotations|||//3rdparty/jvm/org/checkerframework:checker_qual","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/google/guava:listenablefuture": ["lang||||||java","name||||||//3rdparty/jvm/com/google/guava:listenablefuture","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/com/google/guava/listenablefuture","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/google/j2objc:j2objc_annotations": ["lang||||||java","name||||||//3rdparty/jvm/com/google/j2objc:j2objc_annotations","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/com/google/j2objc/j2objc_annotations","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/io/github/cdimascio:java_dotenv": ["lang||||||java","name||||||//3rdparty/jvm/io/github/cdimascio:java_dotenv","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/io/github/cdimascio/java_dotenv","runtimeDeps|||L|||//3rdparty/jvm/org/jetbrains/kotlin:kotlin_stdlib","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/io/prometheus:simpleclient": ["lang||||||java","name||||||//3rdparty/jvm/io/prometheus:simpleclient","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/io/prometheus/simpleclient","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/io/prometheus:simpleclient_common": ["lang||||||java","name||||||//3rdparty/jvm/io/prometheus:simpleclient_common","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/io/prometheus/simpleclient_common","runtimeDeps|||L|||//3rdparty/jvm/io/prometheus:simpleclient","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/io/prometheus:simpleclient_hotspot": ["lang||||||java","name||||||//3rdparty/jvm/io/prometheus:simpleclient_hotspot","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/io/prometheus/simpleclient_hotspot","runtimeDeps|||L|||//3rdparty/jvm/io/prometheus:simpleclient","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/io/prometheus:simpleclient_httpserver": ["lang||||||java","name||||||//3rdparty/jvm/io/prometheus:simpleclient_httpserver","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/io/prometheus/simpleclient_httpserver","runtimeDeps|||L|||//3rdparty/jvm/io/prometheus:simpleclient|||//3rdparty/jvm/io/prometheus:simpleclient_common","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/javax/ws/rs:javax_ws_rs_api": ["lang||||||java","name||||||//3rdparty/jvm/javax/ws/rs:javax_ws_rs_api","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/javax/ws/rs/javax_ws_rs_api","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/apache/kafka:connect_api": ["lang||||||java","name||||||//3rdparty/jvm/org/apache/kafka:connect_api","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/org/apache/kafka/connect_api","runtimeDeps|||L|||//3rdparty/jvm/org/apache/kafka:kafka_clients|||//3rdparty/jvm/org/slf4j:slf4j_api|||//3rdparty/jvm/javax/ws/rs:javax_ws_rs_api","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/apache/kafka:connect_json": ["lang||||||java","name||||||//3rdparty/jvm/org/apache/kafka:connect_json","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/org/apache/kafka/connect_json","runtimeDeps|||L|||//3rdparty/jvm/org/apache/kafka:connect_api|||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_databind|||//3rdparty/jvm/com/fasterxml/jackson/datatype:jackson_datatype_jdk8|||//3rdparty/jvm/org/slf4j:slf4j_api","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/apache/kafka:kafka_clients": ["lang||||||java","name||||||//3rdparty/jvm/org/apache/kafka:kafka_clients","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/org/apache/kafka/kafka_clients","runtimeDeps|||L|||//3rdparty/jvm/org/slf4j:slf4j_api|||//3rdparty/jvm/org/xerial/snappy:snappy_java|||//3rdparty/jvm/org/lz4:lz4_java|||//3rdparty/jvm/com/github/luben:zstd_jni","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/apache/kafka:kafka_streams": ["lang||||||java","name||||||//3rdparty/jvm/org/apache/kafka:kafka_streams","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/org/apache/kafka/kafka_streams","runtimeDeps|||L|||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_annotations|||//3rdparty/jvm/org/slf4j:slf4j_api|||//3rdparty/jvm/org/rocksdb:rocksdbjni|||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_databind|||//3rdparty/jvm/org/apache/kafka:kafka_clients","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/checkerframework:checker_qual": ["lang||||||java","name||||||//3rdparty/jvm/org/checkerframework:checker_qual","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/org/checkerframework/checker_qual","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/codehaus/mojo:animal_sniffer_annotations": ["lang||||||java","name||||||//3rdparty/jvm/org/codehaus/mojo:animal_sniffer_annotations","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/org/codehaus/mojo/animal_sniffer_annotations","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/jetbrains:annotations": ["lang||||||java","name||||||//3rdparty/jvm/org/jetbrains:annotations","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/org/jetbrains/annotations","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/jetbrains/kotlin:kotlin_stdlib": ["lang||||||java","name||||||//3rdparty/jvm/org/jetbrains/kotlin:kotlin_stdlib","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/org/jetbrains/kotlin/kotlin_stdlib","runtimeDeps|||L|||//3rdparty/jvm/org/jetbrains/kotlin:kotlin_stdlib_common|||//3rdparty/jvm/org/jetbrains:annotations","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/jetbrains/kotlin:kotlin_stdlib_common": ["lang||||||java","name||||||//3rdparty/jvm/org/jetbrains/kotlin:kotlin_stdlib_common","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/org/jetbrains/kotlin/kotlin_stdlib_common","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/json:json": ["lang||||||java","name||||||//3rdparty/jvm/org/json:json","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/org/json/json","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/lz4:lz4_java": ["lang||||||java","name||||||//3rdparty/jvm/org/lz4:lz4_java","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/org/lz4/lz4_java","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/rocksdb:rocksdbjni": ["lang||||||java","name||||||//3rdparty/jvm/org/rocksdb:rocksdbjni","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/org/rocksdb/rocksdbjni","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/slf4j:slf4j_api": ["lang||||||java","name||||||//3rdparty/jvm/org/slf4j:slf4j_api","visibility||||||//visibility:public","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/org/slf4j/slf4j_api","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/xerial/snappy:snappy_java": ["lang||||||java","name||||||//3rdparty/jvm/org/xerial/snappy:snappy_java","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||//external:jar/org/xerial/snappy/snappy_java","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"]
 }


def build_external_workspace(name):
  return build_external_workspace_from_opts(name = name, target_configs = list_target_data(), separator = list_target_data_separator(), build_header = build_header())

