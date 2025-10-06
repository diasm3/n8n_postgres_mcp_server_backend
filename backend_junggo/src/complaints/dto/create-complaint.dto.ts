import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsEmail,
  IsInt,
  IsBoolean,
  IsObject,
  Min,
  Max,
} from 'class-validator';

export class CreateComplaintDto {
  @ApiPropertyOptional({ example: 'user-uuid' })
  @IsOptional()
  @IsString()
  userId?: string;

  @ApiProperty({ example: '홍길동' })
  @IsString()
  @IsNotEmpty()
  customerName: string;

  @ApiProperty({ example: 'customer@example.com' })
  @IsEmail()
  @IsNotEmpty()
  customerEmail: string;

  @ApiPropertyOptional({ example: '010-1234-5678' })
  @IsOptional()
  @IsString()
  customerPhone?: string;

  @ApiProperty({ example: '가격정보', description: '가격정보, 상품정보, 배송구매, 리뷰평점, 회원개인정보, 시스템기술' })
  @IsString()
  @IsNotEmpty()
  category: string;

  @ApiPropertyOptional({ example: '가격 오류' })
  @IsOptional()
  @IsString()
  subCategory?: string;

  @ApiPropertyOptional({ example: 'medium', description: 'high, medium, low' })
  @IsOptional()
  @IsString()
  priority?: string;

  @ApiPropertyOptional({ example: 'normal', description: 'urgent, normal, low' })
  @IsOptional()
  @IsString()
  urgency?: string;

  @ApiProperty({ example: '상품 가격이 잘못 표시되어 있습니다' })
  @IsString()
  @IsNotEmpty()
  subject: string;

  @ApiProperty({ example: '상품 A의 가격이 실제와 다르게 표시되고 있습니다. 확인 부탁드립니다.' })
  @IsString()
  @IsNotEmpty()
  description: string;

  @ApiPropertyOptional({ example: [] })
  @IsOptional()
  @IsObject()
  attachments?: any;

  @ApiPropertyOptional({ example: '접수' })
  @IsOptional()
  @IsString()
  status?: string;

  @ApiPropertyOptional({ example: 'product-123' })
  @IsOptional()
  @IsString()
  relatedProductId?: string;

  @ApiPropertyOptional({ example: 'order-456' })
  @IsOptional()
  @IsString()
  relatedOrderId?: string;

  @ApiPropertyOptional({ example: 'seller-789' })
  @IsOptional()
  @IsString()
  relatedSellerId?: string;

  @ApiPropertyOptional({ example: [] })
  @IsOptional()
  @IsObject()
  tags?: any;

  @ApiPropertyOptional({ example: {} })
  @IsOptional()
  @IsObject()
  metadata?: any;
}
