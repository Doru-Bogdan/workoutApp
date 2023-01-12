import { IsString, IsEmail  } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateUserDto {
  @ApiProperty({
    type: String,
    description: "The first_name",
    default:''
  })
  @IsString() 
  first_name: string;

  @ApiProperty({
    type: String,
    description: "The last_name",
    default:''
  })
  @IsString() 
  last_name: string;

  @ApiProperty({
    type: String,
    description: "The last_name",
    default:''
  })
  username: string;

  @ApiProperty({
    type: String,
    description: "The email",
    default:''
  })
  @IsEmail() 
  email: string;

  @ApiProperty({
    type: String,
    description: "The password",
    default:''
  })
  @IsString() 
  password: string;
}