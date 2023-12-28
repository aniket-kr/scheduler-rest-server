import express, { type NextFunction, type Request, type Response } from 'express';
import { isHttpError, InternalServerError, type HttpError } from 'http-errors';
import config from './config';
import morgan from 'morgan';

const app = express();

// setup middleware
app.use(express.json({ strict: true }));
app.use(morgan('dev'));

// routers
import routers from './routers';
app.use('/api/v1', routers);

// error handling
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
    function makeInternalError(err: Error) {
        const httpError = new InternalServerError('Something went wrong!');
        httpError.cause = err;
        return httpError;
    }

    function debugInfo(httpError: HttpError) {
        if (config.isDebug) {
            const { cause, stack } = httpError;
            return { cause, stack };
        }
        return {};
    }
    const httpError = isHttpError(err) ? err : makeInternalError(err);

    res.status(httpError.status).json({
        url: req.originalUrl,
        status: httpError.status,
        name: httpError.name,
        message: httpError.message,
        ...debugInfo(httpError),
    });
});

// start listening
const { port, host } = config;
await app.listen(port, host);
console.log(`Server listening at ${host}:${port}`);
