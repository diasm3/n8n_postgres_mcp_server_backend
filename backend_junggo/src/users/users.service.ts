import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { User } from '@prisma/client';
import { UserLogsService } from '../user-logs/user-logs.service';

@Injectable()
export class UsersService {
  constructor(
    private prisma: PrismaService,
    private userLogsService: UserLogsService,
  ) {}

  async create(createUserDto: CreateUserDto): Promise<User> {
    const user = await this.prisma.user.create({
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

  async findAll(): Promise<User[]> {
    return this.prisma.user.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  async findOne(id: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { id },
    });
  }

  async update(id: string, updateUserDto: UpdateUserDto): Promise<User> {
    const user = await this.prisma.user.update({
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

  async remove(id: string): Promise<User> {
    const user = await this.prisma.user.delete({
      where: { id },
    });

    // Note: Log will be deleted due to cascade, but we can create a log before deletion if needed
    
    return user;
  }
}
