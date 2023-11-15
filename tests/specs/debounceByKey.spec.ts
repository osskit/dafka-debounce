import delay from 'delay';

import type {Orchestrator} from '../testcontainers/orchestrator.js';
import {start} from '../testcontainers/orchestrator.js';
import {produce} from '../services/produce.js';
import {getOffset} from '../services/getOffset.js';
import {consume} from '../services/consume.js';

const groupId = 'the-consumer';
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
                    COMMIT_INTERVAL_MS_CONFIG: '1000',
                    SOURCE_TOPIC: sourceTopic,
                    TARGET_TOPIC: targetTopic,
                    WINDOW_DURATION: '5',
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

    it('should debounce by key', async () => {
        await produce(orchestrator, {topic: sourceTopic, messages: [{value: JSON.stringify({data: 'bar'}), key: 'barkey'}]});
        await produce(orchestrator, {topic: sourceTopic, messages: [{value: JSON.stringify({data: 'bar'}), key: 'barkey'}]});

        await delay(5000);

        await expect(consume(orchestrator.kafkaClient, targetTopic)).resolves.toMatchSnapshot();
        await expect(getOffset(orchestrator.kafkaClient, groupId, sourceTopic)).resolves.toBe(2);
    });
});
