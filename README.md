# 중고나라 백엔드 시스템 및 고객 대응 플로우

## 📋 프로젝트 개요

이 프로젝트는 중고나라의 백엔드 시스템과 고객 컴플레인 대응 체계를 구축하는 것을 목표로 합니다.

### 주요 구성 요소

- **Backend API Server** (NestJS + Prisma + PostgreSQL)
- **n8n Workflow Automation** (MCP 서버 연동)
- **고객 컴플레인 대응 시스템**
- **JIRA 연동 티켓 관리**

## 🏗️ 시스템 아키텍처

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Frontend      │────▶│  Backend API    │────▶│   PostgreSQL    │
│   (Customer)    │     │   (NestJS)      │     │   Database      │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                               │                          │
                               ▼                          │
                        ┌─────────────────┐              │
                        │      n8n        │              │
                        │   Workflow      │◀─────────────┘
                        └─────────────────┘
                               │
                               ▼
                        ┌─────────────────┐
                        │   MCP Server    │
                        │  (AI Assistant) │
                        └─────────────────┘
```

## 🚀 시작하기

### 1. 환경 설정

```bash
# 프로젝트 클론
git clone [repository-url]
cd backend-setup

# 환경 변수 설정
cp backend_junggo/.env.example backend_junggo/.env
```

### 2. Docker 컨테이너 실행

```bash
# 모든 서비스 시작
docker-compose up -d

# 개별 서비스 시작
docker-compose up -d postgres    # PostgreSQL
docker-compose up -d pgadmin     # pgAdmin
docker-compose up -d n8n         # n8n
docker-compose up -d backend     # Backend API
```

### 3. 서비스 접속 정보

| 서비스          | URL                   | 인증 정보                     |
| --------------- | --------------------- | ----------------------------- |
| Backend API     | http://localhost:3003 | -                             |
| n8n             | http://localhost:5680 | admin / admin                 |
| pgAdmin         | http://localhost:5050 | admin@junggo.com / admin      |
| PostgreSQL      | localhost:5432        | junggo_user / junggo_password |
| ngrok Dashboard | http://localhost:4040 | -                             |

### 4. ngrok HTTPS 터널 설정

ngrok을 사용하여 로컬 n8n을 외부에서 HTTPS로 접근할 수 있습니다.

#### ngrok 설정 방법

1. **환경 변수 설정**

   ```bash
   # .env 파일에서 ngrok authtoken 설정
   NGROK_AUTHTOKEN=your_ngrok_authtoken_here
   ```

   authtoken은 [ngrok 대시보드](https://dashboard.ngrok.com/get-started/your-authtoken)에서 확인할 수 있습니다.

2. **Docker Compose 실행**

   ```bash
   docker-compose up -d ngrok
   ```

3. **HTTPS URL 확인**

   ngrok이 생성한 HTTPS URL을 확인하는 방법:

   **방법 1: 웹 인터페이스 (추천)**

   - 브라우저에서 http://localhost:4040 접속
   - "Tunnels" 섹션에서 HTTPS URL 확인 (예: https://abc123.ngrok.io)

   **방법 2: API 호출**

   ```bash
   curl http://localhost:4040/api/tunnels | jq '.tunnels[0].public_url'
   ```

   **방법 3: Docker 로그**

   ```bash
   docker logs junggo_ngrok
   ```

4. **n8n Webhook URL 업데이트**

   ngrok URL을 확인한 후 `.env` 파일 수정:

   ```bash
   # .env
   N8N_WEBHOOK_URL=https://abc123.ngrok.io
   ```

   그리고 n8n 컨테이너 재시작:

   ```bash
   docker-compose restart n8n
   ```

#### ngrok 설정 파일

`ngrok.yml` 파일 구조:

```yaml
version: "2"
tunnels:
  n8n:
    addr: n8n:56780 # n8n  docker 내부
    proto: http
    schemes:
      - https # HTTPS만 활성화
```

#### 주의사항

- **무료 플랜 제한**: ngrok 무료 플랜은 동시에 1개의 터널만 사용 가능합니다.
- **URL 변경**: ngrok을 재시작할 때마다 URL이 변경됩니다. 고정 URL이 필요한 경우 유료 플랜을 사용하세요.
- **보안**: authtoken은 `.env` 파일에 저장하고 절대 Git에 커밋하지 마세요.

#### 트러블슈팅

1. **ERR_NGROK_105 (인증 실패)**

   - `.env` 파일의 `NGROK_AUTHTOKEN` 값 확인
   - [ngrok 대시보드](https://dashboard.ngrok.com/get-started/your-authtoken)에서 올바른 토큰 확인

2. **터널이 생성되지 않음**

   - n8n 컨테이너가 실행 중인지 확인: `docker ps | grep n8n`
   - ngrok 로그 확인: `docker logs junggo_ngrok`

3. **Webhook이 작동하지 않음**
   - n8n의 `N8N_WEBHOOK_URL` 환경변수가 ngrok URL로 설정되었는지 확인
   - n8n 워크플로우에서 Webhook URL이 올바른지 확인

## 📡 API 엔드포인트

### Users API

- `GET /users` - 모든 사용자 조회
- `POST /users` - 새 사용자 생성
- `GET /users/:id` - 특정 사용자 조회
- `PUT /users/:id` - 사용자 정보 수정
- `DELETE /users/:id` - 사용자 삭제

### User Logs API

- `GET /user-logs` - 모든 로그 조회
- `POST /user-logs` - 로그 생성
- `GET /user-logs/user/:userId` - 특정 사용자 로그 조회
- `GET /user-logs/user/:userId/stats` - 사용자 로그 통계
- `GET /user-logs/event/:eventType` - 이벤트 타입별 로그 조회

## 🔄 고객 대응 플로우

### 1. 컴플레인 접수 및 분류

```
고객 문의 접수
    ↓
문의 유형 분류
    ├─ 가격 정보
    ├─ 상품 정보
    ├─ 배송/구매
    ├─ 리뷰/평점
    ├─ 회원/개인정보
    └─ 시스템/기술
```

### 2. 대응 프로세스

```
문의 접수 → 지침서 확인
                ├─ 있음 → 지침서 따라 처리 → 고객 응대 → 처리 완료
                └─ 없음 → JIRA 티켓 생성 → 개발팀 검토 → 신규 지침 추가
```

### 3. 에스컬레이션 단계

1. **Level 1**: 일반 상담원 (지침서 내 해결)
2. **Level 2**: 선임 상담원 (복잡한 문의)
3. **Level 3**: 팀장/매니저 (법적 이슈)
4. **Level 4**: 임원 보고 (중대 사안)

## 📚 문서

### 고객 대응 지침서

- [`customer-complaint-guideline.md`](./customer-complaint-guideline.md) - 상세 대응 지침
- [`complaint-response-templates.md`](./complaint-response-templates.md) - 응대 템플릿

### 개발 문서

- API 명세서 (작성 예정)
- 데이터베이스 스키마 문서 (작성 예정)

## 🔧 개발 환경

### Backend

- **Framework**: NestJS
- **ORM**: Prisma
- **Database**: PostgreSQL 16
- **Language**: TypeScript

### Workflow Automation

- **Platform**: n8n
- **Integration**: MCP Server, JIRA API

## 🗂️ 프로젝트 구조

```
n8n_with_mcp_server_example/
├── 📄 docker-compose.yml              # Docker Compose 설정
├── 📄 ngrok.yml                        # ngrok 터널 설정
├── 📄 .env                             # 환경 변수 (Git 제외)
├── 📄 .env.example                     # 환경 변수 템플릿
├── 📄 .gitignore                       # Git 제외 파일 목록
├── 📄 README.md                        # 프로젝트 문서
│
├── 📁 backend_junggo/                  # NestJS Backend 애플리케이션
│   ├── 📁 src/
│   │   ├── 📁 users/                  # 사용자 관리 모듈
│   │   ├── 📁 user-logs/              # 사용자 로그 모듈
│   │   ├── 📁 prisma/                 # Prisma 서비스
│   │   ├── 📄 main.ts                 # 애플리케이션 엔트리
│   │   ├── 📄 app.module.ts           # 루트 모듈
│   │   └── 📄 app.controller.ts       # 루트 컨트롤러
│   ├── 📁 prisma/
│   │   ├── 📁 migrations/             # Prisma 마이그레이션
│   │   ├── 📄 schema.prisma           # 데이터베이스 스키마
│   │   └── 📄 seed.ts                 # 시드 데이터
│   ├── 📁 test/                       # E2E 테스트
│   ├── 📄 Dockerfile                   # Backend 도커 이미지
│   ├── 📄 package.json                 # 의존성 관리
│   ├── 📄 tsconfig.json                # TypeScript 설정
│   └── 📄 .env.example                 # Backend 환경변수 템플릿
│
├── 📁 database/                        # 데이터베이스 관련 파일
│   ├── 📁 scripts/
│   │   ├── 📁 init/                   # 초기화 스크립트
│   │   │   └── 📄 01-init-databases.sql
│   │   ├── 📁 migrations/             # 마이그레이션 스크립트
│   │   │   └── 📄 02-create-cs-tables.sql
│   │   └── 📁 seeds/                  # 시드 데이터 스크립트
│   │       └── 📄 03-seed-dummy-data.sql
│   ├── 📁 backups/                    # 데이터베이스 백업
│   │   └── 📄 full-dump.sql           # 전체 데이터 덤프 (310MB)
│   └── 📄 README.md                    # 데이터베이스 문서
│
├── 📁 mcp_server_practice/             # MCP 서버 애플리케이션
│   ├── 📁 src/
│   │   ├── 📁 tools/                  # MCP 도구
│   │   └── 📄 index.ts                # MCP 서버 엔트리
│   ├── 📄 Dockerfile                   # MCP 서버 도커 이미지
│   ├── 📄 docker-compose.yml           # MCP 서버 전용 Compose
│   ├── 📄 package.json                 # 의존성 관리
│   ├── 📄 tsconfig.json                # TypeScript 설정
│   └── 📄 readme.md                    # MCP 서버 문서
│
└── 📁 documents/                       # 프로젝트 문서
    ├── 📄 customer-complaint-guideline.md   # 고객 대응 지침서
    ├── 📄 complaint-response-templates.md   # 응대 템플릿
    └── 📄 n8n-workflow-guide.md             # n8n 워크플로우 가이드
```

### 주요 디렉토리 설명

- **backend_junggo/**: NestJS 기반 Backend API 서버
- **database/**: PostgreSQL 초기화, 마이그레이션, 백업 관리
- **mcp_server_practice/**: Model Context Protocol 서버 (AI 연동)
- **documents/**: 고객 대응 가이드 및 워크플로우 문서

## 🔄 n8n 워크플로우 시나리오

### 1. 고객 문의 자동 분류

- 문의 내용 키워드 분석
- 카테고리 자동 분류
- 담당자 자동 배정

### 2. JIRA 티켓 자동 생성

- 지침서 없는 케이스 감지
- JIRA API 연동
- 우선순위 자동 설정

### 3. 고객 응대 자동화

- 템플릿 기반 초기 응답
- 상태 업데이트 알림
- 만족도 조사 발송

## 🛠️ 유지보수

### 로그 확인

```bash
# Backend 로그
docker logs junggo_backend -f

# n8n 로그
docker logs junggo_n8n -f

# PostgreSQL 로그
docker logs junggo_postgres -f
```

### 데이터베이스 백업

```bash
# 백업
docker exec junggo_postgres pg_dump -U junggo_user junggo_db > backup.sql

# 복원
docker exec -i junggo_postgres psql -U junggo_user junggo_db < backup.sql
```

## 🚨 트러블슈팅

### 1. 컨테이너 시작 실패

```bash
# 모든 컨테이너 중지 및 제거
docker-compose down

# 볼륨 삭제 (주의: 데이터 손실)
docker-compose down -v

# 재시작
docker-compose up -d
```

### 2. 데이터베이스 연결 오류

- PostgreSQL 컨테이너 상태 확인
- 네트워크 설정 확인
- 환경 변수 확인

### 3. n8n 워크플로우 오류

- 자격 증명 확인
- API 엔드포인트 확인
- 로그 분석

## 📈 향후 계획

### Phase 1 (현재)

- [x] Backend API 구축
- [x] 사용자 관리 시스템
- [x] 로그 시스템
- [x] 고객 대응 지침서

### Phase 2

- [ ] n8n 워크플로우 구현
- [ ] JIRA 연동
- [ ] 자동 응답 시스템

### Phase 3

- [ ] AI 기반 문의 분류
- [ ] 실시간 대시보드
- [ ] 성과 분석 시스템

## 🗄️ 데이터베이스 스키마

### Users 테이블

- 기본 정보: id, email, password, firstName, lastName
- 추가 정보: phoneNumber, birthDate, role, profileImageUrl
- 설정: preferences (알림 설정, 관심 카테고리, 언어)
- 주소: address (도로명, 도시, 지역, 우편번호)
- 로그인 정보: loginCount, lastLoginAt, lastLoginIp
- 메타데이터: metadata (추가 정보 저장용)

### UserLogs 테이블

- 이벤트 정보: eventType, eventCategory, eventData
- 기기 정보: ipAddress, userAgent, deviceInfo
- 위치 정보: location (국가, 도시, 좌표)
- 세션 정보: sessionId, referrer, currentUrl
- 성능 정보: responseTime, httpMethod, statusCode
- 분류: tags, level (debug, info, warning, error, critical)

### InternalUsers 테이블 (내부 직원)

- 기본 정보: id, email, firstName, lastName, password, phoneNumber
- 직무 정보: department, position, employeeId, role
- 권한 및 레벨: accessLevel, permissions
- CS 전문성: specialties, maxConcurrentTickets
- 근무 정보: workSchedule, isAvailable, currentWorkload
- 성과 지표: totalTicketsHandled, avgResolutionTime, satisfactionRating
- 상태 정보: status, lastActiveAt
- 메타데이터: metadata, createdAt, updatedAt

### CustomerComplaints 테이블 (고객 컴플레인)

- 티켓 정보: id, ticketNumber
- 고객 정보: userId, customerName, customerEmail, customerPhone
- 문의 분류: category, subCategory, priority, urgency
- 내용: subject, description, attachments
- 상태 관리: status, escalationLevel, isEscalated
- 처리 정보: assignedTo, assignedTeam, firstResponseAt, resolvedAt, responseTime, resolutionTime
- 관련 정보: relatedProductId, relatedOrderId, relatedSellerId, jiraTicketKey
- 보상/조치: compensationType, compensationAmount, compensationNote
- 고객 만족도: satisfactionScore, feedbackComment
- 메타데이터: tags, metadata, createdAt, updatedAt

### ComplaintResponses 테이블 (컴플레인 응답)

- 기본 정보: id, complaintId, responderId, responderType
- 응답 내용: responseType, content, attachments
- 플래그: isInternal, isAutoResponse
- 타임스탬프: createdAt

### ComplaintHistory 테이블 (컴플레인 이력)

- 기본 정보: id, complaintId, actorId
- 변경 내역: action, fromValue, toValue, note
- 메타데이터: metadata, createdAt

### ComplaintTemplates 테이블 (응답 템플릿)

- 기본 정보: id, category, subCategory, templateName
- 템플릿 내용: templateContent, variables
- 상태 정보: isActive, usageCount
- 생성 정보: createdBy, createdAt, updatedAt

### ComplaintSlaRules 테이블 (SLA 규칙)

- 기본 정보: id, category, priority
- 시간 규칙: firstResponseTime, resolutionTime, escalationTime
- 상태 정보: isActive, createdAt, updatedAt

### ComplaintKnowledgeBase 테이블 (지식 베이스)

- 기본 정보: id, category, subCategory
- 콘텐츠: question, answer, keywords, relatedArticles
- 통계: viewCount, helpfulCount, notHelpfulCount
- 상태 정보: isPublished, createdBy, createdAt, updatedAt

## 👥 팀 구성

- **백엔드 개발**: Backend API, Database
- **워크플로우 개발**: n8n, MCP Server
- **CS 팀**: 고객 대응, 지침서 관리
- **QA 팀**: 테스트, 품질 관리

---

**Last Updated**: 2025-06-30
