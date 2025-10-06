import { Test, TestingModule } from '@nestjs/testing';
import { InternalUsersController } from './internal-users.controller';

describe('InternalUsersController', () => {
  let controller: InternalUsersController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [InternalUsersController],
    }).compile();

    controller = module.get<InternalUsersController>(InternalUsersController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
