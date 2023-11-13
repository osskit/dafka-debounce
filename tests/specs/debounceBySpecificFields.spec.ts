import delay from 'delay';

import type {Orchestrator} from '../testcontainers/orchestrator.js';
import {start} from '../testcontainers/orchestrator.js';
import {produce} from '../services/produce.js';
import {getOffset} from '../services/getOffset.js';
import {consume} from '../services/consume.js';

const groupId = 'test11';
const sourceTopic = 'test-input';
const targetTopic = 'test-output';

describe('tests', () => {
    let orchestrator: Orchestrator;

    beforeEach(
        async () => {
            orchestrator = await start(
                {
                    KAFKA_BROKER: 'kafka:9092',
                    MONITORING_SERVER_PORT: '3000',
                    GROUP_ID: groupId,
                    SOURCE_TOPIC: sourceTopic,
                    TARGET_TOPIC: targetTopic,
                    WINDOW_DURATION: '5',
                    OUTPUT_PARTITIONING_KEY: 'SPECIFIC_FIELDS',
                    OUTPUT_PARTITIONING_KEY_FIELDS: '/data/type',
                },
                [sourceTopic, targetTopic]
            );
        },
        5 * 60 * 1000
    );

    afterEach(async () => {
        if (!orchestrator) {
            return;
        }
        await orchestrator.stop();
    });

    it('should debounce by specific fields', async () => {
        await produce(orchestrator, {topic: sourceTopic, messages: [{value: JSON.stringify({data: {type: 'bar'}}), key: '1'}]});
        await produce(orchestrator, {topic: sourceTopic, messages: [{value: JSON.stringify({data: {type: 'bar'}}), key: '2'}]});

        await delay(5000);

        await expect(consume(orchestrator.kafkaClient, targetTopic)).resolves.toMatchSnapshot();

        await delay(5000);

        await expect(getOffset(orchestrator.kafkaClient, groupId, sourceTopic)).resolves.toBe(2);
    });
});
