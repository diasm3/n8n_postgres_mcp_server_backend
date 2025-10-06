import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateComplaintDto } from './dto/create-complaint.dto';
import { UpdateComplaintDto } from './dto/update-complaint.dto';
import { CustomerComplaint } from '@prisma/client';

@Injectable()
export class ComplaintsService {
  constructor(private prisma: PrismaService) {}

  async create(createComplaintDto: CreateComplaintDto): Promise<CustomerComplaint> {
    return this.prisma.customerComplaint.create({
      data: createComplaintDto,
      include: {
        responses: true,
        history: true,
      },
    });
  }

  async findAll(options?: {
    category?: string;
    status?: string;
    priority?: string;
    assignedTo?: string;
    limit?: number;
    offset?: number;
  }): Promise<CustomerComplaint[]> {
    const { category, status, priority, assignedTo, limit = 50, offset = 0 } = options || {};

    return this.prisma.customerComplaint.findMany({
      where: {
        ...(category && { category }),
        ...(status && { status }),
        ...(priority && { priority }),
        ...(assignedTo && { assignedTo }),
      },
      include: {
        responses: {
          orderBy: { createdAt: 'desc' },
          take: 5,
        },
        history: {
          orderBy: { createdAt: 'desc' },
          take: 10,
        },
      },
      orderBy: { createdAt: 'desc' },
      take: limit,
      skip: offset,
    });
  }

  async findOne(id: string): Promise<CustomerComplaint | null> {
    return this.prisma.customerComplaint.findUnique({
      where: { id },
      include: {
        responses: {
          orderBy: { createdAt: 'asc' },
        },
        history: {
          orderBy: { createdAt: 'desc' },
        },
      },
    });
  }

  async findByTicketNumber(ticketNumber: string): Promise<CustomerComplaint | null> {
    return this.prisma.customerComplaint.findUnique({
      where: { ticketNumber },
      include: {
        responses: {
          orderBy: { createdAt: 'asc' },
        },
        history: {
          orderBy: { createdAt: 'desc' },
        },
      },
    });
  }

  async findByUserId(userId: string, options?: { limit?: number; offset?: number }): Promise<CustomerComplaint[]> {
    const { limit = 50, offset = 0 } = options || {};

    return this.prisma.customerComplaint.findMany({
      where: { userId },
      include: {
        responses: {
          orderBy: { createdAt: 'desc' },
          take: 3,
        },
        history: false,
      },
      orderBy: { createdAt: 'desc' },
      take: limit,
      skip: offset,
    });
  }

  async findPendingComplaints(): Promise<CustomerComplaint[]> {
    return this.prisma.customerComplaint.findMany({
      where: {
        status: {
          notIn: ['해결완료', '종결'],
        },
      },
      include: {
        responses: false,
        history: false,
      },
      orderBy: [{ priority: 'desc' }, { createdAt: 'asc' }],
    });
  }

  async findByCategory(category: string, options?: { limit?: number; offset?: number }): Promise<CustomerComplaint[]> {
    const { limit = 50, offset = 0 } = options || {};

    return this.prisma.customerComplaint.findMany({
      where: { category },
      orderBy: { createdAt: 'desc' },
      take: limit,
      skip: offset,
    });
  }

  async getStats(): Promise<any> {
    const [total, byStatus, byCategory, byPriority] = await Promise.all([
      this.prisma.customerComplaint.count(),
      this.prisma.customerComplaint.groupBy({
        by: ['status'],
        _count: { id: true },
      }),
      this.prisma.customerComplaint.groupBy({
        by: ['category'],
        _count: { id: true },
      }),
      this.prisma.customerComplaint.groupBy({
        by: ['priority'],
        _count: { id: true },
      }),
    ]);

    return {
      total,
      byStatus,
      byCategory,
      byPriority,
    };
  }

  async update(id: string, updateComplaintDto: UpdateComplaintDto): Promise<CustomerComplaint> {
    return this.prisma.customerComplaint.update({
      where: { id },
      data: updateComplaintDto,
      include: {
        responses: true,
        history: true,
      },
    });
  }

  async remove(id: string): Promise<CustomerComplaint> {
    return this.prisma.customerComplaint.delete({
      where: { id },
    });
  }

  // Complaint Responses
  async addResponse(complaintId: string, responseData: any): Promise<any> {
    return this.prisma.complaintResponse.create({
      data: {
        complaintId,
        ...responseData,
      },
    });
  }

  async getResponses(complaintId: string): Promise<any[]> {
    return this.prisma.complaintResponse.findMany({
      where: { complaintId },
      orderBy: { createdAt: 'asc' },
    });
  }
}
