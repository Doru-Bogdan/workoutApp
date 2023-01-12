import { ExceptionFilter, Catch, ArgumentsHost, HttpException, HttpStatus } from '@nestjs/common';
import { Request, Response } from 'express';
import { ResponseFactory } from '../factories/ResponseFactory';

@Catch(HttpException)
export class    HttpExceptionFilter implements ExceptionFilter {
    catch(exception: HttpException, host: ArgumentsHost) {
        const responseFactory = new ResponseFactory();

        const ctx = host.switchToHttp();
        const response = ctx.getResponse<Response>();
        const request = ctx.getRequest<Request>();
        const status = exception.getStatus();
        console.log(ctx)
        let obj = exception.getResponse();
        let error = {}
        if(obj["message"]){
            for (let i = 0; i < obj["message"].length; i++){
                let split = obj["message"][i].split(" ");
                let key = split[0];
                error[key] = obj["message"][i];
            }
        }
        
            switch (status) {
                case 400:
                    return responseFactory.badRequest(error, response);
                case 403:
                    return responseFactory.forbidden('Forbidden', response);
                case 401:
                    return responseFactory.forbidden('UNAUTHORIZED', response);
                case 404:
                    return responseFactory.forbidden('Not found', response);
                default:
                    return responseFactory.error('General error', response);
            }
    }
}