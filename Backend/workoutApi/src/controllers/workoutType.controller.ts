/* eslint-disable prefer-const */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
import { Controller, Post, Body, Get, Put, Delete, Param, Query, Res, UseGuards, UseFilters, UseInterceptors, UploadedFile } from '@nestjs/common';
import { ResponseFactory } from '../factories/ResponseFactory';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { Response } from 'express';
import { AuthGuard } from '@nestjs/passport';
import { HttpExceptionFilter } from 'src/common/HttpExceptionFilter';
import { WorkoutTypeService } from 'src/services/workoutType.service';
import { CreateWorkoutTypeDto } from 'src/dto/createWorkoutType.dto';


@ApiBearerAuth()
@ApiTags('Workout-type')
@Controller('workout-types')
@UseFilters(new HttpExceptionFilter())

export class WorkoutTypeController {

    constructor(
        private readonly workoutTypeService: WorkoutTypeService,
        private readonly responseFactory: ResponseFactory,
    ) { }

    @Get()
    async getAll(
        @Res() response: Response
    ): Promise<any> {
       console.log("AICI")
        let users = await this.workoutTypeService.getAll();

        this.responseFactory.clear(users, response);
        
    }

    @Post()
    async create(
        @Body() workout: CreateWorkoutTypeDto,
        @Res() response: Response
    ): Promise<any> {
        const user = await this.workoutTypeService.create(workout);

        if (user)
            this.responseFactory.ok(user, response);

        else
            this.responseFactory.notFound({ general_: 'users.user_can`t_be_created' }, response);
    }

}


