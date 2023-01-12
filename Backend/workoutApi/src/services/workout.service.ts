/* eslint-disable @typescript-eslint/no-var-requires */
/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-inferrable-types */
/* eslint-disable no-var */
/* eslint-disable prefer-const */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between, MoreThan, LessThan, getConnection, getManager } from 'typeorm';
import { plainToClass } from 'class-transformer';
import { query } from 'express';
import { WorkoutType } from 'src/entities/WorkoutType';
import { CreateWorkoutTypeDto } from 'src/dto/createWorkoutType.dto';
import { Workout } from 'src/entities/Workout';
import { CreateWorkoutDto } from 'src/dto/createWorkout.dto';

@Injectable()
export class WorkoutService {
    constructor(
        @InjectRepository(Workout)
        private readonly workoutRepository: Repository<Workout>,

    ) { }


    async getAll(typeId: number): Promise<Workout[]> {

        let finds = await this.workoutRepository.find({
            where:{
                workoutIdType:typeId 

            },
            order:{
                workoutRequiredXp: "ASC"
            }
        });

        return finds;
    }

    async create(workout: CreateWorkoutDto): Promise<Workout> {
        return await this.workoutRepository.save(workout);
    }

    async getById(id: string): Promise<Workout> {

        let finds = await this.workoutRepository.findOne(id);

        return finds;
    }


}
