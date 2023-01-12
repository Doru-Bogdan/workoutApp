import { IsString, IsEmail  } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateWorkoutTypeDto {
  @ApiProperty()
  @IsString() 
  thumbnail: string;

  @ApiProperty()
  @IsString() 
  type: string;

  @ApiProperty()
  points: number;

  @ApiProperty()
  workoutIdType: number;
}