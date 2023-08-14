package src.main.java.debounce;

import com.fasterxml.jackson.databind.JsonNode;
import org.apache.kafka.streams.processor.api.Record;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import src.main.java.partitioner.PartitioningKeyResolver;

public class DebounceUseFirstProcessor extends BaseDebounceProcessor {

    protected DebounceUseFirstProcessor(
        String storeId,
        int windowSize,
        PartitioningKeyResolver partitioningKeyResolver
    ) {
        super(storeId, windowSize, partitioningKeyResolver);
    }

    @Override
    public Record<String, JsonNode> selectRecordToPutInWindow(
        Record<String, JsonNode> oldRecord,
        Record<String, JsonNode> newRecord
    ) {
        return oldRecord;
    }
}
