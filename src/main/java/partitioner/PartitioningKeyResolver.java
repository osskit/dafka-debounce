package src.main.java.partitioner;

import com.fasterxml.jackson.databind.JsonNode;

public interface PartitioningKeyResolver {
    String resolvePartitioningKey(String originalKey, JsonNode value);
}
