import 'dotenv/config';

const { env } = Bun;

class ConfigError extends Error {
    constructor(message: string) {
        super(message);
    }
}
const config = {
    host: env.HOST || '0.0.0.0',
    port: parseInt(env.PORT || missing('PORT'), 10) || invalid('PORT'),
    isDebug: env.NODE_ENV?.toLowerCase().trim() === 'development',
};
export default config;

function missing(key: string): never {
    const msg = `Missing config key: ${key}`;
    throw new ConfigError(msg);
}

function invalid(key: string): never {
    const msg = `Invalid config value: ${key}=${env[key] || ''}`;
    throw new ConfigError(msg);
}
