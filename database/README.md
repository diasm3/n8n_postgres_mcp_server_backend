# Database (PostgreSQL 16)

## 📋 개요

중고나라 CS 민원 관리 시스템의 데이터베이스 설계 문서입니다. PostgreSQL 16을 사용하며, Prisma ORM을 통해 관리됩니다.

## 🗄️ 데이터베이스 스키마

### 전체 테이블 목록 (9개)

1. **customer_users** - 고객 사용자 정보
2. **customer_user_logs** - 고객 활동 로그
3. **internal_users** - 내부 직원 정보
4. **customer_complaints** - 고객 민원/컴플레인
5. **complaint_responses** - 민원 응답 이력
6. **complaint_history** - 민원 처리 이력
7. **complaint_templates** - 응답 템플릿
8. **complaint_sla_rules** - SLA 규칙
9. **complaint_knowledge_base** - 지식 베이스 (KB)

---

## 📊 테이블 상세

### 1. CustomerUser (customer_users)

**목적**: 고객 사용자 기본 정보 및 프로필 관리

| 필드명 | 타입 | 설명 | 비고 |
|--------|------|------|------|
| `id` | UUID | 고유 식별자 | Primary Key |
| `email` | String | 이메일 | Unique, Indexed |
| `password` | String | 비밀번호 (해시) | - |
| `firstName` | String | 이름 | - |
| `lastName` | String | 성 | - |
| `phoneNumber` | String? | 전화번호 | Optional |
| `birthDate` | Date? | 생년월일 | Optional |
| `role` | String | 역할 | Default: "customer" |
| `isActive` | Boolean | 활성화 여부 | Default: true |
| `profileImageUrl` | String? | 프로필 이미지 URL | Optional |
| `preferences` | JSON? | 사용자 설정 | 알림, 관심 카테고리, 언어 등 |
| `address` | JSON? | 주소 정보 | 도로명, 도시, 지역, 우편번호 |
| `loginCount` | Int | 로그인 횟수 | Default: 0 |
| `lastLoginAt` | DateTime? | 마지막 로그인 시각 | - |
| `lastLoginIp` | String? | 마지막 로그인 IP | - |
| `metadata` | JSON | 추가 메타데이터 | Default: {} |
| `createdAt` | DateTime | 생성 일시 | Auto |
| `updatedAt` | DateTime | 수정 일시 | Auto |

**Relations**:
- `logs` → CustomerUserLog[] (1:N)

**Indexes**:
- `email` (Unique Index)
- `role`

---

### 2. CustomerUserLog (customer_user_logs)

**목적**: 고객의 모든 활동 및 이벤트 로그 추적

| 필드명 | 타입 | 설명 | 비고 |
|--------|------|------|------|
| `id` | UUID | 고유 식별자 | Primary Key |
| `userId` | String | 사용자 ID | Foreign Key → CustomerUser |
| `eventType` | String | 이벤트 타입 | login, logout, page_view, etc. |
| `eventCategory` | String? | 이벤트 카테고리 | Optional |
| `eventData` | JSON? | 이벤트 상세 데이터 | - |
| `ipAddress` | String? | IP 주소 | - |
| `userAgent` | String? | User Agent | - |
| `deviceInfo` | JSON? | 디바이스 정보 | OS, 브라우저 등 |
| `location` | JSON? | 위치 정보 | 국가, 도시, 좌표 |
| `sessionId` | String? | 세션 ID | - |
| `referrer` | String? | Referrer URL | - |
| `currentUrl` | String? | 현재 URL | - |
| `responseTime` | Int? | 응답 시간 (ms) | - |
| `httpMethod` | String? | HTTP 메서드 | GET, POST, etc. |
| `statusCode` | Int? | HTTP 상태 코드 | 200, 404, etc. |
| `tags` | JSON | 태그 목록 | Default: [] |
| `level` | String | 로그 레벨 | debug, info, warning, error, critical |
| `createdAt` | DateTime | 생성 일시 | Auto |

**Relations**:
- `user` → CustomerUser (N:1)

**Indexes**:
- `(userId, createdAt)` (Composite Index)
- `(eventType, createdAt)` (Composite Index)

---

### 3. InternalUser (internal_users)

**목적**: 내부 CS 직원 및 관리자 정보 관리

| 필드명 | 타입 | 설명 | 비고 |
|--------|------|------|------|
| `id` | UUID | 고유 식별자 | Primary Key |
| `email` | String | 이메일 | Unique |
| `firstName` | String | 이름 | - |
| `lastName` | String | 성 | - |
| `password` | String | 비밀번호 (해시) | - |
| `phoneNumber` | String? | 전화번호 | Optional |
| **직무 정보** | | | |
| `department` | String | 부서 | CS 1팀, CS 2팀, 배송팀 등 |
| `position` | String | 직책 | 상담원, 선임, 팀장 등 |
| `employeeId` | String | 사번 | Unique |
| `role` | String | 역할 | agent, senior, manager, admin |
| **권한 및 레벨** | | | |
| `accessLevel` | Int | 접근 레벨 | 1(일반) ~ 4(임원) |
| `permissions` | JSON? | 권한 목록 | Default: [] |
| **CS 전문성** | | | |
| `specialties` | JSON? | 전문 분야 | 카테고리별 전문성 |
| `maxConcurrentTickets` | Int? | 최대 동시 처리 티켓 | Default: 5 |
| **근무 정보** | | | |
| `workSchedule` | JSON? | 근무 일정 | 요일, 시간대 등 |
| `isAvailable` | Boolean | 업무 가능 여부 | Default: true |
| `currentWorkload` | Int | 현재 업무량 | Default: 0 |
| **성과 지표** | | | |
| `totalTicketsHandled` | Int | 총 처리 티켓 수 | Default: 0 |
| `avgResolutionTime` | Int? | 평균 해결 시간 (분) | - |
| `satisfactionRating` | Decimal? | 만족도 평점 | 0.00 ~ 5.00 |
| **상태 정보** | | | |
| `status` | String | 상태 | active, inactive, on_leave |
| `lastActiveAt` | DateTime? | 마지막 활동 시각 | - |
| **메타데이터** | | | |
| `metadata` | JSON | 추가 메타데이터 | Default: {} |
| `createdAt` | DateTime | 생성 일시 | Auto |
| `updatedAt` | DateTime | 수정 일시 | Auto |

**Indexes**:
- `department`
- `role`
- `status`
- `isAvailable`
- `accessLevel`

---

### 4. CustomerComplaint (customer_complaints)

**목적**: 고객 민원/컴플레인 정보 관리

| 필드명 | 타입 | 설명 | 비고 |
|--------|------|------|------|
| `id` | UUID | 고유 식별자 | Primary Key |
| **티켓 정보** | | | |
| `ticketNumber` | String? | 티켓 번호 | Unique, Auto-generated |
| **고객 정보** | | | |
| `userId` | String? | 고객 ID | Optional (비회원 가능) |
| `customerName` | String | 고객 이름 | - |
| `customerEmail` | String | 고객 이메일 | - |
| `customerPhone` | String? | 고객 전화번호 | Optional |
| **문의 분류** | | | |
| `category` | String | 카테고리 | 가격정보, 상품정보, 배송구매 등 |
| `subCategory` | String? | 서브카테고리 | Optional |
| `priority` | String | 우선순위 | low, medium, high, urgent |
| `urgency` | String | 긴급도 | normal, urgent, critical |
| **내용** | | | |
| `subject` | String | 제목 | - |
| `description` | Text | 상세 설명 | - |
| `attachments` | JSON | 첨부파일 목록 | Default: [] |
| **상태 관리** | | | |
| `status` | String | 처리 상태 | 접수, 처리중, 해결, 종료 등 |
| `escalationLevel` | Int | 에스컬레이션 레벨 | 1 ~ 4 |
| `isEscalated` | Boolean | 에스컬레이션 여부 | Default: false |
| **처리 정보** | | | |
| `assignedTo` | String? | 담당자 ID | FK → InternalUser |
| `assignedTeam` | String? | 담당 팀 | CS 1팀, 배송팀 등 |
| `firstResponseAt` | DateTime? | 첫 응답 시각 | - |
| `resolvedAt` | DateTime? | 해결 시각 | - |
| `responseTime` | Int? | 응답 시간 (분) | - |
| `resolutionTime` | Int? | 해결 시간 (분) | - |
| **관련 정보** | | | |
| `relatedProductId` | String? | 관련 상품 ID | - |
| `relatedOrderId` | String? | 관련 주문 ID | - |
| `relatedSellerId` | String? | 관련 판매자 ID | - |
| `jiraTicketKey` | String? | JIRA 티켓 키 | 예: PROJ-123 |
| **보상/조치** | | | |
| `compensationType` | String? | 보상 유형 | 환불, 쿠폰, 교환 등 |
| `compensationAmount` | Int | 보상 금액 | Default: 0 |
| `compensationNote` | Text? | 보상 비고 | - |
| **고객 만족도** | | | |
| `satisfactionScore` | Int? | 만족도 점수 | 1 ~ 5 |
| `feedbackComment` | Text? | 피드백 코멘트 | - |
| **메타데이터** | | | |
| `tags` | JSON | 태그 목록 | Default: [] |
| `metadata` | JSON | 추가 메타데이터 | Default: {} |
| `createdAt` | DateTime | 생성 일시 | Auto |
| `updatedAt` | DateTime | 수정 일시 | Auto |

**Relations**:
- `responses` → ComplaintResponse[] (1:N)
- `history` → ComplaintHistory[] (1:N)

**Indexes**:
- `ticketNumber` (Unique)
- `userId`
- `category`
- `status`
- `priority`
- `assignedTo`
- `createdAt`
- `(status, priority)` (Composite Index)
- `(category, status)` (Composite Index)

---

### 5. ComplaintResponse (complaint_responses)

**목적**: 민원에 대한 응답 및 커뮤니케이션 이력

| 필드명 | 타입 | 설명 | 비고 |
|--------|------|------|------|
| `id` | UUID | 고유 식별자 | Primary Key |
| `complaintId` | UUID | 민원 ID | FK → CustomerComplaint |
| `responderId` | String? | 응답자 ID | FK → InternalUser |
| `responderType` | String | 응답자 타입 | agent, system, customer |
| `responseType` | String | 응답 타입 | reply, note, status_update |
| `content` | Text | 응답 내용 | - |
| `attachments` | JSON | 첨부파일 목록 | Default: [] |
| `isInternal` | Boolean | 내부 메모 여부 | Default: false |
| `isAutoResponse` | Boolean | 자동 응답 여부 | Default: false |
| `createdAt` | DateTime | 생성 일시 | Auto |

**Relations**:
- `complaint` → CustomerComplaint (N:1)

**Indexes**:
- `complaintId`
- `responderId`
- `createdAt`
- `(complaintId, createdAt)` (Composite Index)

---

### 6. ComplaintHistory (complaint_history)

**목적**: 민원 처리 과정의 모든 변경 이력 추적

| 필드명 | 타입 | 설명 | 비고 |
|--------|------|------|------|
| `id` | UUID | 고유 식별자 | Primary Key |
| `complaintId` | UUID | 민원 ID | FK → CustomerComplaint |
| `actorId` | String? | 액션 수행자 ID | FK → InternalUser |
| `action` | String | 액션 타입 | created, assigned, status_changed, etc. |
| `fromValue` | String? | 변경 전 값 | - |
| `toValue` | String? | 변경 후 값 | - |
| `note` | Text? | 비고 | - |
| `metadata` | JSON | 추가 메타데이터 | Default: {} |
| `createdAt` | DateTime | 생성 일시 | Auto |

**Relations**:
- `complaint` → CustomerComplaint (N:1)

**Indexes**:
- `complaintId`
- `actorId`
- `createdAt`
- `action`

---

### 7. ComplaintTemplate (complaint_templates)

**목적**: 자주 사용되는 응답 템플릿 관리

| 필드명 | 타입 | 설명 | 비고 |
|--------|------|------|------|
| `id` | UUID | 고유 식별자 | Primary Key |
| `category` | String? | 카테고리 | Optional |
| `subCategory` | String? | 서브카테고리 | Optional |
| `templateName` | String | 템플릿 이름 | - |
| `templateContent` | Text | 템플릿 내용 | 변수 포함 가능 |
| `variables` | JSON | 변수 목록 | Default: [] |
| `isActive` | Boolean | 활성화 여부 | Default: true |
| `usageCount` | Int | 사용 횟수 | Default: 0 |
| `createdBy` | String? | 생성자 ID | FK → InternalUser |
| `createdAt` | DateTime | 생성 일시 | Auto |
| `updatedAt` | DateTime | 수정 일시 | Auto |

**Indexes**:
- `category`
- `isActive`
- `usageCount`

---

### 8. ComplaintSlaRule (complaint_sla_rules)

**목적**: SLA(Service Level Agreement) 규칙 정의

| 필드명 | 타입 | 설명 | 비고 |
|--------|------|------|------|
| `id` | UUID | 고유 식별자 | Primary Key |
| `category` | String | 카테고리 | - |
| `priority` | String | 우선순위 | low, medium, high, urgent |
| `firstResponseTime` | Int | 첫 응답 시간 (분) | - |
| `resolutionTime` | Int | 해결 시간 (분) | - |
| `escalationTime` | Int? | 에스컬레이션 시간 (분) | Optional |
| `isActive` | Boolean | 활성화 여부 | Default: true |
| `createdAt` | DateTime | 생성 일시 | Auto |
| `updatedAt` | DateTime | 수정 일시 | Auto |

**Unique Constraint**:
- `(category, priority)` - 카테고리와 우선순위 조합은 유니크

**Indexes**:
- `(category, priority)` (Composite Unique Index)
- `isActive`

---

### 9. ComplaintKnowledgeBase (complaint_knowledge_base)

**목적**: FAQ 및 지식 베이스(KB) 관리

| 필드명 | 타입 | 설명 | 비고 |
|--------|------|------|------|
| `id` | UUID | 고유 식별자 | Primary Key |
| `category` | String | 카테고리 | - |
| `subCategory` | String? | 서브카테고리 | Optional |
| `question` | Text | 질문 | - |
| `answer` | Text | 답변 | - |
| `keywords` | JSON | 키워드 목록 | 검색용 |
| `relatedArticles` | JSON | 관련 문서 ID 목록 | Default: [] |
| `viewCount` | Int | 조회수 | Default: 0 |
| `helpfulCount` | Int | 도움됨 수 | Default: 0 |
| `notHelpfulCount` | Int | 도움 안됨 수 | Default: 0 |
| `isPublished` | Boolean | 공개 여부 | Default: true |
| `createdBy` | String? | 생성자 ID | FK → InternalUser |
| `createdAt` | DateTime | 생성 일시 | Auto |
| `updatedAt` | DateTime | 수정 일시 | Auto |

**Indexes**:
- `category`
- `isPublished`
- `viewCount`
- `helpfulCount`

---

## 🔄 테이블 간 관계 (ERD)

```
CustomerUser (1) ──────< (N) CustomerUserLog
                              (고객 활동 로그)

CustomerComplaint (1) ──────< (N) ComplaintResponse
    (민원)                         (응답 이력)

CustomerComplaint (1) ──────< (N) ComplaintHistory
    (민원)                         (변경 이력)

InternalUser (1) ──────< (N) CustomerComplaint
  (담당자)                    (배정된 민원)
```

---

## 🚀 개발 환경 설정

### 1. Prisma 마이그레이션

```bash
cd backend_junggo

# 마이그레이션 생성
npx prisma migrate dev --name migration_name

# 마이그레이션 적용
npx prisma migrate deploy

# 스키마 변경 후 클라이언트 재생성
npx prisma generate
```

### 2. 시드 데이터 생성

```bash
# 더미 데이터 생성
npx prisma db seed
```

### 3. Prisma Studio 실행

```bash
# 데이터베이스 GUI 관리 도구
npx prisma studio
```

브라우저에서 http://localhost:5555 접속

---

## 🐳 Docker 환경

### PostgreSQL 컨테이너

```bash
# PostgreSQL 컨테이너만 실행
docker compose up -d postgres

# 로그 확인
docker logs junggo_postgres -f

# 컨테이너 내부 접속
docker exec -it junggo_postgres psql -U junggo_user -d junggo_db
```

### pgAdmin 사용

```bash
# pgAdmin 실행
docker compose up -d pgadmin

# 접속: http://localhost:5050
# Email: admin@junggo.com
# Password: admin
```

---

## 📁 프로젝트 구조

```
database/
├── 📁 scripts/
│   ├── 📁 init/                   # 초기화 스크립트
│   │   └── 📄 01-init-databases.sql
│   ├── 📁 migrations/             # 마이그레이션 스크립트
│   │   └── 📄 02-create-cs-tables.sql
│   └── 📁 seeds/                  # 시드 데이터 스크립트
│       └── 📄 03-seed-dummy-data.sql
├── 📁 backups/                    # 데이터베이스 백업
│   └── 📄 full-dump.sql           # 전체 데이터 덤프 (310MB)
└── 📄 README.md                   # 이 문서
```

---

## 🔧 데이터베이스 백업 및 복원

### 백업

```bash
# 전체 데이터베이스 백업
docker exec junggo_postgres pg_dump -U junggo_user junggo_db > backup.sql

# 특정 테이블만 백업
docker exec junggo_postgres pg_dump -U junggo_user junggo_db -t customer_complaints > complaints_backup.sql

# 백업 파일을 database/backups/ 디렉토리에 저장
docker exec junggo_postgres pg_dump -U junggo_user junggo_db > database/backups/backup-$(date +%Y%m%d).sql
```

### 복원

```bash
# 백업 파일로 복원
docker exec -i junggo_postgres psql -U junggo_user junggo_db < backup.sql

# 특정 테이블만 복원
docker exec -i junggo_postgres psql -U junggo_user junggo_db < complaints_backup.sql
```

---

## 📊 주요 쿼리 예제

### 1. 카테고리별 민원 통계

```sql
SELECT
  category,
  status,
  COUNT(*) as count,
  AVG(resolution_time) as avg_resolution_time
FROM customer_complaints
GROUP BY category, status
ORDER BY count DESC;
```

### 2. 담당자별 성과 분석

```sql
SELECT
  iu.first_name || ' ' || iu.last_name as agent_name,
  iu.department,
  iu.total_tickets_handled,
  iu.avg_resolution_time,
  iu.satisfaction_rating
FROM internal_users iu
WHERE iu.role = 'agent'
ORDER BY iu.total_tickets_handled DESC
LIMIT 10;
```

### 3. 미해결 민원 현황

```sql
SELECT
  ticket_number,
  category,
  priority,
  status,
  customer_name,
  assigned_to,
  created_at,
  NOW() - created_at as pending_time
FROM customer_complaints
WHERE status IN ('접수', '처리중')
ORDER BY priority DESC, created_at ASC;
```

### 4. SLA 위반 민원 조회

```sql
SELECT
  cc.ticket_number,
  cc.category,
  cc.priority,
  cc.status,
  cc.created_at,
  sla.first_response_time,
  sla.resolution_time,
  EXTRACT(EPOCH FROM (NOW() - cc.created_at)) / 60 as elapsed_minutes
FROM customer_complaints cc
JOIN complaint_sla_rules sla
  ON cc.category = sla.category
  AND cc.priority = sla.priority
WHERE cc.status != '해결'
  AND (
    (cc.first_response_at IS NULL AND EXTRACT(EPOCH FROM (NOW() - cc.created_at)) / 60 > sla.first_response_time)
    OR (cc.resolved_at IS NULL AND EXTRACT(EPOCH FROM (NOW() - cc.created_at)) / 60 > sla.resolution_time)
  )
ORDER BY elapsed_minutes DESC;
```

---

## 🔧 트러블슈팅

### Prisma 관련 오류

**문제**: `Prisma Client is not generated`
```bash
# 해결: Prisma Client 재생성
npx prisma generate
```

**문제**: 마이그레이션 충돌
```bash
# 해결: 마이그레이션 리셋 (주의: 데이터 손실)
npx prisma migrate reset
```

### PostgreSQL 연결 오류

**문제**: `connection refused`
```bash
# 컨테이너 상태 확인
docker ps | grep postgres

# 컨테이너 재시작
docker compose restart postgres

# 로그 확인
docker logs junggo_postgres
```

**문제**: `too many connections`
```sql
-- 현재 연결 수 확인
SELECT count(*) FROM pg_stat_activity;

-- 최대 연결 수 확인
SHOW max_connections;

-- 불필요한 연결 종료
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE state = 'idle'
  AND state_change < NOW() - INTERVAL '5 minutes';
```

---

## 📚 관련 문서

- **[Backend API 문서](../backend_junggo/README.md)** - NestJS Backend 및 API 엔드포인트
- **[MCP Server 문서](../mcp_server_practice/README.md)** - AI 에이전트 통합
- **[Frontend 문서](../frontend/README.md)** - Next.js Frontend 애플리케이션
- **[Root README](../README.md)** - 프로젝트 전체 개요

---

## 📌 데이터베이스 접속 정보

| 항목 | 값 |
|------|-----|
| **Host** | localhost |
| **Port** | 5432 |
| **Database** | junggo_db |
| **Username** | junggo_user |
| **Password** | junggo_password |
| **Connection URL** | postgresql://junggo_user:junggo_password@localhost:5432/junggo_db |

---

**Last Updated**: 2025-10-06
