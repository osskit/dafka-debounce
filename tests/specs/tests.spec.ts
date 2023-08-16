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
        const admin = kafkaOrchestrator.kafkaClient.admin();
        await admin.createTopics({topics: [{topic: sourceTopic}, {topic: targetTopic}]});

        orchestrator = await kafkaOrchestrator.startOrchestrator({
            GROUP_ID: 'test',
            SOURCE_TOPIC: sourceTopic,
            TARGET_TOPIC: targetTopic,
            ...debounceSettings,
        });

        await orchestrator.debounceReady();

        producer = kafkaOrchestrator.kafkaClient.producer();
        consumer = kafkaOrchestrator.kafkaClient.consumer({groupId: 'test-consumer'});

        await consumer.connect();
        await consumer.subscribe({topic: targetTopic, fromBeginning: true});

        await producer.connect();
    };

    const assertOffset = async (topic: string) => {
        const admin = kafkaOrchestrator.kafkaClient.admin();

        await admin.connect();

        const metadata = await admin.fetchOffsets({groupId: 'test-consumer', topics: [topic]});

        await admin.disconnect();

        expect(metadata).toMatchSnapshot();
    };

    it('Should debounce 4 records 2 of each key', async () => {
        await start('test-input', 'test-output', {
            WINDOW_DURATION: '5',
        });

        await producer.send({topic: 'test-input', messages: [{value: JSON.stringify({data: 'foo'}), key: 'fookey'}]});
        await producer.send({topic: 'test-input', messages: [{value: JSON.stringify({data: 'bar'}), key: 'barkey'}]});

        await delay(2000);

        await producer.send({topic: 'test-input', messages: [{value: JSON.stringify({data: 'foo1'}), key: 'fookey'}]});
        await producer.send({topic: 'test-input', messages: [{value: JSON.stringify({data: 'bar1'}), key: 'barkey'}]});

        await delay(6000);

        const messages: KafkaMessage[] = [];
        await new Promise<KafkaMessage[]>((resolve) => {
            consumer.run({
                eachMessage: async ({message}) => {
                    messages.push(message);
                    if (messages.length == 2) resolve(messages);
                },
            });
        });
        await delay(2000);

        await assertOffset('test-output');

        expect(JSON.parse(messages[0]?.value?.toString() ?? '{}')).toMatchSnapshot();
        expect(JSON.parse(messages[1]?.value?.toString() ?? '{}')).toMatchSnapshot();
    }, 180000);
});
