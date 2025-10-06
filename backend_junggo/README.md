# Backend API (NestJS)

중고나라 CS 민원 관리 시스템의 백엔드 API 서버입니다.

## 📋 기술 스택

- **Framework**: NestJS
- **ORM**: Prisma
- **Database**: PostgreSQL 16
- **Language**: TypeScript
- **Documentation**: Swagger/OpenAPI

## 🚀 주요 기능

### API 엔드포인트

#### Customer Users API (고객 관리)
- `GET /customer-users` - 모든 고객 사용자 조회
- `POST /customer-users` - 새 고객 사용자 생성
- `GET /customer-users/:id` - 특정 고객 사용자 조회
- `PUT /customer-users/:id` - 고객 사용자 정보 수정
- `DELETE /customer-users/:id` - 고객 사용자 삭제

#### Customer User Logs API (고객 로그)
- `GET /customer-user-logs` - 모든 로그 조회
- `POST /customer-user-logs` - 로그 생성
- `GET /customer-user-logs/user/:userId` - 특정 사용자 로그 조회
- `GET /customer-user-logs/user/:userId/stats` - 사용자 로그 통계
- `GET /customer-user-logs/event/:eventType` - 이벤트 타입별 로그 조회

#### Internal Users API (직원 관리)
- `GET /internal-users` - 모든 직원 조회
- `POST /internal-users` - 새 직원 생성
- `GET /internal-users/:id` - 특정 직원 조회
- `GET /internal-users/employee/:employeeId` - 사번으로 조회
- `GET /internal-users/available-agents` - 배정 가능한 상담원 조회
- `PUT /internal-users/:id` - 직원 정보 수정
- `DELETE /internal-users/:id` - 직원 삭제

#### Complaints API (민원 관리)
- `GET /complaints` - 모든 민원 조회
- `POST /complaints` - 새 민원 생성
- `GET /complaints/:id` - 특정 민원 조회
- `GET /complaints/ticket/:ticketNumber` - 티켓 번호로 조회
- `GET /complaints/user/:userId` - 사용자별 민원 조회
- `GET /complaints/category/:category` - 카테고리별 민원 조회
- `GET /complaints/pending` - 대기 중인 민원 조회
- `GET /complaints/stats` - 민원 통계
- `GET /complaints/:id/responses` - 민원 응답 조회
- `PUT /complaints/:id` - 민원 정보 수정 (담당자 배정, JIRA 티켓, 상태 등)
- `DELETE /complaints/:id` - 민원 삭제

## 🛠️ 개발 환경

### 로컬 개발

```bash
cd backend_junggo

# 의존성 설치
yarn install

# Prisma 클라이언트 생성
yarn prisma generate

# 마이그레이션 실행
yarn prisma migrate dev

# 시드 데이터 생성
yarn prisma db seed

# 개발 서버 실행
yarn start:dev

# 프로덕션 빌드
yarn build

# 프로덕션 서버 실행
yarn start:prod
```

### 환경 변수

`.env` 파일:

```bash
DATABASE_URL="postgresql://junggo_user:junggo_password@localhost:5432/junggo_db"
PORT=3000
```

### Docker로 실행

```bash
# Backend 컨테이너만 빌드 및 시작
docker compose up -d backend

# Backend 로그 확인
docker logs junggo_backend -f

# Backend 재시작
docker compose restart backend
```

## 📁 프로젝트 구조

```
backend_junggo/
├── 📁 src/
│   ├── 📁 users/                  # 고객 사용자 관리 모듈
│   ├── 📁 user-logs/              # 고객 사용자 로그 모듈
│   ├── 📁 internal-users/         # 직원 관리 모듈
│   ├── 📁 complaints/             # 민원 관리 모듈
│   ├── 📁 prisma/                 # Prisma 서비스
│   ├── 📄 main.ts                 # 애플리케이션 엔트리
│   ├── 📄 app.module.ts           # 루트 모듈
│   └── 📄 app.controller.ts       # 루트 컨트롤러
├── 📁 prisma/
│   ├── 📁 migrations/             # Prisma 마이그레이션
│   ├── 📄 schema.prisma           # 데이터베이스 스키마
│   └── 📄 seed.ts                 # 시드 데이터
├── 📁 test/                       # E2E 테스트
├── 📄 Dockerfile                   # Docker 이미지 설정
├── 📄 package.json                 # 의존성 관리
├── 📄 tsconfig.json                # TypeScript 설정
└── 📄 .env.example                 # 환경변수 템플릿
```

## 🗄️ 데이터베이스 스키마

### 주요 테이블

#### CustomerUsers (고객)
- 기본 정보: id, email, password, firstName, lastName
- 추가 정보: phoneNumber, birthDate, role, profileImageUrl
- 설정: preferences (알림 설정, 관심 카테고리, 언어)
- 주소: address (도로명, 도시, 지역, 우편번호)
- 로그인 정보: loginCount, lastLoginAt, lastLoginIp

#### InternalUsers (직원)
- 기본 정보: id, email, firstName, lastName, password, phoneNumber
- 직무 정보: department, position, employeeId, role
- 권한 및 레벨: accessLevel, permissions
- CS 전문성: specialties, maxConcurrentTickets
- 근무 정보: workSchedule, isAvailable, currentWorkload
- 성과 지표: totalTicketsHandled, avgResolutionTime, satisfactionRating

#### CustomerComplaints (민원)
- 티켓 정보: id, ticketNumber
- 고객 정보: userId, customerName, customerEmail, customerPhone
- 문의 분류: category, subCategory, priority, urgency
- 내용: subject, description, attachments
- 상태 관리: status, escalationLevel, isEscalated
- 처리 정보: assignedTo, assignedTeam, firstResponseAt, resolvedAt
- 관련 정보: relatedProductId, relatedOrderId, relatedSellerId, jiraTicketKey
- 보상/조치: compensationType, compensationAmount, compensationNote
- 고객 만족도: satisfactionScore, feedbackComment

#### ComplaintResponses (민원 응답)
- 기본 정보: id, complaintId, responderId, responderType
- 응답 내용: responseType, content, attachments
- 플래그: isInternal, isAutoResponse

#### ComplaintHistory (민원 이력)
- 기본 정보: id, complaintId, actorId
- 변경 내역: action, fromValue, toValue, note

## 📡 API 문서

### Swagger UI

서버 실행 후 다음 URL에서 API 문서를 확인할 수 있습니다:

- **로컬**: http://localhost:3000/api
- **Docker**: http://localhost:3003/api

### CORS 설정

다음 Origin이 허용되어 있습니다:
- `http://localhost:3002` (Frontend)
- `http://127.0.0.1:3002`
- `http://localhost:3000`

### 민원 생성 예제

```bash
curl -X POST http://localhost:3003/complaints \
  -H "Content-Type: application/json" \
  -d '{
    "customerName": "홍길동",
    "customerEmail": "hong@example.com",
    "customerPhone": "010-1234-5678",
    "category": "배송구매",
    "subject": "배송이 지연되고 있습니다",
    "description": "주문한 상품이 일주일째 배송 중입니다...",
    "priority": "medium",
    "urgency": "normal",
    "relatedProductId": "PROD-ABC123",
    "relatedOrderId": "ORD-XYZ789"
  }'
```

## 🔧 Prisma 관리

### 마이그레이션

```bash
# 새 마이그레이션 생성
yarn prisma migrate dev --name migration_name

# 마이그레이션 적용
yarn prisma migrate deploy

# 마이그레이션 상태 확인
yarn prisma migrate status

# 마이그레이션 리셋 (주의: 모든 데이터 삭제)
yarn prisma migrate reset
```

### Prisma Studio

```bash
# Prisma Studio 실행 (DB GUI)
yarn prisma studio
```

브라우저에서 http://localhost:5555 접속

### 시드 데이터

```bash
# 시드 데이터 생성
yarn prisma db seed
```

50개 이상의 더미 데이터가 생성됩니다:
- 고객 사용자
- 직원
- 민원
- 민원 응답
- 민원 이력

## 🔍 테스트

```bash
# 단위 테스트
yarn test

# E2E 테스트
yarn test:e2e

# 테스트 커버리지
yarn test:cov
```

## 🐳 Docker 배포

### Dockerfile

Multi-stage 빌드를 사용하여 최적화된 이미지 생성:

```dockerfile
# 빌드 스테이지
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN yarn install
COPY . .
RUN yarn prisma generate
RUN yarn build

# 프로덕션 스테이지
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/prisma ./prisma
CMD ["node", "dist/main"]
```

### 포트 설정

- **내부 포트**: 3000 (컨테이너 내부)
- **외부 포트**: 3003 (호스트 머신)

## 🔧 트러블슈팅

### Prisma 클라이언트 생성 실패

```bash
# Prisma 클라이언트 재생성
yarn prisma generate

# node_modules 삭제 후 재설치
rm -rf node_modules
yarn install
```

### 마이그레이션 충돌

```bash
# 마이그레이션 상태 확인
yarn prisma migrate status

# 문제가 있는 마이그레이션 해결
yarn prisma migrate resolve --applied "migration_name"
# 또는
yarn prisma migrate resolve --rolled-back "migration_name"
```

### 데이터베이스 연결 실패

```bash
# PostgreSQL 컨테이너 상태 확인
docker ps | grep postgres

# 데이터베이스 로그 확인
docker logs junggo_postgres

# 연결 테스트
docker exec junggo_postgres psql -U junggo_user -d junggo_db -c "SELECT 1"
```

### 포트 충돌

```bash
# 포트 사용 확인
lsof -i :3000

# 프로세스 종료
kill -9 <PID>
```

## 📚 관련 문서

- [Root README](../README.md) - 전체 프로젝트 개요
- [Frontend README](../frontend/README.md) - Frontend 문서
- [MCP Server README](../mcp_server_practice/README.md) - MCP Server 문서
- [Database README](../database/README.md) - 데이터베이스 문서
- [Prisma Schema](./prisma/schema.prisma) - 데이터베이스 스키마
