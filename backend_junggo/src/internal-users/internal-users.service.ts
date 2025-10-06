import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateInternalUserDto } from './dto/create-internal-user.dto';
import { UpdateInternalUserDto } from './dto/update-internal-user.dto';
import { InternalUser } from '@prisma/client';

@Injectable()
export class InternalUsersService {
  constructor(private prisma: PrismaService) {}

  async create(createInternalUserDto: CreateInternalUserDto): Promise<InternalUser> {
    return this.prisma.internalUser.create({
      data: createInternalUserDto,
    });
  }

  async findAll(): Promise<InternalUser[]> {
    return this.prisma.internalUser.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  async findOne(id: string): Promise<InternalUser | null> {
    return this.prisma.internalUser.findUnique({
      where: { id },
    });
  }

  async findByEmployeeId(employeeId: string): Promise<InternalUser | null> {
    return this.prisma.internalUser.findUnique({
      where: { employeeId },
    });
  }

  async findByDepartment(department: string): Promise<InternalUser[]> {
    return this.prisma.internalUser.findMany({
      where: { department },
      orderBy: { createdAt: 'desc' },
    });
  }

  async findByRole(role: string): Promise<InternalUser[]> {
    return this.prisma.internalUser.findMany({
      where: { role },
      orderBy: { createdAt: 'desc' },
    });
  }

  async findAvailableAgents(): Promise<InternalUser[]> {
    return this.prisma.internalUser.findMany({
      where: {
        department: 'CS',
        status: 'active',
        isAvailable: true,
      },
      orderBy: { currentWorkload: 'asc' },
    });
  }

  async update(id: string, updateInternalUserDto: UpdateInternalUserDto): Promise<InternalUser> {
    return this.prisma.internalUser.update({
      where: { id },
      data: updateInternalUserDto,
    });
  }

  async remove(id: string): Promise<InternalUser> {
    return this.prisma.internalUser.delete({
      where: { id },
    });
  }
}
