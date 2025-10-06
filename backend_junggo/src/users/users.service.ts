import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { CustomerUser } from '@prisma/client';
import { UserLogsService } from '../user-logs/user-logs.service';

@Injectable()
export class UsersService {
  constructor(
    private prisma: PrismaService,
    private userLogsService: UserLogsService,
  ) {}

  async create(createUserDto: CreateUserDto): Promise<CustomerUser> {
    const user = await this.prisma.customerUser.create({
      data: createUserDto,
    });

    // Log user creation
    await this.userLogsService.create({
      userId: user.id,
      eventType: 'USER_CREATED',
      eventCategory: 'USER',
      eventData: { email: user.email },
      level: 'info',
    });

    return user;
  }

  async findAll(): Promise<CustomerUser[]> {
    return this.prisma.customerUser.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  async findOne(id: string): Promise<CustomerUser | null> {
    return this.prisma.customerUser.findUnique({
      where: { id },
    });
  }

  async update(id: string, updateUserDto: UpdateUserDto): Promise<CustomerUser> {
    const user = await this.prisma.customerUser.update({
      where: { id },
      data: updateUserDto,
    });

    // Log user update
    await this.userLogsService.create({
      userId: user.id,
      eventType: 'USER_UPDATED',
      eventCategory: 'USER',
      eventData: { fields: Object.keys(updateUserDto) },
      level: 'info',
    });

    return user;
  }

  async remove(id: string): Promise<CustomerUser> {
    const user = await this.prisma.customerUser.delete({
      where: { id },
    });

    // Note: Log will be deleted due to cascade, but we can create a log before deletion if needed

    return user;
  }
}
