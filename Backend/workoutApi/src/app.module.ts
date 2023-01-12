import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { WorkoutModule } from './modules/workout.module';
import { WorkoutTypeModule } from './modules/workoutType.module';
import { WorkoutService } from './services/workout.service';
import { WorkoutTypeService } from './services/workoutType.service';

@Module({
  imports: [
    TypeOrmModule.forRoot({ keepConnectionAlive: true }),
    WorkoutTypeModule,
    WorkoutModule
  ],
  controllers: [AppController],
  providers: [
    AppService, 
    WorkoutTypeService,
    WorkoutService
  ],
})

export class AppModule {}
