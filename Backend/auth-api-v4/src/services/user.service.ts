/* eslint-disable @typescript-eslint/no-var-requires */
/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-inferrable-types */
/* eslint-disable no-var */
/* eslint-disable prefer-const */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between, MoreThan, LessThan, getConnection, getManager } from 'typeorm';
import { User } from '../entities/user';
import { plainToClass } from 'class-transformer';
import { PasswordService } from './password.service';
import { query } from 'express';
import { CreateUserDto } from 'src/dto/createUser.dto';
import { UpdateUserDto } from 'src/dto/updateUser.dto';
import { Cron } from '@nestjs/schedule';

@Injectable()
export class UserService {
    constructor(
        @InjectRepository(User)
        private readonly userRepository: Repository<User>,
        private readonly passwordService: PasswordService,

    ) { }


    async getClasament(): Promise<User[]> {
        const repository = await getManager().createQueryBuilder(User, "user").
            orderBy("user.currentPoints", "DESC")
            .take(10)


        let users = await this.userRepository.find({
            order: {
                currentPoints: 1
            },
            take: 10
        });
        return repository.execute();
    }

    async getUsersForRanking(): Promise<User[]> {
        const repository = await getManager().createQueryBuilder(User, "user").
            orderBy("user.currentPoints", "DESC")
            .take(10)

        return repository.execute();
    }

    async getAll(filters: any): Promise<User[]> {

        let finds = await this.userRepository.find({
            where: filters,
        });

        return finds;
    }

    async getByEmail(email: string): Promise<User> {

        return await this.userRepository.findOne({ email }, {
        });
    }
    async getById(id: string): Promise<User> {

        return this.userRepository.findOne(id, {
        });
    }
    async create(createUserDto: CreateUserDto): Promise<User> {
        const password = await this.passwordService.generatePassword(createUserDto.password);
        const user = plainToClass(User, createUserDto);
        user.password = password;
        return await this.userRepository.save(user);

    }

    @Cron('0 0 12 1 * ?	')//Every month on the 1st, at noon
    async updateAllUsers() {
        const repository = await getManager().createQueryBuilder()
            .update(User)
            .set({
                currentPoints: 0
            })
            .execute()
    }

    async update(id: string, updateUserDto: UpdateUserDto): Promise<User> {
        await this.userRepository.update({ id: id }, updateUserDto);

        return this.userRepository.findOne(id);
    }

    async delete(id: string): Promise<any> {
        return await this.userRepository.delete(id);
    }

}
