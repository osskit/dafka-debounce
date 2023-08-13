import {HttpMethod} from '@osskit/wiremock-client';
import type {Orchestrator, KafkaOrchestrator} from '../testcontainers/orchestrator.js';
import {start as startKafka} from '../testcontainers/orchestrator.js';
import {range} from 'lodash-es';
import pRetry from 'p-retry';
import {KafkaMessage, Producer} from 'kafkajs';

describe('tests', () => {
    let kafkaOrchestrator: KafkaOrchestrator;
    let orchestrator: Orchestrator;
    let producer: Producer;

    beforeAll(async () => {
        kafkaOrchestrator = await startKafka();
    }, 18000);

    afterAll(async () => {
        await kafkaOrchestrator.stop();
    }, 18000);

    afterEach(async () => {
        if (producer) {
            await producer.disconnect();
        }
        await orchestrator.stop();
    });

    const start = async (
        topics: string[],
        topicRoutes: {topic: string; targetPath: string}[],
        consumerSettings?: Record<string, string>
    ) => {
        orchestrator = await kafkaOrchestrator.startOrchestrator({
            GROUP_ID: 'test',
            ...consumerSettings,
        });

        const admin = kafkaOrchestrator.kafkaClient.admin();

        await admin.createTopics({topics: topics.map((topic) => ({topic}))});

        await orchestrator.streamReady();

        producer = kafkaOrchestrator.kafkaClient.producer();
        await producer.connect();
    };


    it('placeholder', async () => { });
});
