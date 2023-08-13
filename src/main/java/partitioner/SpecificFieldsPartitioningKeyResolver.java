package src.main.java.partitioner;

import com.fasterxml.jackson.databind.JsonNode;
import src.main.java.configuration.Config;

import java.util.stream.Collectors;

public class SpecificFieldsPartitioningKeyResolver implements PartitioningKeyResolver {

    protected SpecificFieldsPartitioningKeyResolver() {
    }

    @Override
    public String resolvePartitioningKey(String originalKey, JsonNode value) {
        return Config.OUTPUT_PARTITIONING_KEY_FIELDS.stream().map((field) -> {
            JsonNode node = value.at(field);
            if (node == null || node.isMissingNode()) {
                return null;
            }
            return node.asText();
        }).filter(v -> !(v == null)).collect(Collectors.joining("_"));
    }
}
