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
import { InternalUsersService } from './internal-users.service';
import { CreateInternalUserDto } from './dto/create-internal-user.dto';
import { UpdateInternalUserDto } from './dto/update-internal-user.dto';

@ApiTags('internal-users')
@Controller('internal-users')
export class InternalUsersController {
  constructor(private readonly internalUsersService: InternalUsersService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new internal user (employee)' })
  @ApiResponse({ status: 201, description: 'Internal user created successfully' })
  @ApiResponse({ status: 409, description: 'User with this email or employee ID already exists' })
  async create(@Body() createInternalUserDto: CreateInternalUserDto) {
    try {
      return await this.internalUsersService.create(createInternalUserDto);
    } catch (error) {
      if (error.code === 'P2002') {
        throw new HttpException('User with this email or employee ID already exists', HttpStatus.CONFLICT);
      }
      throw error;
    }
  }

  @Get()
  @ApiOperation({ summary: 'Get all internal users or filter by department/role' })
  @ApiQuery({ name: 'department', required: false, description: 'Filter by department' })
  @ApiQuery({ name: 'role', required: false, description: 'Filter by role' })
  @ApiResponse({ status: 200, description: 'Return all internal users or filtered results' })
  async findAll(
    @Query('department') department?: string,
    @Query('role') role?: string,
  ) {
    if (department) {
      return await this.internalUsersService.findByDepartment(department);
    }
    if (role) {
      return await this.internalUsersService.findByRole(role);
    }
    return await this.internalUsersService.findAll();
  }

  @Get('available-agents')
  @ApiOperation({ summary: 'Get all available CS agents (sorted by workload)' })
  @ApiResponse({ status: 200, description: 'Return available CS agents' })
  async findAvailableAgents() {
    return await this.internalUsersService.findAvailableAgents();
  }

  @Get('employee/:employeeId')
  @ApiOperation({ summary: 'Get internal user by employee ID' })
  @ApiParam({ name: 'employeeId', description: 'Employee ID (e.g., CS-0001, DEV-0001)' })
  @ApiResponse({ status: 200, description: 'Return the internal user' })
  @ApiResponse({ status: 404, description: 'Internal user not found' })
  async findByEmployeeId(@Param('employeeId') employeeId: string) {
    const user = await this.internalUsersService.findByEmployeeId(employeeId);
    if (!user) {
      throw new HttpException('Internal user not found', HttpStatus.NOT_FOUND);
    }
    return user;
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get internal user by ID' })
  @ApiParam({ name: 'id', description: 'Internal user UUID' })
  @ApiResponse({ status: 200, description: 'Return the internal user' })
  @ApiResponse({ status: 404, description: 'Internal user not found' })
  async findOne(@Param('id') id: string) {
    const user = await this.internalUsersService.findOne(id);
    if (!user) {
      throw new HttpException('Internal user not found', HttpStatus.NOT_FOUND);
    }
    return user;
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update internal user by ID' })
  @ApiParam({ name: 'id', description: 'Internal user UUID' })
  @ApiResponse({ status: 200, description: 'Internal user updated successfully' })
  @ApiResponse({ status: 404, description: 'Internal user not found' })
  async update(@Param('id') id: string, @Body() updateInternalUserDto: UpdateInternalUserDto) {
    try {
      return await this.internalUsersService.update(id, updateInternalUserDto);
    } catch (error) {
      if (error.code === 'P2025') {
        throw new HttpException('Internal user not found', HttpStatus.NOT_FOUND);
      }
      throw error;
    }
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete internal user by ID' })
  @ApiParam({ name: 'id', description: 'Internal user UUID' })
  @ApiResponse({ status: 200, description: 'Internal user deleted successfully' })
  @ApiResponse({ status: 404, description: 'Internal user not found' })
  async remove(@Param('id') id: string) {
    try {
      return await this.internalUsersService.remove(id);
    } catch (error) {
      if (error.code === 'P2025') {
        throw new HttpException('Internal user not found', HttpStatus.NOT_FOUND);
      }
      throw error;
    }
  }
}
