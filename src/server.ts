import express from 'express';
import config from './config';
import morgan from 'morgan';

const app = express();

// setup middleware
app.use(express.json({ strict: true }));
app.use(morgan('dev'));

// routers
import routers from './routers';
app.use('/api/v1', routers);

// start listening
const { port, host } = config;
await app.listen(port, host);
console.log(`Server listening at ${host}:${port}`);
