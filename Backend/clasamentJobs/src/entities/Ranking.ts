/* eslint-disable @typescript-eslint/no-unused-vars */
import { Entity as EntityOrm, Column, ManyToMany, OneToMany } from 'typeorm';
import { ApiProperty } from "@nestjs/swagger";
import { CoreEntity } from './CoreEntity';

@EntityOrm()
export class Ranking extends CoreEntity {
    
    @ApiProperty()
    @Column()
    date: string;

    @ApiProperty()
    @Column()
    position: number;

    @ApiProperty()
    @Column()
    last_name: string;

    @ApiProperty()
    @Column()
    first_name: string;

}
