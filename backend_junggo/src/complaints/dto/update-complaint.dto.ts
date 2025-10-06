import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsOptional, IsInt, IsBoolean, IsObject, IsDateString } from 'class-validator';

export class UpdateComplaintDto {
  @ApiPropertyOptional({ example: '처리중' })
  @IsOptional()
  @IsString()
  status?: string;

  @ApiPropertyOptional({ example: 'high' })
  @IsOptional()
  @IsString()
  priority?: string;

  @ApiPropertyOptional({ example: 'urgent' })
  @IsOptional()
  @IsString()
  urgency?: string;

  @ApiPropertyOptional({ example: 'agent-user-id' })
  @IsOptional()
  @IsString()
  assignedTo?: string;

  @ApiPropertyOptional({ example: 'CS 1팀' })
  @IsOptional()
  @IsString()
  assignedTeam?: string;

  @ApiPropertyOptional({ example: 2 })
  @IsOptional()
  @IsInt()
  escalationLevel?: number;

  @ApiPropertyOptional({ example: true })
  @IsOptional()
  @IsBoolean()
  isEscalated?: boolean;

  @ApiPropertyOptional({ example: 'JIRA-123' })
  @IsOptional()
  @IsString()
  jiraTicketKey?: string;

  @ApiPropertyOptional({ example: '포인트지급' })
  @IsOptional()
  @IsString()
  compensationType?: string;

  @ApiPropertyOptional({ example: 5000 })
  @IsOptional()
  @IsInt()
  compensationAmount?: number;

  @ApiPropertyOptional({ example: '불편을 끼쳐 죄송합니다' })
  @IsOptional()
  @IsString()
  compensationNote?: string;

  @ApiPropertyOptional({ example: 5 })
  @IsOptional()
  @IsInt()
  satisfactionScore?: number;

  @ApiPropertyOptional({ example: '친절하게 응대해주셔서 감사합니다' })
  @IsOptional()
  @IsString()
  feedbackComment?: string;

  @ApiPropertyOptional({ example: [] })
  @IsOptional()
  @IsObject()
  tags?: any;

  @ApiPropertyOptional({ example: {} })
  @IsOptional()
  @IsObject()
  metadata?: any;
}
