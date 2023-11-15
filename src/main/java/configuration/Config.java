package src.main.java.configuration;

import io.github.cdimascio.dotenv.Dotenv;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class Config {

    public static String WINDOW_STORE_NAME;
    //Required
    public static String KAFKA_BROKER;
    public static String GROUP_ID;
    public static String SOURCE_TOPIC;
    public static String TARGET_TOPIC;

    // Memory
    public static int TOTAL_OFF_HEAP_SIZE_MB;
    public static int TOTAL_MEMTABLE_MB;

    //Authentication
    public static boolean USE_SASL_AUTH;
    public static String SASL_USERNAME;
    public static String SASL_PASSWORD;
    public static String SASL_MECHANISM;
    public static String TRUSTSTORE_FILE_PATH;
    public static String TRUSTSTORE_PASSWORD;

    //Monitoring
    public static int MONITORING_SERVER_PORT;
    public static int WINDOW_DURATION;
    public static int WINDOW_RETENTION_PERIOD;
    public static DeduplicationOperator DEDUPLICATION_OPERATOR;
    public static OutputKeyType OUTPUT_PARTITIONING_KEY;
    public static List<String> OUTPUT_PARTITIONING_KEY_FIELDS;
    public static boolean USE_PROMETHEUS;
    public static String PROMETHEUS_BUCKETS;

    public static void init() throws Exception {
        Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();

        KAFKA_BROKER = getString(dotenv, "KAFKA_BROKER");
        GROUP_ID = getString(dotenv, "GROUP_ID");
        COMMIT_INTERVAL_MS_CONFIG = getOptionalString(dotenv, "COMMIT_INTERVAL_MS_CONFIG", "30000");

        // --------------------
        SOURCE_TOPIC = getString(dotenv, "SOURCE_TOPIC");
        TARGET_TOPIC = getString(dotenv, "TARGET_TOPIC");

        TOTAL_MEMTABLE_MB = getOptionalInt(dotenv, "TOTAL_MEMTABLE_MB", 100);
        TOTAL_OFF_HEAP_SIZE_MB = getOptionalInt(dotenv, "TOTAL_OFF_HEAP_SIZE_MB", 10);

        WINDOW_STORE_NAME = SOURCE_TOPIC + "-window-store";

        WINDOW_DURATION = getInt(dotenv, "WINDOW_DURATION");
        WINDOW_RETENTION_PERIOD = getOptionalInt(dotenv, "WINDOW_RETENTION_PERIOD", WINDOW_DURATION * 3);

        DEDUPLICATION_OPERATOR =
            DeduplicationOperator.valueOf(getOptionalString(dotenv, "DEDUPLICATION_OPERATOR", "LAST"));

        OUTPUT_PARTITIONING_KEY =
            OutputKeyType.valueOf(getOptionalString(dotenv, "OUTPUT_PARTITIONING_KEY", "KEY_FROM_SOURCE"));
        OUTPUT_PARTITIONING_KEY_FIELDS = getOptionalStringList(dotenv, "OUTPUT_PARTITIONING_KEY_FIELDS");

        if (
            OUTPUT_PARTITIONING_KEY.equals(OutputKeyType.SPECIFIC_FIELDS) &&
            (OUTPUT_PARTITIONING_KEY_FIELDS == null || OUTPUT_PARTITIONING_KEY_FIELDS.isEmpty())
        ) {
            throw new Exception(
                "env var OUTPUT_KEY_TYPE is set to SPECIFIC_FIELDS but OUTPUT_PARTITIONING_KEY_FIELDS is missing or empty"
            );
        }

        // --------------------

        MONITORING_SERVER_PORT = getOptionalInt(dotenv, "MONITORING_SERVER_PORT", 0);

        USE_SASL_AUTH = getOptionalBool(dotenv, "USE_SASL_AUTH", false);
        if (USE_SASL_AUTH) {
            SASL_USERNAME = getString(dotenv, "SASL_USERNAME");
            SASL_PASSWORD = getStringValueOrFromFile(dotenv, "SASL_PASSWORD");
            SASL_MECHANISM = getOptionalString(dotenv, "SASL_MECHANISM", "PLAIN");
            TRUSTSTORE_FILE_PATH = getOptionalString(dotenv, "TRUSTSTORE_FILE_PATH", null);
            if (TRUSTSTORE_FILE_PATH != null) {
                TRUSTSTORE_PASSWORD = getStringValueOrFromFile(dotenv, "TRUSTSTORE_PASSWORD");
            }
        }

        USE_PROMETHEUS = getOptionalBool(dotenv, "USE_PROMETHEUS", false);
        PROMETHEUS_BUCKETS = getOptionalString(dotenv, "PROMETHEUS_BUCKETS", "0.003,0.03,0.1,0.3,1.5,10");
    }

    private static String getString(Dotenv dotenv, String name) throws Exception {
        String value = dotenv.get(name);

        if (value == null) {
            throw new Exception("missing env var: " + name);
        }

        return value;
    }

    private static List<String> getOptionalStringList(Dotenv dotenv, String name) throws Exception {
        String value = dotenv.get(name);

        if (value == null) {
            return null;
        }

        return Arrays.stream(value.split(",")).collect(Collectors.toList());
    }

    private static String getOptionalString(Dotenv dotenv, String name, String fallback) {
        try {
            return getString(dotenv, name);
        } catch (Exception e) {
            return fallback;
        }
    }

    private static boolean getOptionalBool(Dotenv dotenv, String name, boolean fallback) {
        try {
            return Boolean.parseBoolean(getString(dotenv, name));
        } catch (Exception e) {
            return fallback;
        }
    }

    private static int getOptionalInt(Dotenv dotenv, String name, int fallback) {
        try {
            return getInt(dotenv, name);
        } catch (NumberFormatException e) {
            return fallback;
        }
    }

    private static int getInt(Dotenv dotenv, String name) {
        return Integer.parseInt(dotenv.get(name));
    }

    private static long getOptionalLong(Dotenv dotenv, String name, long fallback) {
        try {
            return Long.parseLong(getString(dotenv, name));
        } catch (Exception e) {
            return fallback;
        }
    }

    private static String getStringValueOrFromFile(Dotenv dotenv, String name) throws Exception {
        String value = dotenv.get(name);

        if (value != null) {
            return value;
        }

        String filePath = dotenv.get(name + "_FILE_PATH");

        if (filePath == null) {
            throw new Exception("missing env var: " + name + " or " + name + "_FILE_PATH");
        }

        return new String(Files.readAllBytes(Paths.get(filePath)));
    }
}
