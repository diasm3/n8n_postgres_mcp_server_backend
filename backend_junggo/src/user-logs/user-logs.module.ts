import { Module } from '@nestjs/common';
import { UserLogsController } from './user-logs.controller';
import { UserLogsService } from './user-logs.service';

@Module({
  controllers: [UserLogsController],
  providers: [UserLogsService],
  exports: [UserLogsService],
})
export class UserLogsModule {}
