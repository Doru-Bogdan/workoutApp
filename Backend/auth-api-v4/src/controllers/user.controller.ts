/* eslint-disable prefer-const */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
import { Controller, Post, Body, Get, Put, Delete, Param, Query, Res, UseGuards, UseFilters, UseInterceptors, UploadedFile } from '@nestjs/common';
import { UserService } from '../services/user.service';
import { ResponseFactory } from '../factories/ResponseFactory';
import { ApiTags, ApiQuery, ApiOkResponse, ApiForbiddenResponse, ApiBearerAuth } from '@nestjs/swagger';
import { Response } from 'express';
import { PasswordService } from '../services/password.service';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from '../entities/user';
import { Repository } from 'typeorm';
import { CreateUserDto } from 'src/dto/createUser.dto';
import { UpdateUserDto } from 'src/dto/updateUser.dto';
import { QueryParamsFilterFactory } from 'src/factories/QueryParamsFilter.factory';
import { AuthGuard } from '@nestjs/passport';
import { HttpExceptionFilter } from 'src/common/HttpExceptionFilter';
import { REGEX_UUID_VALIDATION } from 'src/helper/Regex';
import { ContextUser } from 'src/decorators/currentUserDecorator';


@ApiBearerAuth()
@ApiTags('User')
@Controller('users')
@UseGuards(AuthGuard('jwt'))    
@UseFilters(new HttpExceptionFilter())

export class UserController {

    constructor(
        private readonly userService: UserService,
        private readonly responseFactory: ResponseFactory,
        private readonly passwordService: PasswordService,
        private readonly queryParamsFilterFactory: QueryParamsFilterFactory,

        @InjectRepository(User)
        private readonly userRepository: Repository<User>,
    ) { }

    @Get()
    @ApiQuery({ name: 'pagination', type: Boolean, required: false })
    @ApiQuery({ name: 'page', type: Number, required: false })
    @ApiQuery({ name: 'limit', type: Number, required: false })
    @ApiQuery({ name: 'sort_order', type: String, required: false })
    @ApiQuery({ name: 'sort_direction', type: String, required: false, description: " ASC | DESC" })
    async getAll(
        @Query() paginationDto: any,
        @Query() sortDto: any,
        @Query() userQueryParams: any,
        // @ContextUser() user,
        @Res() response: Response
    ): Promise<any> {
            let users = await this.userService.getAll(
                await this.queryParamsFilterFactory.filter(userQueryParams));

            return this.responseFactory.ok(users, response);
        
    }
    @Get("/clasament")
    async getClasament(
        @Res() response: Response
    ): Promise<any> {
            let users = await this.userService.getClasament();
            console.log(users);
            return this.responseFactory.clear(users, response);
        
    }


    @Get(`/:id(${REGEX_UUID_VALIDATION})`)
    async getById(
        @Param('id') id: string,
        @Res() response: Response) {
            console.log("aici")
        const user = await this.userService.getById(id);

        if (!user) {
            return this.responseFactory.notFound({ general_: 'users.user_not_found' }, response);
        }

        return this.responseFactory.ok(user, response);
    }

    @Post()
    async create(
        @Body() createUserDto: CreateUserDto,
        @Res() response: Response
    ): Promise<any> {
        const user = await this.userService.create(createUserDto);

        if (user)
            this.responseFactory.ok(user, response);

        else
            this.responseFactory.notFound({ general_: 'users.user_can`t_be_created' }, response);
    }

    @Get("/account")
    async getAccount(
        @ContextUser() user,
        @Res() response: Response) : Promise<any>{
            console.log("Aici", user);
        this.responseFactory.ok(user, response);
    }


    @Delete(':id')
    async delete(
        @Param('id') id: string,
        @Res() response: Response) {
        const user = await this.userService.getById(id);

        if (!user) {
            return await this.responseFactory.notFound({ _general: 'users.user_not_found' }, response);
        }

        await this.userService.delete(id);
        this.responseFactory.ok(user, response);
    }

    @Put(':id')
    async update(
        @Body() updateUserDto: UpdateUserDto,
        @Param('id') id: string,
        @Res() response: Response
    ): Promise<any> {
        let user = await this.userService.getById(id);

        if (!user) {
            return this.responseFactory.notFound({ _general: 'users.user_not_found' }, response);
        }

        if (updateUserDto.email)
            user.email = updateUserDto.email;
        if (updateUserDto.first_name)
            user.first_name = updateUserDto.first_name;
        if (updateUserDto.last_name)
            user.last_name = updateUserDto.last_name;
        if (updateUserDto.username)
            user.last_name = updateUserDto.last_name;
        if (updateUserDto.certificateUrl)
            user.certificateUrl = updateUserDto.certificateUrl;
        if (updateUserDto.currentPoints)
            user.currentPoints = updateUserDto.currentPoints;
        if (updateUserDto.level)
            user.level = updateUserDto.level;
        user = await this.userRepository.save(user);

        return this.responseFactory.ok(user, response);
    }


}


