import { Test, TestingModule } from '@nestjs/testing';
import { InternalUsersService } from './internal-users.service';

describe('InternalUsersService', () => {
  let service: InternalUsersService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [InternalUsersService],
    }).compile();

    service = module.get<InternalUsersService>(InternalUsersService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
