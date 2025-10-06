import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsEmail,
  IsString,
  IsNotEmpty,
  IsOptional,
  IsInt,
  IsBoolean,
  IsObject,
  IsNumber,
  Min,
  Max,
} from 'class-validator';

export class CreateInternalUserDto {
  @ApiProperty({ example: 'cs1@junggo.com' })
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @ApiProperty({ example: '민지' })
  @IsString()
  @IsNotEmpty()
  firstName: string;

  @ApiProperty({ example: '김' })
  @IsString()
  @IsNotEmpty()
  lastName: string;

  @ApiProperty({ example: 'password123' })
  @IsString()
  @IsNotEmpty()
  password: string;

  @ApiPropertyOptional({ example: '010-1234-5678' })
  @IsOptional()
  @IsString()
  phoneNumber?: string;

  @ApiProperty({ example: 'CS', description: 'CS, DEVELOPMENT, PRODUCT, MANAGEMENT' })
  @IsString()
  @IsNotEmpty()
  department: string;

  @ApiProperty({ example: '주니어 상담원' })
  @IsString()
  @IsNotEmpty()
  position: string;

  @ApiProperty({ example: 'CS-0001' })
  @IsString()
  @IsNotEmpty()
  employeeId: string;

  @ApiProperty({ example: 'agent', description: 'agent, senior_agent, team_leader, developer, manager' })
  @IsString()
  @IsNotEmpty()
  role: string;

  @ApiPropertyOptional({ example: 1, minimum: 1, maximum: 5 })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(5)
  accessLevel?: number;

  @ApiPropertyOptional({ example: ['view_complaints', 'handle_complaints'] })
  @IsOptional()
  @IsObject()
  permissions?: any;

  @ApiPropertyOptional({ example: ['price_info', 'product_info'] })
  @IsOptional()
  @IsObject()
  specialties?: any;

  @ApiPropertyOptional({ example: 5 })
  @IsOptional()
  @IsInt()
  @Min(1)
  maxConcurrentTickets?: number;

  @ApiPropertyOptional({ example: { monday: '09:00-18:00', tuesday: '09:00-18:00' } })
  @IsOptional()
  @IsObject()
  workSchedule?: any;

  @ApiPropertyOptional({ example: true })
  @IsOptional()
  @IsBoolean()
  isAvailable?: boolean;

  @ApiPropertyOptional({ example: 'active', description: 'active, on_leave, busy, offline, inactive' })
  @IsOptional()
  @IsString()
  status?: string;

  @ApiPropertyOptional({ example: {} })
  @IsOptional()
  @IsObject()
  metadata?: any;
}
