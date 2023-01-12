import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './modules/auth.module';
import { UserModule } from './modules/user.module';
import { PasswordService } from './services/password.service';
import { UserService } from './services/user.service';

@Module({
  imports: [
    TypeOrmModule.forRoot({ keepConnectionAlive: true }),
    UserModule,
    AuthModule,

  ],
  controllers: [AppController],
  providers: [
    AppService, 
    UserService,
    PasswordService,
  ],
})
export class AppModule {}
