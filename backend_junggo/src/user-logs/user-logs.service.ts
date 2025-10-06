import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateUserLogDto } from './dto/create-user-log.dto';
import { CustomerUserLog } from '@prisma/client';

@Injectable()
export class UserLogsService {
  constructor(private prisma: PrismaService) {}

  async create(createUserLogDto: CreateUserLogDto): Promise<CustomerUserLog> {
    return this.prisma.customerUserLog.create({
      data: {
        ...createUserLogDto,
        tags: createUserLogDto.tags || [],
        level: createUserLogDto.level || 'info',
      },
    });
  }

  async findAll(limit: number = 100, offset: number = 0): Promise<CustomerUserLog[]> {
    return this.prisma.customerUserLog.findMany({
      take: limit,
      skip: offset,
      orderBy: { createdAt: 'desc' },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
          },
        },
      },
    });
  }

  async findByUserId(
    userId: string,
    limit: number = 100,
    offset: number = 0,
  ): Promise<CustomerUserLog[]> {
    return this.prisma.customerUserLog.findMany({
      where: { userId },
      take: limit,
      skip: offset,
      orderBy: { createdAt: 'desc' },
    });
  }

  async findOne(id: string): Promise<CustomerUserLog | null> {
    return this.prisma.customerUserLog.findUnique({
      where: { id },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
          },
        },
      },
    });
  }

  async findByEventType(
    eventType: string,
    limit: number = 100,
    offset: number = 0,
  ): Promise<CustomerUserLog[]> {
    return this.prisma.customerUserLog.findMany({
      where: { eventType },
      take: limit,
      skip: offset,
      orderBy: { createdAt: 'desc' },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
          },
        },
      },
    });
  }

  async getStatsByUser(userId: string): Promise<any> {
    const logs = await this.prisma.customerUserLog.groupBy({
      by: ['eventType'],
      where: { userId },
      _count: {
        eventType: true,
      },
    });

    const totalLogs = await this.prisma.customerUserLog.count({
      where: { userId },
    });

    return {
      userId,
      totalLogs,
      eventTypes: logs.map(log => ({
        eventType: log.eventType,
        count: log._count.eventType,
      })),
    };
  }
}
