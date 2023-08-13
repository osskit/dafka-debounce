import {Network, StartedNetwork} from 'testcontainers';
import {dafkaDebounce} from './dafkaDebounce.js';
import {kafka} from './kafka.js';
import {wiremock} from './wiremock.js';
import {WireMockClient} from '@osskit/wiremock-client';
import {Kafka} from 'kafkajs';

export interface KafkaOrchestrator {
    stop: () => Promise<void>;
    startOrchestrator: (dafkaEnv: Record<string, string>) => Promise<Orchestrator>;
    kafkaClient: Kafka;
}

export interface Orchestrator {
    stop: () => Promise<void>;
    wireMockClient: WireMockClient;
    consumerReady: () => Promise<Response>;
}

export const start = async () => {
    const network = await new Network().start();

    const {client: kafkaClient, stop: stopKafka} = await kafka(network);

    return {
        kafkaClient,
        stop: async () => {
            await stopKafka();

            await network.stop();
        },
        startOrchestrator: async (dafkaEnv: Record<string, string>) => {
            return startOrchestratorInner(network, dafkaEnv);
        },
    };
};

const startOrchestratorInner = async (
    network: StartedNetwork,
    dafkaEnv: Record<string, string>
): Promise<Orchestrator> => {
    const [{ready: streamReady, stop: stopService}] = await dafkaDebounce(network, dafkaEnv);
    );

    return {
        async stop() {
            await stopService();
        },
        streamReady,
    };
};
