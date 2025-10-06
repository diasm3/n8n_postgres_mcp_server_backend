import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateUserLogDto {
  @ApiProperty({ example: '123e4567-e89b-12d3-a456-426614174000', description: 'User ID' })
  userId: string;

  @ApiProperty({ example: 'USER_LOGIN', description: 'Type of event' })
  eventType: string;

  @ApiPropertyOptional({ example: 'AUTH', description: 'Event category' })
  eventCategory?: string;

  @ApiPropertyOptional({ 
    example: { loginMethod: 'email', browser: 'Chrome' },
    description: 'Additional event data' 
  })
  eventData?: any;

  @ApiPropertyOptional({ example: '192.168.1.1', description: 'IP address' })
  ipAddress?: string;

  @ApiPropertyOptional({ example: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', description: 'User agent string' })
  userAgent?: string;

  @ApiPropertyOptional({ 
    example: { type: 'desktop', os: 'Windows', browser: 'Chrome' },
    description: 'Device information' 
  })
  deviceInfo?: any;

  @ApiPropertyOptional({ 
    example: { country: 'KR', city: 'Seoul', coordinates: { lat: 37.5665, lng: 126.9780 } },
    description: 'Location information' 
  })
  location?: any;

  @ApiPropertyOptional({ example: 'session-123456', description: 'Session ID' })
  sessionId?: string;

  @ApiPropertyOptional({ example: 'https://junggo.com', description: 'Referrer URL' })
  referrer?: string;

  @ApiPropertyOptional({ example: 'https://junggo.com/users/profile', description: 'Current URL' })
  currentUrl?: string;

  @ApiPropertyOptional({ example: 125, description: 'Response time in milliseconds' })
  responseTime?: number;

  @ApiPropertyOptional({ example: 'GET', description: 'HTTP method' })
  httpMethod?: string;

  @ApiPropertyOptional({ example: 200, description: 'HTTP status code' })
  statusCode?: number;

  @ApiPropertyOptional({ 
    example: ['authentication', 'web'],
    description: 'Tags for categorization' 
  })
  tags?: any;

  @ApiPropertyOptional({ example: 'info', description: 'Log level', enum: ['debug', 'info', 'warning', 'error', 'critical'] })
  level?: string;
}