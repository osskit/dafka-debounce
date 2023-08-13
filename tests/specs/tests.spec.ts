import type {Orchestrator, KafkaOrchestrator} from '../testcontainers/orchestrator.js';
import {start as startKafka} from '../testcontainers/orchestrator.js';
import {Producer} from 'kafkajs';

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

    it('placeholder', async () => {});
});
