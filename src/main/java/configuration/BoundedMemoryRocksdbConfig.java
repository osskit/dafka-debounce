package src.main.java.configuration;

import java.util.Map;
import org.apache.kafka.streams.state.RocksDBConfigSetter;
import org.rocksdb.BlockBasedTableConfig;
import org.rocksdb.Options;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class BoundedMemoryRocksdbConfig implements RocksDBConfigSetter {

    private static final Logger logger = LoggerFactory.getLogger(BoundedMemoryRocksdbConfig.class);

    private static final long BYTE_FACTOR = 1;
    private static final long KB_FACTOR = 1024 * BYTE_FACTOR;
    private static final long MB_FACTOR = 1024 * KB_FACTOR;

    private static org.rocksdb.Cache cache;
    private static org.rocksdb.WriteBufferManager writeBufferManager;

    @Override
    public void close(String s, Options options) {}

    public synchronized void initCacheOnce() {
        if (cache != null && writeBufferManager != null) return;

        if (cache == null) {
            cache = new org.rocksdb.LRUCache(Config.TOTAL_OFF_HEAP_SIZE_MB * MB_FACTOR);
        }
        if (writeBufferManager == null) writeBufferManager =
            new org.rocksdb.WriteBufferManager(Config.TOTAL_MEMTABLE_MB * MB_FACTOR, cache);
    }

    @Override
    public void setConfig(String s, Options options, Map<String, Object> map) {
        if (cache == null || writeBufferManager == null) initCacheOnce();
        logger.info("Configuring Global Cache");
        BlockBasedTableConfig tableConfig = (BlockBasedTableConfig) options.tableFormatConfig();

        tableConfig.setBlockCache(cache);
        tableConfig.setCacheIndexAndFilterBlocks(true);
        options.setWriteBufferManager(writeBufferManager);

        options.setTableFormatConfig(tableConfig);
    }
}
