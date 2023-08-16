import {KafkaOrchestrator, Orchestrator} from '../testcontainers/orchestrator';
import {start as startKafka} from '../testcontainers/orchestrator.js';
import {Consumer, KafkaMessage, Producer} from 'kafkajs';
import delay from 'delay';

describe('tests', () => {
    let kafkaOrchestrator: KafkaOrchestrator;
    let orchestrator: Orchestrator;
    let producer: Producer;
    let consumer: Consumer;

    beforeAll(async () => {
        kafkaOrchestrator = await startKafka();
    }, 180000);

    afterAll(async () => {
        await kafkaOrchestrator.stop();
    }, 180000);

    afterEach(async () => {
        if (producer) {
            await producer.disconnect();
        }
        if (consumer) {
            await consumer.disconnect();
        }
        await orchestrator.stop();
    });

    const start = async (sourceTopic: string, targetTopic: string, debounceSettings?: Record<string, string>) => {
        console.log('test 1');
        orchestrator = await kafkaOrchestrator.startOrchestrator({
            GROUP_ID: 'test',
            SOURCE_TOPIC: sourceTopic,
            TARGET_TOPIC: targetTopic,
            ...debounceSettings,
        });
        console.log('test 2');
        const admin = kafkaOrchestrator.kafkaClient.admin();
        console.log('test 3');

        await admin.createTopics({topics: [{topic: sourceTopic}, {topic: targetTopic}]});
        console.log('test 4');

        await orchestrator.debounceReady();
        console.log('test 5');

        producer = kafkaOrchestrator.kafkaClient.producer();
        consumer = kafkaOrchestrator.kafkaClient.consumer({groupId: 'test-consumer'});
        console.log('test 6');

        await consumer.connect();
        console.log('test 7');

        await producer.connect();
        console.log('test 8');
    };

    it('Should debounce records from same key', async () => {
        console.log('what!');

        await start('test-input', 'test-output', {
            WINDOW_DURATION: '5',
        });
        console.log('im here');
        await producer.send({topic: 'test-input', messages: [{value: JSON.stringify({data: 'foo'}), key: 'fookey'}]});
        await producer.send({topic: 'test-input', messages: [{value: JSON.stringify({data: 'bar'}), key: 'barkey'}]});
        console.log('im here 1');
        await delay(2000);
        await producer.send({topic: 'test-input', messages: [{value: JSON.stringify({data: 'foo1'}), key: 'fookey'}]});
        await producer.send({topic: 'test-input', messages: [{value: JSON.stringify({data: 'bar1'}), key: 'barkey'}]});
        console.log('im here 2');
        await delay(4000);
        console.log('im here 3');
        const consumedMessage = await new Promise<KafkaMessage>((resolve) => {
            consumer.run({
                eachMessage: async ({message}) => resolve(message),
            });
        });

        console.log('consumedMessage', consumedMessage);
    }, 180000);
});
