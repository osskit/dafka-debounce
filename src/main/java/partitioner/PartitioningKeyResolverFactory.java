package src.main.java.partitioner;

import src.main.java.configuration.Config;

public class PartitioningKeyResolverFactory {

    private static final UuidPartitioningKeyResolver uuidPartitioningKeyResolver = new UuidPartitioningKeyResolver();
    private static final SpecificFieldsPartitioningKeyResolver specificFieldsPartitioningKeyResolver = new SpecificFieldsPartitioningKeyResolver();
    private static final OriginalPartitioningKeyResolver originalPartitioningKeyResolver = new OriginalPartitioningKeyResolver();


    public static PartitioningKeyResolver getPartitioningKeyResolverInstance() {
        return switch (Config.OUTPUT_PARTITIONING_KEY) {
            case UUID -> uuidPartitioningKeyResolver;
            case SPECIFIC_FIELDS -> specificFieldsPartitioningKeyResolver;
            case KEY_FROM_SOURCE -> originalPartitioningKeyResolver;
        };
    }
}
