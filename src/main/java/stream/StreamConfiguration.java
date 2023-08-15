package src.main.java.stream;

import java.util.Properties;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.RangeAssignor;
import org.apache.kafka.clients.consumer.StickyAssignor;
import org.apache.kafka.common.config.SaslConfigs;
import org.apache.kafka.common.config.SslConfigs;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.StreamsConfig;
import src.main.java.configuration.BoundedMemoryRocksdbConfig;
import src.main.java.configuration.Config;

public class StreamConfiguration extends Properties {

    private static final String TOTAL_OFF_HEAP_SIZE_MB = "rocksdb.total_offheap_size_mb";
    private static final String TOTAL_MEMTABLE_MB = "rocksdb.total_memtable_mb";

    public StreamConfiguration() {
        super();
        put(StreamsConfig.APPLICATION_ID_CONFIG, Config.GROUP_ID);
        put(StreamsConfig.CLIENT_ID_CONFIG, Config.GROUP_ID + "_client");
        put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, Config.KAFKA_BROKER);
        put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass().getName());
        put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass().getName());
        put(StreamsConfig.ROCKSDB_CONFIG_SETTER_CLASS_CONFIG, BoundedMemoryRocksdbConfig.class);
        put(TOTAL_OFF_HEAP_SIZE_MB, Config.TOTAL_OFF_HEAP_SIZE_MB);
        put(TOTAL_MEMTABLE_MB, Config.TOTAL_MEMTABLE_MB);
        put(
            ConsumerConfig.PARTITION_ASSIGNMENT_STRATEGY_CONFIG,
            String.format("%s,%s", StickyAssignor.class.getName(), RangeAssignor.class.getName())
        );

        buildAuthProperties();
    }

    private static String getSaslMechanism() {
        return switch (Config.SASL_MECHANISM.toUpperCase()) {
            case "PLAIN" -> "plain.PlainLoginModule";
            case "SCRAM-SHA-512" -> "scram.ScramLoginModule";
            default -> "";
        };
    }

    private void buildAuthProperties() {
        if (!Config.USE_SASL_AUTH) {
            return;
        }

        put("security.protocol", "SASL_SSL");

        if (Config.TRUSTSTORE_PASSWORD != null) {
            put(SslConfigs.SSL_TRUSTSTORE_LOCATION_CONFIG, Config.TRUSTSTORE_FILE_PATH);
            put(SslConfigs.SSL_TRUSTSTORE_PASSWORD_CONFIG, Config.TRUSTSTORE_PASSWORD);
        }
        put(SaslConfigs.SASL_MECHANISM, Config.SASL_MECHANISM.toUpperCase());
        put(SslConfigs.SSL_ENDPOINT_IDENTIFICATION_ALGORITHM_CONFIG, "");
        put(
            SaslConfigs.SASL_JAAS_CONFIG,
            String.format(
                "org.apache.kafka.common.security.%s required username=\"%s\" password=\"%s\";",
                getSaslMechanism(),
                Config.SASL_USERNAME,
                Config.SASL_PASSWORD
            )
        );
    }
}
