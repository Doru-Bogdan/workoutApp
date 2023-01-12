import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ResponseFactory } from '../factories/ResponseFactory';
import { QueryParamsFilterFactory } from 'src/factories/QueryParamsFilter.factory';
import { Workout } from 'src/entities/Workout';
import { WorkoutService } from 'src/services/workout.service';
import { WorkoutController } from 'src/controllers/workout.controller';


@Module({
    imports: [
        TypeOrmModule.forFeature([
            Workout,
        ]),

    ],
    exports: [TypeOrmModule],
    providers: [
        WorkoutService,
        ResponseFactory,
        QueryParamsFilterFactory
    ],
    controllers: [WorkoutController]
})
export class WorkoutModule { }
