import { IsNumber, IsEmpty, IsString, IsEmail, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateUserDto {
    @ApiPropertyOptional({
        type: String,
        description: "The first_name",
    })
    @IsOptional()
    @IsString()
    first_name?: string;

    @ApiPropertyOptional({
        type: String,
        description: "The last_name",
    })
    @IsOptional()
    @IsString()
    last_name?: string;

    @ApiPropertyOptional({
        type: String,
        description: "The username",
    })
    @IsOptional()
    @IsString()
    username?: string;

    @ApiPropertyOptional({
        type: String,
        description: "The certificate",
    })
    @IsOptional()
    @IsString()
    certificateUrl?: string;
    
    @ApiPropertyOptional({
        type: Number,
        description: "The level",
    })
    @IsOptional()
    @IsNumber()
    level?: number;

    @ApiPropertyOptional({
        type: Number,
        description: "The currentPoints",
    })
    @IsOptional()
    @IsNumber()
    currentPoints?: number;

    @ApiPropertyOptional({
        type: String,
        description: "The email",
    })
    @IsOptional()
    @IsEmail()
    email?: string;
}