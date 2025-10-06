import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Delete,
  Put,
  HttpException,
  HttpStatus,
  Query,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiParam, ApiQuery } from '@nestjs/swagger';
import { ComplaintsService } from './complaints.service';
import { CreateComplaintDto } from './dto/create-complaint.dto';
import { UpdateComplaintDto } from './dto/update-complaint.dto';

@ApiTags('complaints')
@Controller('complaints')
export class ComplaintsController {
  constructor(private readonly complaintsService: ComplaintsService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new complaint' })
  @ApiResponse({ status: 201, description: 'Complaint created successfully' })
  async create(@Body() createComplaintDto: CreateComplaintDto) {
    try {
      return await this.complaintsService.create(createComplaintDto);
    } catch (error) {
      throw new HttpException('Failed to create complaint', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @Get()
  @ApiOperation({ summary: 'Get all complaints with optional filters' })
  @ApiQuery({ name: 'category', required: false })
  @ApiQuery({ name: 'status', required: false })
  @ApiQuery({ name: 'priority', required: false })
  @ApiQuery({ name: 'assignedTo', required: false })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({ name: 'offset', required: false, type: Number })
  @ApiResponse({ status: 200, description: 'Return all complaints or filtered results' })
  async findAll(
    @Query('category') category?: string,
    @Query('status') status?: string,
    @Query('priority') priority?: string,
    @Query('assignedTo') assignedTo?: string,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    return await this.complaintsService.findAll({
      category,
      status,
      priority,
      assignedTo,
      limit: limit ? parseInt(limit) : undefined,
      offset: offset ? parseInt(offset) : undefined,
    });
  }

  @Get('stats')
  @ApiOperation({ summary: 'Get complaint statistics' })
  @ApiResponse({ status: 200, description: 'Return complaint statistics' })
  async getStats() {
    return await this.complaintsService.getStats();
  }

  @Get('pending')
  @ApiOperation({ summary: 'Get all pending complaints (not resolved or closed)' })
  @ApiResponse({ status: 200, description: 'Return pending complaints' })
  async findPending() {
    return await this.complaintsService.findPendingComplaints();
  }

  @Get('ticket/:ticketNumber')
  @ApiOperation({ summary: 'Get complaint by ticket number' })
  @ApiParam({ name: 'ticketNumber', description: 'Ticket number (e.g., CS-2025-01-00001)' })
  @ApiResponse({ status: 200, description: 'Return the complaint' })
  @ApiResponse({ status: 404, description: 'Complaint not found' })
  async findByTicketNumber(@Param('ticketNumber') ticketNumber: string) {
    const complaint = await this.complaintsService.findByTicketNumber(ticketNumber);
    if (!complaint) {
      throw new HttpException('Complaint not found', HttpStatus.NOT_FOUND);
    }
    return complaint;
  }

  @Get('user/:userId')
  @ApiOperation({ summary: 'Get complaints by user ID' })
  @ApiParam({ name: 'userId', description: 'User UUID' })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({ name: 'offset', required: false, type: Number })
  @ApiResponse({ status: 200, description: 'Return user complaints' })
  async findByUserId(
    @Param('userId') userId: string,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    return await this.complaintsService.findByUserId(userId, {
      limit: limit ? parseInt(limit) : undefined,
      offset: offset ? parseInt(offset) : undefined,
    });
  }

  @Get('category/:category')
  @ApiOperation({ summary: 'Get complaints by category' })
  @ApiParam({ name: 'category', description: '가격정보, 상품정보, 배송구매, etc.' })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({ name: 'offset', required: false, type: Number })
  @ApiResponse({ status: 200, description: 'Return complaints by category' })
  async findByCategory(
    @Param('category') category: string,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    return await this.complaintsService.findByCategory(category, {
      limit: limit ? parseInt(limit) : undefined,
      offset: offset ? parseInt(offset) : undefined,
    });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get complaint by ID' })
  @ApiParam({ name: 'id', description: 'Complaint UUID' })
  @ApiResponse({ status: 200, description: 'Return the complaint' })
  @ApiResponse({ status: 404, description: 'Complaint not found' })
  async findOne(@Param('id') id: string) {
    const complaint = await this.complaintsService.findOne(id);
    if (!complaint) {
      throw new HttpException('Complaint not found', HttpStatus.NOT_FOUND);
    }
    return complaint;
  }

  @Get(':id/responses')
  @ApiOperation({ summary: 'Get all responses for a complaint' })
  @ApiParam({ name: 'id', description: 'Complaint UUID' })
  @ApiResponse({ status: 200, description: 'Return complaint responses' })
  async getResponses(@Param('id') id: string) {
    return await this.complaintsService.getResponses(id);
  }

  @Post(':id/responses')
  @ApiOperation({ summary: 'Add a response to a complaint' })
  @ApiParam({ name: 'id', description: 'Complaint UUID' })
  @ApiResponse({ status: 201, description: 'Response added successfully' })
  async addResponse(@Param('id') id: string, @Body() responseData: any) {
    return await this.complaintsService.addResponse(id, responseData);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update complaint by ID' })
  @ApiParam({ name: 'id', description: 'Complaint UUID' })
  @ApiResponse({ status: 200, description: 'Complaint updated successfully' })
  @ApiResponse({ status: 404, description: 'Complaint not found' })
  async update(@Param('id') id: string, @Body() updateComplaintDto: UpdateComplaintDto) {
    try {
      return await this.complaintsService.update(id, updateComplaintDto);
    } catch (error) {
      if (error.code === 'P2025') {
        throw new HttpException('Complaint not found', HttpStatus.NOT_FOUND);
      }
      throw error;
    }
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete complaint by ID' })
  @ApiParam({ name: 'id', description: 'Complaint UUID' })
  @ApiResponse({ status: 200, description: 'Complaint deleted successfully' })
  @ApiResponse({ status: 404, description: 'Complaint not found' })
  async remove(@Param('id') id: string) {
    try {
      return await this.complaintsService.remove(id);
    } catch (error) {
      if (error.code === 'P2025') {
        throw new HttpException('Complaint not found', HttpStatus.NOT_FOUND);
      }
      throw error;
    }
  }
}
