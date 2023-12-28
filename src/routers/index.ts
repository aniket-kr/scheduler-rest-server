import { Router } from 'express';

import { authRouter } from './auth.router';

const router = Router();

router.use('/auth', authRouter);

const baseRouter = router;
export default baseRouter;
