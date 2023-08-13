package src.main.java.monitoring;

import io.prometheus.client.Counter;
import io.prometheus.client.Histogram;
import java.util.Arrays;
import src.main.java.configuration.Config;

public class Monitor {

    private static Counter debounceMessageStarted;
    private static Counter debounceMessageProduced;
    private static Counter messagesDebounced;
    private static Histogram messageDurationInWindow;

    private static double[] buckets = new double[0];

    public static void init() {
        if (Config.PROMETHEUS_BUCKETS != null) {
            buckets =
                Arrays
                    .asList(Config.PROMETHEUS_BUCKETS.split(","))
                    .stream()
                    .mapToDouble(s -> Double.parseDouble(s))
                    .toArray();
        }

        messageDurationInWindow =
            Histogram
                .build()
                .buckets(buckets)
                .name("message_duration_in_window")
                .help("message_duration_in_window")
                .register();

        debounceMessageStarted =
            Counter.build().name("debounce_message_started").help("debounce_message_started").register();

        debounceMessageProduced =
            Counter.build().name("debounce_message_produced").help("debounce_message_produced").register();

        messagesDebounced = Counter.build().name("messages_debounced").help("messages_debounced").register();
    }

    public static void captureDebounceMessageStarted() {
        debounceMessageStarted.inc();
    }

    public static void captureMessagesDebounced() {
        messagesDebounced.inc();
    }

    public static void captureMessageDurationInWindow(long executionStart, long executionEnd) {
        debounceMessageProduced.inc();
        messageDurationInWindow.observe(((double) (executionEnd - executionStart)) / 1000);
    }
}
