import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ResponseFactory } from '../factories/ResponseFactory';
import { QueryParamsFilterFactory } from 'src/factories/QueryParamsFilter.factory';
import { Ranking } from 'src/entities/Ranking';
import { RankingService } from 'src/services/ranking.service';
import { RankingController } from 'src/controllers/ranking.controller';


@Module({
    imports: [
        TypeOrmModule.forFeature([
            Ranking,
        ]),

    ],
    exports: [TypeOrmModule],
    providers: [
        RankingService,
        ResponseFactory,
        QueryParamsFilterFactory
    ],
    controllers: [RankingController]
})
export class RankingModule { }
