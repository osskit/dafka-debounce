package src.main.java.stream;

import org.apache.kafka.common.TopicPartition;
import org.apache.kafka.streams.processor.StateRestoreListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class StreamStateRestoreListener implements StateRestoreListener {

    Logger logger = LoggerFactory.getLogger(StreamStateRestoreListener.class);

    @Override
    public void onRestoreStart(TopicPartition topicPartition, String storeName, long startingOffset, long endingOffset) {
        logger.info("Starting to restore State for topic {}, partition {} into store {}", topicPartition.topic(), topicPartition.partition(), storeName);
    }

    @Override
    public void onBatchRestored(TopicPartition topicPartition, String storeName, long batchEndOffset, long numRestored) {
        logger.info("Restored batch in State for topic {}, partition {} into store {}, number restored {}", topicPartition.topic(), topicPartition.partition(), storeName, numRestored);
    }

    @Override
    public void onRestoreEnd(TopicPartition topicPartition, String storeName, long totalRestored) {
        logger.info("Finished restoring State for topic {}, partition {} into store {}, total restored {}", topicPartition.topic(), topicPartition.partition(), storeName, totalRestored);
    }

}
