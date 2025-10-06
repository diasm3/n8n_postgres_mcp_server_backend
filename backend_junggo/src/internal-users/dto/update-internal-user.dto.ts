import { PartialType } from '@nestjs/swagger';
import { CreateInternalUserDto } from './create-internal-user.dto';

export class UpdateInternalUserDto extends PartialType(CreateInternalUserDto) {}
