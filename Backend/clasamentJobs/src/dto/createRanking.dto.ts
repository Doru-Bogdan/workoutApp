import { IsString, IsEmail  } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateRankingDto {
    @ApiProperty()
    date: string;

    @ApiProperty()
    position: number;

    @ApiProperty()
    first_name: string;
    
    @ApiProperty()
    last_name: string;

}