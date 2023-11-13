import {Network} from 'testcontainers';
import {dafka} from './dafka.js';
import {kafka} from './kafka.js';
import {wiremock} from './wiremock.js';
import {WireMockClient} from '@osskit/wiremock-client';
import {Kafka} from 'kafkajs';

export interface Orchestrator {
    kafkaClient: Kafka;
    wiremockClient: WireMockClient;
    stop: () => Promise<void>;
}

export const start = async (env: Record<string, string>, topics: string[]) => {
    const network = await new Network().start();

    const {client: kafkaClient, stop: stopKafka} = await kafka(network, topics);
    const {stop: stopDafka} = await dafka(network, env);
    const {client: wiremockClient, stop: stopWiremock} = await wiremock(network);

    return {
        kafkaClient,
        wiremockClient,
        stop: async () => {
            await stopDafka();
            await stopWiremock();
            await stopKafka();
            await network.stop();
        },
    };
};
