import {Network, StartedNetwork} from 'testcontainers';
import {kafka} from './kafka.js';
import {Kafka} from 'kafkajs';
import {dafkaDebounce} from './dafkaDebounce';

export interface KafkaOrchestrator {
    stop: () => Promise<void>;
    startOrchestrator: (debounceEnv: Record<string, string>) => Promise<Orchestrator>;
    kafkaClient: Kafka;
}

export interface Orchestrator {
    stop: () => Promise<void>;
    debounceReady: () => Promise<Response>;
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
        startOrchestrator: async (debounceEnv: Record<string, string>) => {
            return startOrchestratorInner(network, debounceEnv);
        },
    };
};

const startOrchestratorInner = async (
    network: StartedNetwork,
    debounceEnv: Record<string, string>
): Promise<Orchestrator> => {
    const {ready: debounceReady, stop: stopService} = await dafkaDebounce(network, debounceEnv);

    return {
        async stop() {
            await stopService();
        },
        debounceReady,
    };
};
