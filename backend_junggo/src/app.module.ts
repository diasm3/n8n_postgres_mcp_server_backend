import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UsersModule } from './users/users.module';
import { PrismaModule } from './prisma/prisma.module';
import { UserLogsModule } from './user-logs/user-logs.module';
import { InternalUsersModule } from './internal-users/internal-users.module';
import { ComplaintsModule } from './complaints/complaints.module';

@Module({
  imports: [PrismaModule, UsersModule, UserLogsModule, InternalUsersModule, ComplaintsModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
