import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateUserDto {
  @ApiProperty({ example: 'user@junggo.com', description: 'User email address' })
  email: string;

  @ApiProperty({ example: 'password123', description: 'User password' })
  password: string;

  @ApiProperty({ example: 'John', description: 'User first name' })
  firstName: string;

  @ApiProperty({ example: 'Doe', description: 'User last name' })
  lastName: string;

  @ApiPropertyOptional({ example: '010-1234-5678', description: 'User phone number' })
  phoneNumber?: string;

  @ApiPropertyOptional({ example: '1990-01-01', description: 'User birth date' })
  birthDate?: Date;

  @ApiPropertyOptional({ example: 'user', description: 'User role', default: 'user' })
  role?: string;

  @ApiPropertyOptional({ example: 'https://example.com/profile.jpg', description: 'Profile image URL' })
  profileImageUrl?: string;

  @ApiPropertyOptional({ 
    example: { notifications: true, categories: ['electronics', 'computers'], language: 'ko' },
    description: 'User preferences' 
  })
  preferences?: any;

  @ApiPropertyOptional({ 
    example: { street: '강남대로 123', city: '서울', state: '서울특별시', postalCode: '06234' },
    description: 'User address' 
  })
  address?: any;
}