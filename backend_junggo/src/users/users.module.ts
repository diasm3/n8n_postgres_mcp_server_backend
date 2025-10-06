import { Module } from '@nestjs/common';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';
import { UserLogsModule } from '../user-logs/user-logs.module';

@Module({
  imports: [UserLogsModule],
  controllers: [UsersController],
  providers: [UsersService],
})
export class UsersModule {}
