import { IsString, IsEmail  } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateWorkoutDto {
    @ApiProperty()
    workoutTitle: string;

    @ApiProperty()
    workoutVideoUrl: string;

    @ApiProperty()
    workoutThumbnailUrl: string;

    @ApiProperty()
    workoutIdType: number;

    @ApiProperty()
    workoutRequiredXp: number;

    @ApiProperty()
    workoutValueXp: number;

    @ApiProperty()
    workoutDescription: string;

    @ApiProperty()
    points: number;
  
}