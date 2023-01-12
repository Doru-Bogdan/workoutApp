import { IsString, IsEmail } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class AuthDto {
  @ApiProperty({
    type: String,
    description: "The email",
    default:'usergmail.com'
  })
  @IsEmail() readonly email: string;

  @ApiProperty({
    type: String,
    description: "The password",
    default:'user'
  })
  @IsString() readonly password: string;
}