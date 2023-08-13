package src.main.java.debounce;

import src.main.java.configuration.Config;
import src.main.java.partitioner.PartitioningKeyResolver;
import src.main.java.partitioner.PartitioningKeyResolverFactory;

public class DebounceProcessorFactory {

    public static BaseDebounceProcessor getDebounceProcessorInstance() {
        PartitioningKeyResolver partitioningKeyResolver =
            PartitioningKeyResolverFactory.getPartitioningKeyResolverInstance();
        return switch (Config.DEDUPLICATION_OPERATOR) {
            case LAST -> new DebounceUseLastProcessor(
                Config.WINDOW_STORE_NAME,
                Config.WINDOW_DURATION,
                partitioningKeyResolver
            );
            case FIRST -> new DebounceUseFirstProcessor(
                Config.WINDOW_STORE_NAME,
                Config.WINDOW_DURATION,
                partitioningKeyResolver
            );
        };
    }
}
