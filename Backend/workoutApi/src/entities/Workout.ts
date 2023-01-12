/* eslint-disable @typescript-eslint/no-unused-vars */
import { Entity as EntityOrm, Column, ManyToMany, OneToMany } from 'typeorm';
import { ApiProperty } from "@nestjs/swagger";
import { CoreEntity } from './CoreEntity';

@EntityOrm()
export class Workout extends CoreEntity {
    
    @ApiProperty()
    @Column()
    workoutTitle: string;

    @ApiProperty()
    @Column()
    workoutVideoUrl: string;

    @ApiProperty()
    @Column()
    workoutThumbnailUrl: string;

    @ApiProperty()
    @Column({
        default: 0
    })
    workoutIdType: number;

    @ApiProperty()
    @Column({
        default: 0
    })
    workoutRequiredXp: number;

    @ApiProperty()
    @Column({
        default: 0
    })
    workoutValueXp: number;


    @ApiProperty()
    @Column({
        default: 0,
        type: 'longtext'
    })
    workoutDescription: string;


    @ApiProperty()
    @Column({
        default: 0,
    })
    points: number;

}
