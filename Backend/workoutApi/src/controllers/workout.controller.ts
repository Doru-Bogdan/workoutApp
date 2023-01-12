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
import { WorkoutTypeService } from 'src/services/workoutType.service';
import { CreateWorkoutTypeDto } from 'src/dto/createWorkoutType.dto';
import { WorkoutService } from 'src/services/workout.service';
import { CreateWorkoutDto } from 'src/dto/createWorkout.dto';


@ApiBearerAuth()
@ApiTags('Workout')
@Controller('workout')
@UseFilters(new HttpExceptionFilter())

export class WorkoutController {

    constructor(
        private readonly workoutService: WorkoutService,
        private readonly responseFactory: ResponseFactory,
    ) { }

    @Get('/type/:id')
    async getAll(
        @Param('id') id: number,
        @Res() response: Response
    ): Promise<any> {
        let workouts = await this.workoutService.getAll(id);

        this.responseFactory.clear(workouts, response);
        
    }

    @Get('/:id')
    async getById(
        @Param('id') id: string,
        @Res() response: Response
    ): Promise<any> {
        let workout = await this.workoutService.getById(id);

        this.responseFactory.clear(workout, response);
        
    }

    @Post()
    async create(
        @Body() createworkout: CreateWorkoutDto,
        @Res() response: Response
    ): Promise<any> {
        const workout = await this.workoutService.create(createworkout);

        if (workout)
            this.responseFactory.ok(workout, response);

        else
            this.responseFactory.notFound({ general_: 'users.user_can`t_be_created' }, response);
    }

}


