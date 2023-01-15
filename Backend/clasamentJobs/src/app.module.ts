import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { RankingModule } from './modules/ranking.module';
import { RankingService } from './services/ranking.service';
import { ScheduleModule } from '@nestjs/schedule';

@Module({
  imports: [
    TypeOrmModule.forRoot({ keepConnectionAlive: true }),
    ScheduleModule.forRoot(),
    RankingModule
  ],
  controllers: [AppController],
  providers: [
    AppService
    
  ],
})

export class AppModule {}
