package src.main.java;

import java.util.concurrent.CountDownLatch;
import org.apache.kafka.streams.KafkaStreams;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import src.main.java.configuration.Config;
import src.main.java.monitoring.Monitor;
import src.main.java.monitoring.MonitoringServer;
import src.main.java.stream.StreamProcessor;

public class Main {

    static Logger logger = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) throws Exception {
        try {
            CountDownLatch latch = new CountDownLatch(1);

            Config.init();
            Monitor.init();

            MonitoringServer monitoringServer = new MonitoringServer().start();

            StreamProcessor streamProcessor = new StreamProcessor(monitoringServer);
            KafkaStreams streams = streamProcessor.createStream();

            onShutdown(streams, monitoringServer, latch);

            streams.start();

            latch.await();
        } catch (Exception e) {
            logger.error("Unexpected error while initializing", e);
            throw e;
        }
        logger.info("dafka-debounce-{} terminated", Config.GROUP_ID);
    }

    private static void onShutdown(KafkaStreams stream, MonitoringServer monitoringServer, CountDownLatch latch) {
        Runtime
            .getRuntime()
            .addShutdownHook(
                new Thread(() -> {
                    logger.info("Shutting Down");
                    stream.close();
                    monitoringServer.close();
                    latch.countDown();
                })
            );
    }
}
