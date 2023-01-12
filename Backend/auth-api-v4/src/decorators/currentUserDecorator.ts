import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { User } from '../entities/user';

export const ContextUser = createParamDecorator(
  (data: string, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    console.log(request.headers);
    console.log("request user", request.user);
    const user = <User>request.user;

    return user;
  },
);