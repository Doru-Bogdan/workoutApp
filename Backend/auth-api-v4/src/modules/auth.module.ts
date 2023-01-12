import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthController } from 'src/controllers/auth.controller';
import { User } from 'src/entities/user';
import { ResponseFactory } from 'src/factories/ResponseFactory';
import { AuthService } from 'src/services/auth.service';
import { PasswordService } from 'src/services/password.service';
import { UserService } from 'src/services/user.service';
import { JwtStrategy } from 'src/strategy/jwtStrategy';


@Module({

  imports: [
    TypeOrmModule.forFeature([
      User
    ])],
  providers: [
    AuthService,
    UserService,
    PasswordService,
    ResponseFactory,
    JwtStrategy
  ],
  controllers: [AuthController],
})
export class AuthModule { }
