/* eslint-disable @typescript-eslint/no-var-requires */
/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-inferrable-types */
/* eslint-disable no-var */
/* eslint-disable prefer-const */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between, MoreThan, LessThan, getConnection, getManager } from 'typeorm';
import { plainToClass } from 'class-transformer';
import { query } from 'express';
import { Ranking } from 'src/entities/Ranking';
import { CreateRankingDto } from 'src/dto/createRanking.dto';
import { Cron } from '@nestjs/schedule';
import axios from 'axios';

@Injectable()
export class RankingService {
    constructor(
        @InjectRepository(Ranking)
        private readonly rankingRepository: Repository<Ranking>,

    ) { }


    @Cron('01 * * * * *')
    async createRanking(): Promise<any> {
        console.log("AM INTRAT");
        let raspunsRequest:any = await axios.get('http://localhost:3500/ranking')
            .then(function (response) {
                // console.log(response);
                let raspuns: any []= []
                for (let i = 0; i < response.data.length; i++) {
                    let obj = {
                        date: new Date().getMonth() + " " + new Date().getFullYear(),
                        position: i+1,
                        last_name: response.data[i].user_last_name,
                        first_name: response.data[i].user_first_name,
                        user_level: response.data[i].user_level,
                        user_currentPoints: response.data[i].user_currentPoints
                    }
                    raspuns.push(obj)
                    //await this.rankingRepository.save(ranking);
                }

                return raspuns;
            })
            .catch(function (error) {
                console.log(error);
            })
            console.log(raspunsRequest)
            for (let i = 0; i < raspunsRequest.length; i++) {
                await this.rankingRepository.save(raspunsRequest[i]);
            }
        
    }

    async create(ranking: CreateRankingDto): Promise<Ranking> {
        return await this.rankingRepository.save(ranking);
    }

    async getClasamentByDate(date: string): Promise<Ranking[]> {

        let finds = await this.rankingRepository.find({
            where: {
                date: date

            }
        });;

        return finds;
    }


}
