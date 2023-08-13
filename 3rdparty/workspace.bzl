# Do not edit. bazel-deps autogenerates this file from dependencies.yaml.
def _jar_artifact_impl(ctx):
    jar_name = "%s.jar" % ctx.name
    ctx.download(
        output = ctx.path("jar/%s" % jar_name),
        url = ctx.attr.urls,
        sha256 = ctx.attr.sha256,
        executable = False
    )
    src_name = "%s-sources.jar" % ctx.name
    srcjar_attr = ""
    has_sources = len(ctx.attr.src_urls) != 0
    if has_sources:
        ctx.download(
            output = ctx.path("jar/%s" % src_name),
            url = ctx.attr.src_urls,
            sha256 = ctx.attr.src_sha256,
            executable = False
        )
        srcjar_attr = '\n    srcjar = ":%s",' % src_name

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
    {"artifact": "ch.qos.logback.contrib:logback-jackson:0.1.5", "lang": "java", "sha1": "0e8b202a23691048a01e6322dd040f75e08e9ca2", "sha256": "c6f8863934218faa1bfa0f325659aa899e6a28473de2ec09cf43192c78409ab4", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/ch/qos/logback/contrib/logback-jackson/0.1.5/logback-jackson-0.1.5.jar", "source": {"sha1": "9626cfaedd15cbed8a6dcb1db61e3a3340b42cee", "sha256": "0f3fa923d5b084b28e6b0e40fc5e4441be188b9606d689efa8b6ee3236cfd15a", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/ch/qos/logback/contrib/logback-jackson/0.1.5/logback-jackson-0.1.5-sources.jar"} , "name": "ch_qos_logback_contrib_logback_jackson", "actual": "@ch_qos_logback_contrib_logback_jackson//jar", "bind": "jar/ch/qos/logback/contrib/logback_jackson"},
    {"artifact": "ch.qos.logback.contrib:logback-json-classic:0.1.5", "lang": "java", "sha1": "f7fd4e747a9b0c50fc4f71b0055d5bea64dc05c3", "sha256": "257194ac9c57f65e72e7b18e60d7b78d3ea1bc85e734332a4a8bbb46a5af305a", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/ch/qos/logback/contrib/logback-json-classic/0.1.5/logback-json-classic-0.1.5.jar", "source": {"sha1": "91da8622b39a321df41bf0303b11b3eda9f52888", "sha256": "401696da09afae42f45344b018be7da3d686177cc060899798b10cb08366be8d", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/ch/qos/logback/contrib/logback-json-classic/0.1.5/logback-json-classic-0.1.5-sources.jar"} , "name": "ch_qos_logback_contrib_logback_json_classic", "actual": "@ch_qos_logback_contrib_logback_json_classic//jar", "bind": "jar/ch/qos/logback/contrib/logback_json_classic"},
    {"artifact": "ch.qos.logback.contrib:logback-json-core:0.1.5", "lang": "java", "sha1": "90bdb547819957fc940188f5830b7b59375f6fdd", "sha256": "8409ebc3c875fcb3dfd933787b559c0da9c9ce8660b02665be05ad33ce0ae31d", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/ch/qos/logback/contrib/logback-json-core/0.1.5/logback-json-core-0.1.5.jar", "source": {"sha1": "378f8f75af8c4560330e7d05c453800168d36c7e", "sha256": "37179a1f20e23ae121b65492970344f27c453245162d749b4639a861c37dde45", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/ch/qos/logback/contrib/logback-json-core/0.1.5/logback-json-core-0.1.5-sources.jar"} , "name": "ch_qos_logback_contrib_logback_json_core", "actual": "@ch_qos_logback_contrib_logback_json_core//jar", "bind": "jar/ch/qos/logback/contrib/logback_json_core"},
    {"artifact": "ch.qos.logback:logback-classic:1.3.5", "lang": "java", "sha1": "a44424b10f1506a1f22f65e4dc4cc065041a6861", "sha256": "9d68b9daf2fbb98a09b0445e0c64ac309d9d0e156b68510b63791397c97e32e4", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/ch/qos/logback/logback-classic/1.3.5/logback-classic-1.3.5.jar", "source": {"sha1": "78290bc57f8eccc61f24ff4dd6909b403f22cd3e", "sha256": "157fdded7873bd9c25ef216e0dd94f9ce94cb3f1695ccedaa5d53419b665b935", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/ch/qos/logback/logback-classic/1.3.5/logback-classic-1.3.5-sources.jar"} , "name": "ch_qos_logback_logback_classic", "actual": "@ch_qos_logback_logback_classic//jar", "bind": "jar/ch/qos/logback/logback_classic"},
# duplicates in ch.qos.logback:logback-core fixed to 1.3.5
# - ch.qos.logback.contrib:logback-json-core:0.1.5 wanted version 1.1.3
# - ch.qos.logback:logback-classic:1.3.5 wanted version 1.3.5
    {"artifact": "ch.qos.logback:logback-core:1.3.5", "lang": "java", "sha1": "ea4a25544ee70048766fde704e4fe6876648aae7", "sha256": "b1f0ec393f2f5bbaf1decb61624de18386634c3197e9eed69d1c1234ddd756f3", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/ch/qos/logback/logback-core/1.3.5/logback-core-1.3.5.jar", "source": {"sha1": "32c7b786978443b179c17d07d9a81b63587370b3", "sha256": "a7eacb9a79dee23314912540b25db573e425ec44814324ec1677ec2a7c9d1c48", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/ch/qos/logback/logback-core/1.3.5/logback-core-1.3.5-sources.jar"} , "name": "ch_qos_logback_logback_core", "actual": "@ch_qos_logback_logback_core//jar", "bind": "jar/ch/qos/logback/logback_core"},
# duplicates in com.fasterxml.jackson.core:jackson-annotations promoted to 2.15.2
# - com.fasterxml.jackson.core:jackson-databind:2.15.2 wanted version 2.15.2
# - org.apache.kafka:kafka-streams:3.5.1 wanted version 2.13.5
    {"artifact": "com.fasterxml.jackson.core:jackson-annotations:2.15.2", "lang": "java", "sha1": "4724a65ac8e8d156a24898d50fd5dbd3642870b8", "sha256": "04e21f94dcfee4b078fa5a5f53047b785aaba69d19de392f616e7a7fe5d3882f", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.15.2/jackson-annotations-2.15.2.jar", "source": {"sha1": "7458734de3b894cff3f3744ab11ff79b635c80e2", "sha256": "ce8e910f66e0c60d0beec66ccfe308a2426d606c85e67c76a5377dafb52eb4da", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.15.2/jackson-annotations-2.15.2-sources.jar"} , "name": "com_fasterxml_jackson_core_jackson_annotations", "actual": "@com_fasterxml_jackson_core_jackson_annotations//jar", "bind": "jar/com/fasterxml/jackson/core/jackson_annotations"},
# duplicates in com.fasterxml.jackson.core:jackson-core fixed to 2.15.2
# - com.fasterxml.jackson.core:jackson-databind:2.15.2 wanted version 2.15.2
# - com.fasterxml.jackson.datatype:jackson-datatype-jdk8:2.13.5 wanted version 2.13.5
    {"artifact": "com.fasterxml.jackson.core:jackson-core:2.15.2", "lang": "java", "sha1": "a6fe1836469a69b3ff66037c324d75fc66ef137c", "sha256": "303c99e82b1faa91a0bae5d8fbeb56f7e2adf9b526a900dd723bf140d62bd4b4", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-core/2.15.2/jackson-core-2.15.2.jar", "source": {"sha1": "4d3e4ff17d2cda69f8fd692694c304ff38a75823", "sha256": "4b29fe878549425194521d5c3270fae13f9c82cfcad639ebffea0963431bef45", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-core/2.15.2/jackson-core-2.15.2-sources.jar"} , "name": "com_fasterxml_jackson_core_jackson_core", "actual": "@com_fasterxml_jackson_core_jackson_core//jar", "bind": "jar/com/fasterxml/jackson/core/jackson_core"},
    {"artifact": "com.fasterxml.jackson.core:jackson-databind:2.15.2", "lang": "java", "sha1": "9353b021f10c307c00328f52090de2bdb4b6ff9c", "sha256": "0eb2fdad6e40ab8832a78c9b22f58196dd970594e8d3d5a26ead87847c4f3a96", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.15.2/jackson-databind-2.15.2.jar", "source": {"sha1": "032d4d520f3e46e7b2c2d4d863d8f2f381af4fa6", "sha256": "6dafb34ba03f003c998dac3f786bcfd468dfcec39eaf465180bc433ce8566d30", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.15.2/jackson-databind-2.15.2-sources.jar"} , "name": "com_fasterxml_jackson_core_jackson_databind", "actual": "@com_fasterxml_jackson_core_jackson_databind//jar", "bind": "jar/com/fasterxml/jackson/core/jackson_databind"},
    {"artifact": "com.fasterxml.jackson.datatype:jackson-datatype-jdk8:2.13.5", "lang": "java", "sha1": "1278f38160812811c56eb77f67213662ed1c7a2e", "sha256": "e58761751fea8a00dc626aae1c5f1be38c5cfd487aeb333d933a4ab5f5a73c55", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/fasterxml/jackson/datatype/jackson-datatype-jdk8/2.13.5/jackson-datatype-jdk8-2.13.5.jar", "source": {"sha1": "1a4ab5653e4cac2f53c18f81c1f65acbd61663a2", "sha256": "1c1f51c63c219ae7dc953c55e04d35e7cf5392edb45c640c5803d9ea9fafdd20", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/fasterxml/jackson/datatype/jackson-datatype-jdk8/2.13.5/jackson-datatype-jdk8-2.13.5-sources.jar"} , "name": "com_fasterxml_jackson_datatype_jackson_datatype_jdk8", "actual": "@com_fasterxml_jackson_datatype_jackson_datatype_jdk8//jar", "bind": "jar/com/fasterxml/jackson/datatype/jackson_datatype_jdk8"},
    {"artifact": "com.github.luben:zstd-jni:1.5.5-1", "lang": "java", "sha1": "fda1d6278299af27484e1cc3c79a060e41b7ef7e", "sha256": "f779fcd068ad91ac77aa0239104bd42793b0dce807fb1d73b51c635e0ea1e293", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/github/luben/zstd-jni/1.5.5-1/zstd-jni-1.5.5-1.jar", "source": {"sha1": "89ed42c223d964d3d111e84c18b00d842e5c850e", "sha256": "4800c5f8917fb9589caed77e0440cbce74fac465c8dd81fe91e5058cfdad36ed", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/github/luben/zstd-jni/1.5.5-1/zstd-jni-1.5.5-1-sources.jar"} , "name": "com_github_luben_zstd_jni", "actual": "@com_github_luben_zstd_jni//jar", "bind": "jar/com/github/luben/zstd_jni"},
    {"artifact": "com.google.code.findbugs:jsr305:3.0.2", "lang": "java", "sha1": "25ea2e8b0c338a877313bd4672d3fe056ea78f0d", "sha256": "766ad2a0783f2687962c8ad74ceecc38a28b9f72a2d085ee438b7813e928d0c7", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar", "source": {"sha1": "b19b5927c2c25b6c70f093767041e641ae0b1b35", "sha256": "1c9e85e272d0708c6a591dc74828c71603053b48cc75ae83cce56912a2aa063b", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2-sources.jar"} , "name": "com_google_code_findbugs_jsr305", "actual": "@com_google_code_findbugs_jsr305//jar", "bind": "jar/com/google/code/findbugs/jsr305"},
    {"artifact": "com.google.errorprone:error_prone_annotations:2.2.0", "lang": "java", "sha1": "88e3c593e9b3586e1c6177f89267da6fc6986f0c", "sha256": "6ebd22ca1b9d8ec06d41de8d64e0596981d9607b42035f9ed374f9de271a481a", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/google/errorprone/error_prone_annotations/2.2.0/error_prone_annotations-2.2.0.jar", "source": {"sha1": "a8cd7823aa1dcd2fd6677c0c5988fdde9d1fb0a3", "sha256": "626adccd4894bee72c3f9a0384812240dcc1282fb37a87a3f6cb94924a089496", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/google/errorprone/error_prone_annotations/2.2.0/error_prone_annotations-2.2.0-sources.jar"} , "name": "com_google_errorprone_error_prone_annotations", "actual": "@com_google_errorprone_error_prone_annotations//jar", "bind": "jar/com/google/errorprone/error_prone_annotations"},
    {"artifact": "com.google.guava:failureaccess:1.0.1", "lang": "java", "sha1": "1dcf1de382a0bf95a3d8b0849546c88bac1292c9", "sha256": "a171ee4c734dd2da837e4b16be9df4661afab72a41adaf31eb84dfdaf936ca26", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/google/guava/failureaccess/1.0.1/failureaccess-1.0.1.jar", "source": {"sha1": "1d064e61aad6c51cc77f9b59dc2cccc78e792f5a", "sha256": "092346eebbb1657b51aa7485a246bf602bb464cc0b0e2e1c7e7201fadce1e98f", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/google/guava/failureaccess/1.0.1/failureaccess-1.0.1-sources.jar"} , "name": "com_google_guava_failureaccess", "actual": "@com_google_guava_failureaccess//jar", "bind": "jar/com/google/guava/failureaccess"},
    {"artifact": "com.google.guava:guava:27.0.1-jre", "lang": "java", "sha1": "bd41a290787b5301e63929676d792c507bbc00ae", "sha256": "e1c814fd04492a27c38e0317eabeaa1b3e950ec8010239e400fe90ad6c9107b4", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/google/guava/guava/27.0.1-jre/guava-27.0.1-jre.jar", "source": {"sha1": "cb5c1119df8d41a428013289b193eba3ccaf5f60", "sha256": "cba2e5680186062f42998b895a5e9a9ceccbaab94644ccc9f35bb73c2b2c7d8e", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/google/guava/guava/27.0.1-jre/guava-27.0.1-jre-sources.jar"} , "name": "com_google_guava_guava", "actual": "@com_google_guava_guava//jar", "bind": "jar/com/google/guava/guava"},
    {"artifact": "com.google.guava:listenablefuture:9999.0-empty-to-avoid-conflict-with-guava", "lang": "java", "sha1": "b421526c5f297295adef1c886e5246c39d4ac629", "sha256": "b372a037d4230aa57fbeffdef30fd6123f9c0c2db85d0aced00c91b974f33f99", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/google/guava/listenablefuture/9999.0-empty-to-avoid-conflict-with-guava/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar", "name": "com_google_guava_listenablefuture", "actual": "@com_google_guava_listenablefuture//jar", "bind": "jar/com/google/guava/listenablefuture"},
    {"artifact": "com.google.j2objc:j2objc-annotations:1.1", "lang": "java", "sha1": "ed28ded51a8b1c6b112568def5f4b455e6809019", "sha256": "2994a7eb78f2710bd3d3bfb639b2c94e219cedac0d4d084d516e78c16dddecf6", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/google/j2objc/j2objc-annotations/1.1/j2objc-annotations-1.1.jar", "source": {"sha1": "1efdf5b737b02f9b72ebdec4f72c37ec411302ff", "sha256": "2cd9022a77151d0b574887635cdfcdf3b78155b602abc89d7f8e62aba55cfb4f", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/google/j2objc/j2objc-annotations/1.1/j2objc-annotations-1.1-sources.jar"} , "name": "com_google_j2objc_j2objc_annotations", "actual": "@com_google_j2objc_j2objc_annotations//jar", "bind": "jar/com/google/j2objc/j2objc_annotations"},
    {"artifact": "io.github.cdimascio:java-dotenv:3.1.7", "lang": "java", "sha1": "dc7a06f28c0e270a2216cca3429e9a2a6e22e752", "sha256": "2d41499b6d848f93a5ad08a91f0c07f5e62e19546fd9643f8565d960ac2e2111", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/github/cdimascio/java-dotenv/3.1.7/java-dotenv-3.1.7.jar", "source": {"sha1": "a05528d86bba44fbeba699ba5536d18cb5ad295f", "sha256": "a168009b2299ed42eb8da14460800c674702cb72ff057126abb5933df0d4894a", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/github/cdimascio/java-dotenv/3.1.7/java-dotenv-3.1.7-sources.jar"} , "name": "io_github_cdimascio_java_dotenv", "actual": "@io_github_cdimascio_java_dotenv//jar", "bind": "jar/io/github/cdimascio/java_dotenv"},
    {"artifact": "io.prometheus:simpleclient:0.8.0", "lang": "java", "sha1": "8d4e28b6e2a90204b578a64e017d607daeff338a", "sha256": "4a7a4966d6d369d4b82dee3c42fe488bd4173ec4928b4315e928afe378835e44", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/prometheus/simpleclient/0.8.0/simpleclient-0.8.0.jar", "source": {"sha1": "bc5a4e1d25ef6a677aaadba0de60135b69cd2914", "sha256": "6c6f6a98488fa38b970c8f416cd1731dc3e2c6925ad23146d606aa5404fbaa30", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/prometheus/simpleclient/0.8.0/simpleclient-0.8.0-sources.jar"} , "name": "io_prometheus_simpleclient", "actual": "@io_prometheus_simpleclient//jar", "bind": "jar/io/prometheus/simpleclient"},
    {"artifact": "io.prometheus:simpleclient_common:0.8.0", "lang": "java", "sha1": "011ed6deba9a4a5d204abc1cbbc51f0c91caf1c2", "sha256": "8aa113443e876124eab257a68c3bfca489bebda9dd633e4938c96804c81b0d62", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/prometheus/simpleclient_common/0.8.0/simpleclient_common-0.8.0.jar", "source": {"sha1": "644bc720ac45f7a176f2c1053e46a4a4710516d8", "sha256": "bb9e4926fabc4fd1dde6f1b9da1f69152e46296ca01fea8d2dc4f916f7231c8b", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/prometheus/simpleclient_common/0.8.0/simpleclient_common-0.8.0-sources.jar"} , "name": "io_prometheus_simpleclient_common", "actual": "@io_prometheus_simpleclient_common//jar", "bind": "jar/io/prometheus/simpleclient_common"},
    {"artifact": "io.prometheus:simpleclient_hotspot:0.8.0", "lang": "java", "sha1": "d860de9f2032f26d16a86665ddca98ce2063d304", "sha256": "619a151356ced431501fbd5c429f1bb14391bda73ec1d70b9a57417dfa6b98fc", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/prometheus/simpleclient_hotspot/0.8.0/simpleclient_hotspot-0.8.0.jar", "source": {"sha1": "2af3bac9679124eee0e0d02253325d92f06be18b", "sha256": "b27a9164ef141edb7f77a6950f34a95fe4eb42265ee1c67908ca1d7f51a05dc5", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/prometheus/simpleclient_hotspot/0.8.0/simpleclient_hotspot-0.8.0-sources.jar"} , "name": "io_prometheus_simpleclient_hotspot", "actual": "@io_prometheus_simpleclient_hotspot//jar", "bind": "jar/io/prometheus/simpleclient_hotspot"},
    {"artifact": "io.prometheus:simpleclient_httpserver:0.8.0", "lang": "java", "sha1": "92f1e16660a7112d640aaa66442d0ab97bd29b4f", "sha256": "c0354d4b7c177c0e2f4f1a3e219d078f39d36042daf5a0786e1471d405e4f026", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/prometheus/simpleclient_httpserver/0.8.0/simpleclient_httpserver-0.8.0.jar", "source": {"sha1": "ffe8ee7a5d1418b2611db35bd29c06ac98b45f0e", "sha256": "9c43fe5c3c92f34277ec098841d509f3325a215942ae96276ae3cefc6040ca6d", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/io/prometheus/simpleclient_httpserver/0.8.0/simpleclient_httpserver-0.8.0-sources.jar"} , "name": "io_prometheus_simpleclient_httpserver", "actual": "@io_prometheus_simpleclient_httpserver//jar", "bind": "jar/io/prometheus/simpleclient_httpserver"},
    {"artifact": "javax.ws.rs:javax.ws.rs-api:2.1.1", "lang": "java", "sha1": "d3466bc9321fe84f268a1adb3b90373fc14b0eb5", "sha256": "2c309eb2c9455ffee9da8518c70a3b6d46be2a269b2e2a101c806a537efe79a4", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/javax/ws/rs/javax.ws.rs-api/2.1.1/javax.ws.rs-api-2.1.1.jar", "source": {"sha1": "c8cd68f41c63e60c89321caa95513376aace6711", "sha256": "988cf24cda420f2333643b5f6c3813835404c0ad5e7cd137704ee7034bea2748", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/javax/ws/rs/javax.ws.rs-api/2.1.1/javax.ws.rs-api-2.1.1-sources.jar"} , "name": "javax_ws_rs_javax_ws_rs_api", "actual": "@javax_ws_rs_javax_ws_rs_api//jar", "bind": "jar/javax/ws/rs/javax_ws_rs_api"},
    {"artifact": "org.apache.kafka:connect-api:3.5.1", "lang": "java", "sha1": "271d31b2f8c5d80e741c71922b971de94e2b0ae2", "sha256": "a26850e5598d5839a4e6f96a7b73c8028d7a71ab4b43738ae862fce4d6130455", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/apache/kafka/connect-api/3.5.1/connect-api-3.5.1.jar", "source": {"sha1": "bd4f451870941021c26729d34d2d29e2ac35f454", "sha256": "70cd7c4d595349e56ebe3b4c7feff6f5bc5d3b47ec8f0bc3608caf44ea7a823e", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/apache/kafka/connect-api/3.5.1/connect-api-3.5.1-sources.jar"} , "name": "org_apache_kafka_connect_api", "actual": "@org_apache_kafka_connect_api//jar", "bind": "jar/org/apache/kafka/connect_api"},
    {"artifact": "org.apache.kafka:connect-json:3.5.1", "lang": "java", "sha1": "90c1833bf1de76cf4cb12a0b7d7cdf2fbfe5103d", "sha256": "0a84376421c2bf40cf7a2c2dbff7d30e792987a046d5dd5154331e2b1401bf4b", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/apache/kafka/connect-json/3.5.1/connect-json-3.5.1.jar", "source": {"sha1": "5ace24733970db2fc59f27b79d9e27b751a85f2a", "sha256": "9f5a83385fd5e89b7835f52bc96badcec2d8119d018cfcf4266d37a2177ca3bc", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/apache/kafka/connect-json/3.5.1/connect-json-3.5.1-sources.jar"} , "name": "org_apache_kafka_connect_json", "actual": "@org_apache_kafka_connect_json//jar", "bind": "jar/org/apache/kafka/connect_json"},
    {"artifact": "org.apache.kafka:kafka-clients:3.5.1", "lang": "java", "sha1": "2675a2dc48735f75d0694ca8bd8d4d3cb3737c17", "sha256": "e017aa068e5ad50c4c187b5e61a3dc24a60fba711f9ced15bcc09f5b3eaf3c64", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/apache/kafka/kafka-clients/3.5.1/kafka-clients-3.5.1.jar", "source": {"sha1": "b9acb5cb1339a32d175d196a88191a0d54a28b24", "sha256": "446a6a11f5772cd4d80a825f843dce1dfbedabc7b958b87f4c1fafd8cb07af39", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/apache/kafka/kafka-clients/3.5.1/kafka-clients-3.5.1-sources.jar"} , "name": "org_apache_kafka_kafka_clients", "actual": "@org_apache_kafka_kafka_clients//jar", "bind": "jar/org/apache/kafka/kafka_clients"},
    {"artifact": "org.apache.kafka:kafka-streams:3.5.1", "lang": "java", "sha1": "ebac991eabb037461a65264ec68bc58ec2451b4c", "sha256": "2e8fa324677ac32d782228995209494e80caa9685f5fb534cb01ac0b51edfbde", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/apache/kafka/kafka-streams/3.5.1/kafka-streams-3.5.1.jar", "source": {"sha1": "776ddf15ae6cf279fe88f3f81d299d371107c969", "sha256": "1151d408d56f9a38507db5b4bdf567bb708de3cec508eae9e8e9c00658349533", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/apache/kafka/kafka-streams/3.5.1/kafka-streams-3.5.1-sources.jar"} , "name": "org_apache_kafka_kafka_streams", "actual": "@org_apache_kafka_kafka_streams//jar", "bind": "jar/org/apache/kafka/kafka_streams"},
    {"artifact": "org.checkerframework:checker-qual:2.5.2", "lang": "java", "sha1": "cea74543d5904a30861a61b4643a5f2bb372efc4", "sha256": "64b02691c8b9d4e7700f8ee2e742dce7ea2c6e81e662b7522c9ee3bf568c040a", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/checkerframework/checker-qual/2.5.2/checker-qual-2.5.2.jar", "source": {"sha1": "ebb8ebccd42218434674f3e1d9022c13df1c19f8", "sha256": "821c5c63a6f156a3bb498c5bbb613580d9d8f4134131a5627d330fc4018669d2", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/checkerframework/checker-qual/2.5.2/checker-qual-2.5.2-sources.jar"} , "name": "org_checkerframework_checker_qual", "actual": "@org_checkerframework_checker_qual//jar", "bind": "jar/org/checkerframework/checker_qual"},
    {"artifact": "org.codehaus.mojo:animal-sniffer-annotations:1.17", "lang": "java", "sha1": "f97ce6decaea32b36101e37979f8b647f00681fb", "sha256": "92654f493ecfec52082e76354f0ebf87648dc3d5cec2e3c3cdb947c016747a53", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/codehaus/mojo/animal-sniffer-annotations/1.17/animal-sniffer-annotations-1.17.jar", "source": {"sha1": "8fb5b5ad9c9723951b9fccaba5bb657fa6064868", "sha256": "2571474a676f775a8cdd15fb9b1da20c4c121ed7f42a5d93fca0e7b6e2015b40", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/codehaus/mojo/animal-sniffer-annotations/1.17/animal-sniffer-annotations-1.17-sources.jar"} , "name": "org_codehaus_mojo_animal_sniffer_annotations", "actual": "@org_codehaus_mojo_animal_sniffer_annotations//jar", "bind": "jar/org/codehaus/mojo/animal_sniffer_annotations"},
    {"artifact": "org.jetbrains.kotlin:kotlin-stdlib-common:1.3.0", "lang": "java", "sha1": "84a2e0288dc17cd64d692eb1e5e0de8cd5ff0846", "sha256": "4b161ef619eee0d1a49b1c4f0c4a8e46f4e342573efd8e0106a765f47475fe39", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-stdlib-common/1.3.0/kotlin-stdlib-common-1.3.0.jar", "source": {"sha1": "8bee30ce9d075088b3d590488a270e2c3ea39b3a", "sha256": "66db7dd9406d6470823f962271672a2243d5d9a30f11885cc2e924709c669bfa", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-stdlib-common/1.3.0/kotlin-stdlib-common-1.3.0-sources.jar"} , "name": "org_jetbrains_kotlin_kotlin_stdlib_common", "actual": "@org_jetbrains_kotlin_kotlin_stdlib_common//jar", "bind": "jar/org/jetbrains/kotlin/kotlin_stdlib_common"},
    {"artifact": "org.jetbrains.kotlin:kotlin-stdlib:1.3.0", "lang": "java", "sha1": "a134b0cfe9bb44f98b0b3e889cda07923eea9428", "sha256": "4ff0fcb97f4983b4aaba12668c24ad21b08460915db1b021d8f1d8bee687f21c", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-stdlib/1.3.0/kotlin-stdlib-1.3.0.jar", "source": {"sha1": "98515ba3feb571f93b923e61f643bdaed59d14ac", "sha256": "4bb8b0ef7e635283a8b028ec7ee6eb21b418a8df29a7b5f7e35be8da7e3be9ae", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/kotlin-stdlib/1.3.0/kotlin-stdlib-1.3.0-sources.jar"} , "name": "org_jetbrains_kotlin_kotlin_stdlib", "actual": "@org_jetbrains_kotlin_kotlin_stdlib//jar", "bind": "jar/org/jetbrains/kotlin/kotlin_stdlib"},
    {"artifact": "org.jetbrains:annotations:24.0.1", "lang": "java", "sha1": "13c5c75c4206580aa4d683bffee658caae6c9f43", "sha256": "61666dbce7e42e6c85b43c04fcfb8293a21dcb55b3c80e869270ce42c01a6b35", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/jetbrains/annotations/24.0.1/annotations-24.0.1.jar", "source": {"sha1": "2f9be7fbab3157633befe74c684bd3badb28a876", "sha256": "40978d2ac2fe28e0fc2e1eddc443057572ab775986d7afc83cc0c48cc65652ab", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/jetbrains/annotations/24.0.1/annotations-24.0.1-sources.jar"} , "name": "org_jetbrains_annotations", "actual": "@org_jetbrains_annotations//jar", "bind": "jar/org/jetbrains/annotations"},
    {"artifact": "org.json:json:20180130", "lang": "java", "sha1": "26ba2ec0e791a32ea5dfbedfcebf36447ee5b12c", "sha256": "3eddf6d9d50e770650e62abe62885f4393aa911430ecde73ebafb1ffd2cfad16", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/json/json/20180130/json-20180130.jar", "source": {"sha1": "66ab57acbb9086d16201c2eafa2145d2b914bb26", "sha256": "1d43bf94c59a7b2f2be720cc269de0600e49a5d69565e1e746d8b346c150278d", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/json/json/20180130/json-20180130-sources.jar"} , "name": "org_json_json", "actual": "@org_json_json//jar", "bind": "jar/org/json/json"},
    {"artifact": "org.lz4:lz4-java:1.8.0", "lang": "java", "sha1": "4b986a99445e49ea5fbf5d149c4b63f6ed6c6780", "sha256": "d74a3334fb35195009b338a951f918203d6bbca3d1d359033dc33edd1cadc9ef", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/lz4/lz4-java/1.8.0/lz4-java-1.8.0.jar", "source": {"sha1": "7609c362f37f0c0bd3743bc1976df2daa28ad19e", "sha256": "53ac09a2d80ba5d0b7078f9cbc572dd4a5377a37d08b3333dd4b2ffe2143650f", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/lz4/lz4-java/1.8.0/lz4-java-1.8.0-sources.jar"} , "name": "org_lz4_lz4_java", "actual": "@org_lz4_lz4_java//jar", "bind": "jar/org/lz4/lz4_java"},
    {"artifact": "org.rocksdb:rocksdbjni:7.1.2", "lang": "java", "sha1": "ffe87d1c5d5b3a46d065cc4cf5311f18d8233a6b", "sha256": "6d3b31904f170efc2171524462ce7290865c1e1efb47760469303d5b16a4b767", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/rocksdb/rocksdbjni/7.1.2/rocksdbjni-7.1.2.jar", "source": {"sha1": "d1fee252feb98060992556acd8323947dcfac9a1", "sha256": "ae790a3dd27f511bc9b86f1ee7855f14c4702f42e9877618ba4010dc53e38301", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/rocksdb/rocksdbjni/7.1.2/rocksdbjni-7.1.2-sources.jar"} , "name": "org_rocksdb_rocksdbjni", "actual": "@org_rocksdb_rocksdbjni//jar", "bind": "jar/org/rocksdb/rocksdbjni"},
# duplicates in org.slf4j:slf4j-api fixed to 2.0.3
# - ch.qos.logback:logback-classic:1.3.5 wanted version 2.0.4
# - org.apache.kafka:connect-api:3.5.1 wanted version 1.7.36
# - org.apache.kafka:connect-json:3.5.1 wanted version 1.7.36
# - org.apache.kafka:kafka-clients:3.5.1 wanted version 1.7.36
# - org.apache.kafka:kafka-streams:3.5.1 wanted version 1.7.36
    {"artifact": "org.slf4j:slf4j-api:2.0.3", "lang": "java", "sha1": "deef7fc81f00bd5e6205bb097be1040b4094f007", "sha256": "68ddcda65300ff8097ad1a096d7cd2fb06cef25193887cec3f2690e01bdbf421", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.3/slf4j-api-2.0.3.jar", "source": {"sha1": "6ba8526502af8ff682286a8c7104162be97913db", "sha256": "c067fd1d63b3f15a532b8828e8e95788b39b9b90a0d15a8c7cad59e1ba2666c4", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.3/slf4j-api-2.0.3-sources.jar"} , "name": "org_slf4j_slf4j_api", "actual": "@org_slf4j_slf4j_api//jar", "bind": "jar/org/slf4j/slf4j_api"},
    {"artifact": "org.xerial.snappy:snappy-java:1.1.10.1", "lang": "java", "sha1": "4a1e1a22cba39145dfa20f2fef4e1ca38c8e02a1", "sha256": "5a6224cb7f946f5a7db9c77e86af6ccd43ba5ae38b1a15bea23113cc83f8fabd", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/xerial/snappy/snappy-java/1.1.10.1/snappy-java-1.1.10.1.jar", "source": {"sha1": "4e98867007a32126e0c26f0ecde6a2244e876317", "sha256": "8500d527f6f7a4ef89a57370c783b65e5e658f2d0e5aca94136f912f1f902b74", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/xerial/snappy/snappy-java/1.1.10.1/snappy-java-1.1.10.1-sources.jar"} , "name": "org_xerial_snappy_snappy_java", "actual": "@org_xerial_snappy_snappy_java//jar", "bind": "jar/org/xerial/snappy/snappy_java"},
    ]

def maven_dependencies(callback = jar_artifact_callback):
    for hash in list_dependencies():
        callback(hash)
