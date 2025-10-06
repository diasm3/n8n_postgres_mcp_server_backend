import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Query,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiParam, ApiQuery } from '@nestjs/swagger';
import { UserLogsService } from './user-logs.service';
import { CreateUserLogDto } from './dto/create-user-log.dto';

@ApiTags('customer-user-logs')
@Controller('customer-user-logs')
export class UserLogsController {
  constructor(private readonly userLogsService: UserLogsService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new user log' })
  @ApiResponse({ status: 201, description: 'Log created successfully' })
  @ApiResponse({ status: 400, description: 'User not found' })
  async create(@Body() createUserLogDto: CreateUserLogDto) {
    try {
      return await this.userLogsService.create(createUserLogDto);
    } catch (error) {
      if (error.code === 'P2003') {
        throw new HttpException('User not found', HttpStatus.BAD_REQUEST);
      }
      throw error;
    }
  }

  @Get()
  @ApiOperation({ summary: 'Get all user logs' })
  @ApiQuery({ name: 'limit', required: false, description: 'Number of logs to return', example: 100 })
  @ApiQuery({ name: 'offset', required: false, description: 'Number of logs to skip', example: 0 })
  @ApiResponse({ status: 200, description: 'Return all logs' })
  async findAll(
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    const limitNum = limit ? parseInt(limit, 10) : 100;
    const offsetNum = offset ? parseInt(offset, 10) : 0;
    return await this.userLogsService.findAll(limitNum, offsetNum);
  }

  @Get('user/:userId')
  @ApiOperation({ summary: 'Get logs by user ID' })
  @ApiParam({ name: 'userId', description: 'User ID' })
  @ApiQuery({ name: 'limit', required: false, description: 'Number of logs to return', example: 100 })
  @ApiQuery({ name: 'offset', required: false, description: 'Number of logs to skip', example: 0 })
  @ApiResponse({ status: 200, description: 'Return user logs' })
  async findByUserId(
    @Param('userId') userId: string,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    const limitNum = limit ? parseInt(limit, 10) : 100;
    const offsetNum = offset ? parseInt(offset, 10) : 0;
    return await this.userLogsService.findByUserId(userId, limitNum, offsetNum);
  }

  @Get('user/:userId/stats')
  @ApiOperation({ summary: 'Get user log statistics' })
  @ApiParam({ name: 'userId', description: 'User ID' })
  @ApiResponse({ status: 200, description: 'Return user statistics' })
  async getUserStats(@Param('userId') userId: string) {
    return await this.userLogsService.getStatsByUser(userId);
  }

  @Get('event/:eventType')
  @ApiOperation({ summary: 'Get logs by event type' })
  @ApiParam({ name: 'eventType', description: 'Event type', example: 'USER_LOGIN' })
  @ApiQuery({ name: 'limit', required: false, description: 'Number of logs to return', example: 100 })
  @ApiQuery({ name: 'offset', required: false, description: 'Number of logs to skip', example: 0 })
  @ApiResponse({ status: 200, description: 'Return logs by event type' })
  async findByEventType(
    @Param('eventType') eventType: string,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    const limitNum = limit ? parseInt(limit, 10) : 100;
    const offsetNum = offset ? parseInt(offset, 10) : 0;
    return await this.userLogsService.findByEventType(
      eventType,
      limitNum,
      offsetNum,
    );
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get log by ID' })
  @ApiParam({ name: 'id', description: 'Log ID' })
  @ApiResponse({ status: 200, description: 'Return the log' })
  @ApiResponse({ status: 404, description: 'Log not found' })
  async findOne(@Param('id') id: string) {
    const log = await this.userLogsService.findOne(id);
    if (!log) {
      throw new HttpException('Log not found', HttpStatus.NOT_FOUND);
    }
    return log;
  }
}
