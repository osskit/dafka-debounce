package src.main.java.serdes;

import com.fasterxml.jackson.databind.JsonNode;
import org.apache.kafka.common.serialization.Deserializer;
import org.apache.kafka.common.serialization.Serde;
import org.apache.kafka.common.serialization.Serializer;
import org.apache.kafka.connect.json.JsonDeserializer;
import org.apache.kafka.connect.json.JsonSerializer;

public class JsonNodeSerde implements Serde<JsonNode> {

    Serializer<JsonNode> serializer;
    Deserializer<JsonNode> deserializer;

    public JsonNodeSerde() {
        this.serializer = new JsonSerializer();
        this.deserializer = new JsonDeserializer();
    }

    @Override
    public Serializer<JsonNode> serializer() {
        return serializer;
    }

    @Override
    public Deserializer<JsonNode> deserializer() {
        return deserializer;
    }
}
