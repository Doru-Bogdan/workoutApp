/* eslint-disable prefer-const */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
import { Controller, Post, Body, Get, Put, Delete, Param, Query, Res, UseGuards, UseFilters, UseInterceptors, UploadedFile } from '@nestjs/common';
import { ResponseFactory } from '../factories/ResponseFactory';
import { ApiTags, ApiQuery, ApiOkResponse, ApiForbiddenResponse, ApiBearerAuth } from '@nestjs/swagger';
import { Response } from 'express';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { QueryParamsFilterFactory } from 'src/factories/QueryParamsFilter.factory';
import { AuthGuard } from '@nestjs/passport';
import { HttpExceptionFilter } from 'src/common/HttpExceptionFilter';
import { REGEX_UUID_VALIDATION } from 'src/helper/Regex';
import { RankingService } from 'src/services/ranking.service';
import { CreateRankingDto } from 'src/dto/createRanking.dto';


@ApiBearerAuth()
@ApiTags('Ranking')
@Controller('ranking')
@UseFilters(new HttpExceptionFilter())

export class RankingController {

    constructor(
        private readonly rankingService: RankingService,
        private readonly responseFactory: ResponseFactory,
    ) { }



    @Post("/ranking-for-a-date")
    async create(
        @Body() body: {date: string},
        @Res() response: Response
    ): Promise<any> {
        const ranking = await this.rankingService.getClasamentByDate(body.date);

        if (ranking)
            this.responseFactory.ok(ranking, response);

        else
            this.responseFactory.notFound({ general_: 'ranking.user_can`t_be_created' }, response);
    }

}

