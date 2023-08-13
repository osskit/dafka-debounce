package src.main.java.partitioner;

import com.fasterxml.jackson.databind.JsonNode;

import java.util.UUID;

public class UuidPartitioningKeyResolver implements PartitioningKeyResolver {
    protected UuidPartitioningKeyResolver() {
    }

    @Override
    public String resolvePartitioningKey(String originalKey, JsonNode value) {
        return UUID.randomUUID().toString();
    }
}
