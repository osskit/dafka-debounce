package src.main.java.partitioner;

import com.fasterxml.jackson.databind.JsonNode;

public class OriginalPartitioningKeyResolver implements PartitioningKeyResolver {

    protected OriginalPartitioningKeyResolver() {
    }

    @Override
    public String resolvePartitioningKey(String originalKey, JsonNode value) {
        return originalKey;
    }
}
