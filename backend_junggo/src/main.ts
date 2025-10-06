import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const config = new DocumentBuilder()
    .setTitle('Junggo Backend API')
    .setDescription('The Junggo backend API documentation')
    .setVersion('1.0')
    .addTag('users', 'User management endpoints')
    .addTag('user-logs', 'User activity logging endpoints')
    .build();
  // const document = SwaggerModule.createDocument(app, config);
  const documentFactory = () => SwaggerModule.createDocument(app, config);

  SwaggerModule.setup('api', app, documentFactory, {
    // JSON 문서 URL 커스터마이징 (기본값: 'api-json')
    jsonDocumentUrl: 'api/openapi.json',

    // YAML 문서 URL 커스터마이징 (기본값: 'api-yaml')
    yamlDocumentUrl: 'api/openapi.yaml',

    // 추가 옵션들
    customSiteTitle: 'API Documentation', // 페이지 타이틀
    customfavIcon: '/favicon.ico', // 파비콘

    // UI 표시 여부 (false로 하면 JSON/YAML만 노출)
    ui: true,

    // raw 정의 파일 제공 여부
    // true: JSON과 YAML 모두 제공 (기본값)
    // ['json']: JSON만 제공
    // ['yaml']: YAML만 제공
    // false: 둘 다 제공 안 함
    raw: true,
  });

  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
