import { Module } from '@nestjs/common';
import { InternalUsersService } from './internal-users.service';
import { InternalUsersController } from './internal-users.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [InternalUsersService],
  controllers: [InternalUsersController],
  exports: [InternalUsersService],
})
export class InternalUsersModule {}
