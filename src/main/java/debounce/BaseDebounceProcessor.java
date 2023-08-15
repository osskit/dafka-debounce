package src.main.java.debounce;

import com.fasterxml.jackson.databind.JsonNode;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import org.apache.kafka.streams.KeyValue;
import org.apache.kafka.streams.kstream.Windowed;
import org.apache.kafka.streams.processor.PunctuationType;
import org.apache.kafka.streams.processor.Punctuator;
import org.apache.kafka.streams.processor.api.Processor;
import org.apache.kafka.streams.processor.api.ProcessorContext;
import org.apache.kafka.streams.processor.api.Record;
import org.apache.kafka.streams.state.KeyValueIterator;
import org.apache.kafka.streams.state.WindowStore;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import src.main.java.monitoring.Monitor;
import src.main.java.partitioner.PartitioningKeyResolver;

public abstract class BaseDebounceProcessor implements Processor<String, JsonNode, String, JsonNode>, Punctuator {

    private static final Logger logger = LoggerFactory.getLogger(BaseDebounceProcessor.class);
    private static final DateTimeFormatter format = DateTimeFormatter
        .ofPattern("HH:mm:ss")
        .withZone(ZoneId.systemDefault());
    private static final Instant beginningOfTime = Instant.ofEpochSecond(0);

    String storeId;
    int windowSize;
    ProcessorContext<String, JsonNode> context;
    PartitioningKeyResolver partitioningKeyResolver;
    WindowStore<String, JsonNode> store;

    protected BaseDebounceProcessor(String storeId, int windowSize, PartitioningKeyResolver partitioningKeyResolver) {
        this.storeId = storeId;
        this.windowSize = windowSize;
        this.partitioningKeyResolver = partitioningKeyResolver;
    }

    public void init(ProcessorContext<String, JsonNode> context) {
        this.context = context;
        this.store = context.getStateStore(storeId);
        this.context.schedule(Duration.ofSeconds(windowSize), PunctuationType.WALL_CLOCK_TIME, this);
    }

    @Override
    public void punctuate(long timestamp) {
        Instant now = Instant.now();
        Instant windowRight = now.minus(windowSize, ChronoUnit.SECONDS);
        logger.info("scanning for windows from beginning of time until {}", format.format(windowRight));
        KeyValueIterator<Windowed<String>, JsonNode> iterator = store.fetchAll(beginningOfTime, windowRight);
        while (iterator.hasNext()) {
            KeyValue<Windowed<String>, JsonNode> entry = iterator.next();
            logger.info(
                "producing record {} {}  {}",
                entry.key.key(),
                format.format(entry.key.window().startTime()),
                format.format(entry.key.window().endTime())
            );

            String newRecordKey = partitioningKeyResolver.resolvePartitioningKey(entry.key.key(), entry.value);

            context.forward(new Record<>(newRecordKey, entry.value, now.toEpochMilli()));

            Monitor.captureMessageDurationInWindow(entry.key.window().start(), now.toEpochMilli());

            store.put(entry.key.key(), null, entry.key.window().start());
        }
        iterator.close();
    }

    @Override
    public void process(Record<String, JsonNode> newRecord) {
        Monitor.captureDebounceMessageStarted();

        Instant windowStartTime = Instant.now().minus(windowSize, ChronoUnit.SECONDS);
        Instant newWindowStartTime = Instant.now();

        KeyValueIterator<Windowed<String>, JsonNode> iterator = store.fetch(
            newRecord.key(),
            newRecord.key(),
            windowStartTime,
            Instant.now()
        );
        KeyValue<Windowed<String>, JsonNode> existingRecord = null;
        if (iterator.hasNext()) {
            existingRecord = iterator.next();
            newWindowStartTime = existingRecord.key.window().startTime();
        }
        iterator.close();

        logger.info("adding record {} to window {}", newRecord.key(), format.format(newWindowStartTime));
        Record<String, JsonNode> recordToPut = newRecord;

        if (existingRecord != null) {
            Record<String, JsonNode> oldRecord = new Record<>(
                existingRecord.key.key(),
                existingRecord.value,
                existingRecord.key.window().start()
            );
            Monitor.captureMessagesDebounced();
            recordToPut = this.selectRecordToPutInWindow(oldRecord, newRecord);
        }

        store.put(recordToPut.key(), recordToPut.value(), newWindowStartTime.toEpochMilli());
    }

    public abstract Record<String, JsonNode> selectRecordToPutInWindow(
        Record<String, JsonNode> oldRecord,
        Record<String, JsonNode> newRecord
    );
}
