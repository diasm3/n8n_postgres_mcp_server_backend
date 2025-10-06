import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateUserDto {
  @ApiPropertyOptional({ example: 'user@junggo.com', description: 'User email address' })
  email?: string;

  @ApiPropertyOptional({ example: 'newpassword123', description: 'User password' })
  password?: string;

  @ApiPropertyOptional({ example: 'John', description: 'User first name' })
  firstName?: string;

  @ApiPropertyOptional({ example: 'Doe', description: 'User last name' })
  lastName?: string;

  @ApiPropertyOptional({ example: '010-1234-5678', description: 'User phone number' })
  phoneNumber?: string;

  @ApiPropertyOptional({ example: '1990-01-01', description: 'User birth date' })
  birthDate?: Date;

  @ApiPropertyOptional({ example: 'admin', description: 'User role' })
  role?: string;

  @ApiPropertyOptional({ example: true, description: 'User active status' })
  isActive?: boolean;

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