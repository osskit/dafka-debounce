package src.main.java.debounce;

import com.fasterxml.jackson.databind.JsonNode;
import org.apache.kafka.streams.processor.api.Record;
import src.main.java.partitioner.PartitioningKeyResolver;

public class DebounceUseLastProcessor extends BaseDebounceProcessor {

    protected DebounceUseLastProcessor(
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
        return newRecord;
    }
}
