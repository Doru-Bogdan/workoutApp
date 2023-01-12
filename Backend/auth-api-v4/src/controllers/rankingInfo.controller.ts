/* eslint-disable prefer-const */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
import { Controller, Post, Body, Get, Put, Delete, Param, Query, Res, UseGuards, UseFilters, UseInterceptors, UploadedFile } from '@nestjs/common';
import { UserService } from '../services/user.service';
import { ResponseFactory } from '../factories/ResponseFactory';
import { ApiTags, ApiQuery, ApiOkResponse, ApiForbiddenResponse, ApiBearerAuth } from '@nestjs/swagger';
import { Response } from 'express';
import { PasswordService } from '../services/password.service';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from '../entities/user';
import { Repository } from 'typeorm';
import { CreateUserDto } from 'src/dto/createUser.dto';
import { UpdateUserDto } from 'src/dto/updateUser.dto';
import { QueryParamsFilterFactory } from 'src/factories/QueryParamsFilter.factory';
import { AuthGuard } from '@nestjs/passport';
import { HttpExceptionFilter } from 'src/common/HttpExceptionFilter';
import { REGEX_UUID_VALIDATION } from 'src/helper/Regex';
import { ContextUser } from 'src/decorators/currentUserDecorator';


@ApiBearerAuth()
@ApiTags('Ranking')
@Controller('ranking')
@UseFilters(new HttpExceptionFilter())

export class RankingController {

    constructor(
        private readonly userService: UserService,
        private readonly responseFactory: ResponseFactory,
    ) { }


    @Get()
    async getClasament(
        @Res() response: Response
    ): Promise<any> {
            let users = await this.userService.getUsersForRanking();
            console.log(users);
            return this.responseFactory.clear(users, response);
    }
}


