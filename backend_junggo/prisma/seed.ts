import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import { faker } from '@faker-js/faker/locale/ko';

const prisma = new PrismaClient();

async function main() {
  console.log('Starting seed process...');

  // Clean existing data
  await prisma.customerUserLog.deleteMany();
  await prisma.customerUser.deleteMany();

  // Create admin user
  const adminUser = await prisma.customerUser.create({
    data: {
      email: 'admin@junggo.com',
      password: await bcrypt.hash('admin123!', 10),
      firstName: '관리자',
      lastName: '김',
      phoneNumber: '010-1234-5678',
      birthDate: new Date('1980-01-01'),
      role: 'admin',
      isActive: true,
      profileImageUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=admin',
      preferences: {
        notifications: { email: true, sms: true, push: true },
        categories: ['all'],
        language: 'ko'
      },
      address: {
        street: '강남대로 123',
        city: '서울시',
        state: '강남구',
        zipCode: '06234',
        country: 'KR'
      },
      loginCount: 150,
      lastLoginAt: new Date(),
      lastLoginIp: '192.168.1.1',
      metadata: { department: 'IT', level: 'super' }
    }
  });

  const users = [adminUser];

  // Create regular users
  for (let i = 0; i < 20; i++) {
    const firstName = faker.person.firstName();
    const lastName = faker.person.lastName();
    const role = faker.helpers.arrayElement(['customer', 'customer', 'customer', 'seller']);

    const user = await prisma.customerUser.create({
      data: {
        email: faker.internet.email({ firstName, lastName }).toLowerCase(),
        password: await bcrypt.hash('password123!', 10),
        firstName,
        lastName,
        phoneNumber: faker.phone.number({ style: 'national' }),
        birthDate: faker.date.birthdate({ min: 18, max: 65, mode: 'age' }),
        role,
        isActive: faker.datatype.boolean(0.9),
        profileImageUrl: `https://api.dicebear.com/7.x/avataaars/svg?seed=${firstName}${lastName}`,
        preferences: {
          notifications: {
            email: faker.datatype.boolean(),
            sms: faker.datatype.boolean(),
            push: faker.datatype.boolean()
          },
          categories: faker.helpers.arrayElements(
            ['전자제품', '의류', '식품', '도서', '가전', '화장품'],
            faker.number.int({ min: 1, max: 4 })
          ),
          language: faker.helpers.arrayElement(['ko', 'en'])
        },
        address: {
          street: faker.location.streetAddress(),
          city: faker.location.city(),
          state: faker.location.state(),
          zipCode: faker.location.zipCode(),
          country: 'KR'
        },
        loginCount: faker.number.int({ min: 0, max: 100 }),
        lastLoginAt: faker.date.recent({ days: 30 }),
        lastLoginIp: faker.internet.ipv4(),
        metadata: role === 'seller' ? {
          businessNumber: faker.string.numeric(10),
          storeName: faker.company.name(),
          rating: faker.number.float({ min: 3.5, max: 5, fractionDigits: 1 })
        } : {}
      }
    });

    users.push(user);
  }

  console.log(`Created ${users.length} dummy users`);

  // Create user logs
  const eventTypes = ['login', 'logout', 'page_view', 'search', 'add_to_cart', 'purchase', 'error', 'profile_update'];
  const pages = ['/home', '/products', '/cart', '/checkout', '/profile', '/orders', '/settings'];
  const products = ['노트북', '스마트폰', '태블릿', '이어폰', '키보드', '마우스', '모니터'];

  let totalLogs = 0;

  for (const user of users) {
    const logCount = faker.number.int({ min: 20, max: 100 });

    for (let i = 0; i < logCount; i++) {
      const eventType = faker.helpers.arrayElement(eventTypes);
      let eventData: any = {};
      let eventCategory = '';
      let level = 'info';

      switch (eventType) {
        case 'login':
        case 'logout':
          eventCategory = 'auth';
          eventData = { action: eventType, success: true };
          break;
        case 'page_view':
          eventCategory = 'navigation';
          eventData = {
            action: 'view',
            resource: faker.helpers.arrayElement(pages),
            duration: faker.number.int({ min: 1000, max: 60000 })
          };
          break;
        case 'search':
          eventCategory = 'user_action';
          eventData = {
            action: 'search',
            query: faker.helpers.arrayElement(products),
            resultCount: faker.number.int({ min: 0, max: 100 })
          };
          break;
        case 'add_to_cart':
          eventCategory = 'transaction';
          eventData = {
            action: 'add_to_cart',
            productId: faker.string.uuid(),
            productName: faker.helpers.arrayElement(products),
            price: faker.number.int({ min: 10000, max: 2000000 }),
            quantity: faker.number.int({ min: 1, max: 5 })
          };
          break;
        case 'purchase':
          eventCategory = 'transaction';
          eventData = {
            action: 'purchase',
            orderId: faker.string.uuid(),
            totalAmount: faker.number.int({ min: 10000, max: 5000000 }),
            itemCount: faker.number.int({ min: 1, max: 10 })
          };
          break;
        case 'error':
          eventCategory = 'system';
          level = 'error';
          eventData = {
            action: 'error',
            errorMessage: faker.helpers.arrayElement([
              'Network timeout',
              'Invalid input',
              'Server error',
              'Authentication failed'
            ]),
            errorStack: faker.lorem.lines(3)
          };
          break;
        case 'profile_update':
          eventCategory = 'user_action';
          eventData = {
            action: 'update',
            resource: 'profile',
            fields: faker.helpers.arrayElements(
              ['email', 'phone', 'address', 'preferences'],
              faker.number.int({ min: 1, max: 3 })
            )
          };
          break;
      }

      await prisma.customerUserLog.create({
        data: {
          userId: user.id,
          eventType,
          eventCategory,
          eventData,
          ipAddress: faker.internet.ipv4(),
          userAgent: faker.internet.userAgent(),
          deviceInfo: {
            type: faker.helpers.arrayElement(['mobile', 'tablet', 'desktop']),
            os: faker.helpers.arrayElement(['Windows', 'macOS', 'iOS', 'Android', 'Linux']),
            browser: faker.helpers.arrayElement(['Chrome', 'Safari', 'Firefox', 'Edge']),
            version: faker.system.semver()
          },
          location: {
            country: 'KR',
            city: faker.location.city(),
            region: faker.location.state(),
            latitude: faker.location.latitude({ min: 33, max: 38 }),
            longitude: faker.location.longitude({ min: 125, max: 130 })
          },
          sessionId: faker.string.uuid(),
          referrer: faker.helpers.arrayElement(['https://google.com', 'https://naver.com', 'direct', 'https://facebook.com']),
          currentUrl: `https://junggo.com${faker.helpers.arrayElement(pages)}`,
          responseTime: faker.number.int({ min: 50, max: 3000 }),
          httpMethod: faker.helpers.arrayElement(['GET', 'POST', 'PUT', 'DELETE']),
          statusCode: faker.helpers.weightedArrayElement([
            { weight: 70, value: 200 },
            { weight: 10, value: 201 },
            { weight: 5, value: 400 },
            { weight: 5, value: 401 },
            { weight: 5, value: 404 },
            { weight: 5, value: 500 }
          ]),
          tags: faker.helpers.arrayElements(['web', 'mobile', 'api', 'frontend', 'backend'], faker.number.int({ min: 1, max: 3 })),
          level,
          createdAt: faker.date.recent({ days: 90 })
        }
      });

      totalLogs++;
    }
  }

  console.log(`Created ${totalLogs} user logs for ${users.length} users`);
  console.log('Seed completed successfully!');
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error('Error during seeding:', e);
    await prisma.$disconnect();
    process.exit(1);
  });