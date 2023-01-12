/* eslint-disable @typescript-eslint/no-unused-vars */
import { Entity as EntityOrm, Column, ManyToMany, OneToMany } from 'typeorm';
import { ApiProperty } from "@nestjs/swagger";
import { CoreEntity } from './CoreEntity';



@EntityOrm()
export class User extends CoreEntity {
    
    @ApiProperty()
    @Column()
    first_name: string;
  
    @ApiProperty()
    @Column()
    last_name: string;

    @ApiProperty()
    @Column({default: ""})
    username: string;

    @ApiProperty()
    @Column({ unique: true, length: 255 })
    email: string;
  
    @ApiProperty()
    @Column()
    password: string;

    @ApiProperty({nullable: true})
    @Column({
        default: null
    })
    token: string;

    @ApiProperty()
    @Column({
        type: String,
        default: null
    })
    certificateUrl?: string;

    @ApiProperty()
    @Column({
        type: Number,
        default: 0
    })
    currentPoints?: number;

    @ApiProperty()
    @Column({
        type: Number,
        default: 0
    })
    level?: number;

}
