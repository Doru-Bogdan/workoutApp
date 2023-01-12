/* eslint-disable @typescript-eslint/no-unused-vars */
import { Entity as EntityOrm, Column, ManyToMany, OneToMany } from 'typeorm';
import { ApiProperty } from "@nestjs/swagger";
import { CoreEntity } from './CoreEntity';

@EntityOrm()
export class WorkoutType extends CoreEntity {
    
    @ApiProperty()
    @Column()
    thumbnail: string;

    @ApiProperty()
    @Column()
    type: string;

    @ApiProperty()
    @Column({
        default: 0
    })
    workoutIdType: number;

    @ApiProperty()
    @Column()
    points: number;

}
