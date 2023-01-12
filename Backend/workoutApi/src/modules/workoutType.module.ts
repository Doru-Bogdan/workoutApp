import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ResponseFactory } from '../factories/ResponseFactory';
import { QueryParamsFilterFactory } from 'src/factories/QueryParamsFilter.factory';
import { WorkoutType } from 'src/entities/WorkoutType';
import { WorkoutTypeService } from 'src/services/workoutType.service';
import { WorkoutTypeController } from 'src/controllers/workoutType.controller';


@Module({
    imports: [
        TypeOrmModule.forFeature([
            WorkoutType,
        ]),

    ],
    exports: [TypeOrmModule],
    providers: [
        WorkoutTypeService,
        ResponseFactory,
        QueryParamsFilterFactory
    ],
    controllers: [WorkoutTypeController]
})
export class WorkoutTypeModule { }
