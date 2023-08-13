package src.main.java.stream;

import java.time.Duration;
import java.util.Properties;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.KafkaStreams;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.errors.StreamsUncaughtExceptionHandler;
import org.apache.kafka.streams.kstream.Consumed;
import org.apache.kafka.streams.kstream.Produced;
import org.apache.kafka.streams.state.Stores;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import src.main.java.configuration.Config;
import src.main.java.debounce.DebounceProcessorFactory;
import src.main.java.monitoring.MonitoringServer;
import src.main.java.serdes.JsonNodeSerde;

public class StreamProcessor {

    private static final Logger logger = LoggerFactory.getLogger(StreamProcessor.class);

    private final MonitoringServer monitoringServer;

    public StreamProcessor(MonitoringServer monitoringServer) {
        this.monitoringServer = monitoringServer;
    }

    public KafkaStreams createStream() {
        final Properties streamsConfiguration = new StreamConfiguration();

        final StreamsBuilder builder = new StreamsBuilder();
        buildStream(builder);
        KafkaStreams streams = new KafkaStreams(builder.build(), streamsConfiguration);

        addMonitoringToStream(streams);
        return streams;
    }

    private void buildStream(final StreamsBuilder builder) {
        builder.addStateStore(
            Stores.windowStoreBuilder(
                Stores.persistentWindowStore(
                    Config.WINDOW_STORE_NAME,
                    Duration.ofSeconds(Config.WINDOW_RETENTION_PERIOD),
                    Duration.ofSeconds(Config.WINDOW_DURATION),
                    false
                ),
                Serdes.String(),
                new JsonNodeSerde()
            )
        );

        builder
            .stream(Config.SOURCE_TOPIC, Consumed.with(Serdes.String(), new JsonNodeSerde()))
            .process(DebounceProcessorFactory::getDebounceProcessorInstance, Config.WINDOW_STORE_NAME)
            .to(Config.TARGET_TOPIC, Produced.with(Serdes.String(), new JsonNodeSerde()));
    }

    private void addMonitoringToStream(KafkaStreams streams) {
        streams.setUncaughtExceptionHandler(e -> {
            logger.error("Uncaught Exception in stream", e);
            return StreamsUncaughtExceptionHandler.StreamThreadExceptionResponse.SHUTDOWN_APPLICATION;
        });

        streams.setStateListener(
            (
                (newState, oldState) -> {
                    logger.info("Stream State Change from {} to {}", oldState, newState);
                    if (newState == KafkaStreams.State.RUNNING) {
                        logger.info("dafka-debounce-{} started", Config.GROUP_ID);
                        monitoringServer.setStreamRunning(true);
                        return;
                    }

                    if (newState != KafkaStreams.State.REBALANCING) {
                        monitoringServer.setStreamRunning(false);
                    }
                }
            )
        );

        streams.setGlobalStateRestoreListener(new StreamStateRestoreListener());
    }
}
