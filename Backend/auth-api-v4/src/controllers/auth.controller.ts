/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
/* eslint-disable prefer-const */
import { Controller, Post, Body, Res, Inject, UseFilters, UseInterceptors, UploadedFile } from '@nestjs/common';
import { AuthService } from '../services/auth.service';
import { UserService } from '../services/user.service';
import { PasswordService } from '../services/password.service';
import { ResponseFactory } from '../factories/ResponseFactory';
import { ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from '../entities/user';
import { Repository } from 'typeorm';
import { FileInterceptor } from '@nestjs/platform-express/multer/interceptors';
import { AuthDto } from 'src/dto/auth.dto';
import { CreateUserDto } from 'src/dto/createUser.dto';


@ApiTags('Auth')
@Controller('auth')
export class AuthController {
    constructor(
        private readonly authService: AuthService,
        private readonly userService: UserService,
        private readonly passwordService: PasswordService,
        private readonly responseFactory: ResponseFactory,
        @InjectRepository(User)
        private readonly userRepository: Repository<User>,
    ) { }

    
    @Post('login')
    async login(
        @Res() response: Response,
        @Body() { email, password }: AuthDto) {
        const user = await this.userService.getByEmail(email);

        if (!user)
            return this.responseFactory.notFound({ _general: 'auth.user_not_found' }, response);

        const isValid = await this.passwordService.comparePassword(password, user.password);

        if (!isValid)
            return this.responseFactory.notFound({ _general: 'auth.user_not_found' }, response);

        const token = await this.authService.createToken(email, user.id);

        return new ResponseFactory().ok({ "user": user, "token": token }, response);
    }

    @Post('register')
    async register(
        @Body() createUserDto: CreateUserDto,
        @Res() response: Response,
    ): Promise<any> {
        let user = await this.userService.create(createUserDto);

        if (user)
            this.responseFactory.ok(user, response);

        else
            this.responseFactory.notFound({ _general: 'auth.user_can`t_be_created' }, response);
    }
}
