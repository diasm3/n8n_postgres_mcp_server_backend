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
                    ┌──────────────────────────────────────────┐
                    │         External Services                 │
                    │  ┌──────────┐  ┌──────────┐  ┌─────────┐ │
                    │  │  ngrok   │  │   JIRA   │  │ Claude  │ │
                    │  │  (HTTPS) │  │  System  │  │   AI    │ │
                    │  └────┬─────┘  └────┬─────┘  └────┬────┘ │
                    └───────┼─────────────┼─────────────┼──────┘
                            │             │             │
┌─────────────────┐         │             │             │
│   Frontend      │         │             │             │
│   (Customer)    │         │             │             │
└────────┬────────┘         │             │             │
         │                  │             │             │
         ▼                  ▼             ▼             ▼
┌─────────────────────────────────────────────────────────────┐
│                    Docker Network                            │
│                                                               │
│  ┌─────────────────┐     ┌─────────────────┐                │
│  │  Backend API    │────▶│   PostgreSQL    │                │
│  │   (NestJS)      │     │   Database      │                │
│  │  Port: 3003     │     │   Port: 5432    │                │
│  └────────┬────────┘     └────────┬────────┘                │
│           │                       │                          │
│           │              ┌────────┴────────┐                 │
│           │              │                 │                 │
│           │              ▼                 ▼                 │
│  ┌────────▼────────┐  ┌──────────────┐  ┌─────────────┐    │
│  │      n8n        │  │  Postgres    │  │     MCP     │    │
│  │   Workflow      │──│  MCP Server  │  │   Server    │    │
│  │  Port: 5680     │  │  Port: 8003  │  │ Port: 8001  │    │
│  └────────┬────────┘  └──────────────┘  └──────┬──────┘    │
│           │                                     │            │
│           │              ┌──────────────────────┘            │
│           │              │                                   │
│           ▼              ▼                                   │
│  ┌─────────────────────────────────┐                        │
│  │         pgAdmin                  │                        │
│  │       Port: 5050                 │                        │
│  └─────────────────────────────────┘                        │
│                                                               │
└───────────────────────────────────────────────────────────────┘

```

### 구성 요소 설명

#### 🔵 Core Services
- **Backend API (NestJS)**: 메인 백엔드 서버 (Port: 3003)
  - REST API 제공
  - Prisma ORM으로 DB 연동
  - 고객 컴플레인, 사용자 관리 등

- **PostgreSQL Database**: 데이터 저장소 (Port: 5432)
  - 17개 테이블 (customer_users, complaints, internal_users 등)
  - 더미 데이터 자동 생성
  - pgvector 확장 (AI embedding)

#### 🟢 Automation & AI
- **n8n Workflow**: 워크플로우 자동화 (Port: 5680)
  - 컴플레인 자동 분류 및 처리
  - MCP Server 연동
  - Webhook 기반 이벤트 처리

- **MCP Server (Custom)**: AI 에이전트 통합 레이어 (Port: 8001)
  - Tools: AI가 호출 가능한 함수들
  - Resources: 데이터 소스 제공
  - Prompts: 프롬프트 템플릿

- **Postgres MCP Server**: PostgreSQL 전용 MCP (Port: 8003)
  - SQL 쿼리 실행
  - 데이터베이스 스키마 탐색
  - AI 기반 SQL 생성

#### 🟡 External Integrations
- **ngrok**: HTTPS 터널링 (Port: 4040)
  - 로컬 n8n을 외부에 노출
  - Webhook URL 제공

- **JIRA**: 티켓 관리 시스템 (Port: 8081)
  - 컴플레인 티켓 자동 생성
  - 이슈 추적

- **Claude AI**: AI 어시스턴트
  - MCP Server 통해 백엔드 접근
  - 자동 응답 생성

#### 🟠 Management Tools
- **pgAdmin**: PostgreSQL 관리 UI (Port: 5050)
  - 데이터베이스 시각화
  - 쿼리 실행 및 관리

### 데이터 흐름

1. **고객 요청** → Frontend → Backend API → PostgreSQL
2. **자동화 워크플로우** → n8n → MCP Server → Backend API
3. **AI 어시스턴트** → Claude → MCP Server → PostgreSQL (via Postgres MCP)
4. **외부 Webhook** → ngrok → n8n → 워크플로우 처리

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

| 서비스           | URL                      | 인증 정보                     |
| ---------------- | ------------------------ | ----------------------------- |
| Backend API      | http://localhost:3003    | -                             |
| n8n              | http://localhost:5680    | admin / admin                 |
| pgAdmin          | http://localhost:5050    | admin@junggo.com / admin      |
| PostgreSQL       | localhost:5432           | junggo_user / junggo_password |
| MCP Server       | http://localhost:8001    | -                             |
| Postgres MCP     | http://localhost:8003    | -                             |
| ngrok Dashboard  | http://localhost:4040    | -                             |
| Jira             | http://localhost:8081    | (초기 설정 필요)              |

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

   **방법 1: 자동 업데이트 스크립트 사용 (추천) ✨**

   ```bash
   # 실행 권한 부여 (최초 1회만)
   chmod +x update-n8n-url.sh

   # 스크립트 실행 - ngrok URL 자동 감지 및 .env 업데이트 + n8n 재시작
   ./update-n8n-url.sh
   ```

   스크립트가 자동으로:
   - ✅ ngrok API에서 현재 터널 URL 가져오기
   - ✅ `.env` 파일의 `N8N_WEBHOOK_URL`과 `N8N_HOST` 업데이트
   - ✅ n8n 컨테이너 자동 재시작

   **방법 2: 수동 업데이트**

   ngrok URL을 확인한 후 `.env` 파일 수정:

   ```bash
   # .env
   N8N_WEBHOOK_URL=https://abc123.ngrok.io
   N8N_HOST=abc123.ngrok.io
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

## 🤖 MCP Server (Model Context Protocol)

MCP Server는 AI 에이전트(Claude, n8n 등)가 백엔드 시스템과 상호작용할 수 있도록 하는 통합 레이어입니다.

### MCP Server 구성 요소

- **Tools**: AI가 호출할 수 있는 함수들 (예: DB 쿼리, API 호출)
- **Resources**: AI가 읽을 수 있는 데이터 소스 (예: 파일, 설정)
- **Prompts**: 미리 정의된 프롬프트 템플릿

### 접속 정보

| 항목 | 값 |
|------|-----|
| **MCP Server URL** | http://localhost:8001/mcp |
| **컨테이너 이름** | mcp-server |
| **포트** | 8001 (외부) → 3000 (내부) |
| **전송 방식** | HTTP/SSE (Server-Sent Events) |

### 사용 방법

#### 1. Docker로 실행 (추천)

```bash
# docker-compose로 자동 실행 (이미 포함됨)
docker-compose up -d mcp-server

# 로그 확인
docker logs mcp-server -f

# 상태 확인
curl http://localhost:8001/mcp
```

#### 2. 로컬에서 개발 모드로 실행

```bash
cd mcp_server_practice

# 의존성 설치
npm install

# 빌드
npm run build

# 개발 모드 실행 (auto-reload)
npm run dev

# 또는 프로덕션 모드 실행
npm start
```

### n8n에서 MCP Server 사용하기

1. **n8n 워크플로우에서 HTTP Request 노드 추가**

   ```
   Method: POST
   URL: http://mcp-server:3000/mcp
   Body Type: JSON
   Body:
   {
     "jsonrpc": "2.0",
     "id": 1,
     "method": "tools/call",
     "params": {
       "name": "tool_name",
       "arguments": {}
     }
   }
   ```

2. **사용 가능한 MCP Tools 확인**

   ```bash
   curl -X POST http://localhost:8001/mcp \
     -H "Content-Type: application/json" \
     -d '{
       "jsonrpc": "2.0",
       "id": 1,
       "method": "tools/list"
     }'
   ```

### MCP Server 프로젝트 구조

```
mcp_server_practice/
├── 📁 src/
│   ├── 📁 tools/
│   │   ├── 📄 tools.ts       # MCP Tools 정의
│   │   ├── 📄 resources.ts   # MCP Resources 정의
│   │   └── 📄 prompts.ts     # MCP Prompts 정의
│   └── 📄 index.ts            # MCP Server 엔트리포인트
├── 📁 dist/                   # 빌드 결과물
├── 📄 Dockerfile              # Docker 이미지 설정
├── 📄 package.json            # 의존성 관리
├── 📄 tsconfig.json           # TypeScript 설정
├── 📄 nodemon.json            # 개발 모드 설정
└── 📄 readme.md               # MCP Server 문서
```

### Claude Desktop 연동 (선택사항)

Claude Desktop에서 직접 MCP Server를 사용하려면:

1. **Claude Desktop 설정 파일 열기**
   - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - Windows: `%APPDATA%\Claude\claude_desktop_config.json`

2. **MCP Server 설정 추가**

   ```json
   {
     "mcpServers": {
       "junggo_backend": {
         "command": "node",
         "args": [
           "/absolute/path/to/mcp_server_practice/dist/index.js"
         ],
         "env": {
           "PORT": "3000"
         }
       }
     }
   }
   ```

3. **Claude Desktop 재시작**

### MCP Server 개발 가이드

새로운 Tool 추가하기:

```typescript
// src/tools/tools.ts
server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: "my_new_tool",
      description: "도구 설명",
      inputSchema: {
        type: "object",
        properties: {
          param1: { type: "string", description: "파라미터 설명" }
        },
        required: ["param1"]
      }
    }
  ]
}))

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  if (request.params.name === "my_new_tool") {
    const { param1 } = request.params.arguments
    // 로직 구현
    return {
      content: [{ type: "text", text: "결과" }]
    }
  }
})
```

### MCP Inspector로 테스트하기 🔍

MCP Inspector는 MCP Server를 시각적으로 테스트하고 디버깅할 수 있는 공식 도구입니다.

#### 설치 및 실행

```bash
# npx로 바로 실행 (설치 불필요)
npx @modelcontextprotocol/inspector
```

또는 글로벌 설치:

```bash
# 글로벌 설치
npm install -g @modelcontextprotocol/inspector

# 실행
mcp-inspector
```

#### MCP Inspector 사용법

1. **MCP Inspector 실행**

   ```bash
   npx @modelcontextprotocol/inspector
   ```

   브라우저가 자동으로 열리며 `http://localhost:5173` 에서 실행됩니다.

2. **Server 연결 설정**

   Inspector 웹 UI에서:

   - **Transport Type**: `SSE (Server-Sent Events)` 선택
   - **SSE URL**: `http://localhost:8001/mcp` 입력
   - **Connect** 버튼 클릭

3. **Tools 탭에서 테스트**

   - 사용 가능한 모든 Tools 목록 확인
   - Tool 선택하여 파라미터 입력
   - **Call Tool** 버튼으로 실행
   - 실시간으로 결과 확인

4. **Resources 탭에서 확인**

   - 사용 가능한 Resources 목록 확인
   - Resource 선택하여 내용 읽기

5. **Prompts 탭에서 테스트**

   - 미리 정의된 Prompt 템플릿 확인
   - Prompt 선택하여 실행

#### MCP Inspector 활용 예제

**예제 1: Tools 테스트**

1. Inspector에서 `http://localhost:8001/mcp` 연결
2. Tools 탭으로 이동
3. 사용 가능한 Tool 선택 (예: `get_users`)
4. 파라미터 입력 (있는 경우)
5. **Call Tool** 클릭
6. 응답 확인:
   ```json
   {
     "content": [
       {
         "type": "text",
         "text": "[사용자 목록 데이터]"
       }
     ]
   }
   ```

**예제 2: Resources 확인**

1. Resources 탭으로 이동
2. 사용 가능한 Resource 목록 확인
3. Resource 선택하여 내용 읽기

#### Docker 환경에서 MCP Inspector 사용

MCP Server가 Docker 컨테이너에서 실행 중일 때:

```bash
# MCP Server가 실행 중인지 확인
docker ps | grep mcp-server

# MCP Inspector 실행 (로컬)
npx @modelcontextprotocol/inspector

# Inspector에서 연결
# SSE URL: http://localhost:8001/mcp
```

#### MCP Inspector 스크린샷 가이드

Inspector UI 구성:
- **왼쪽 패널**: Tools, Resources, Prompts 목록
- **중앙 패널**: 선택한 항목의 상세 정보 및 입력 폼
- **오른쪽 패널**: 실행 결과 및 디버그 정보

#### 유용한 디버깅 팁

1. **Network 탭 확인**
   - 브라우저 개발자 도구 (F12) 열기
   - Network 탭에서 MCP 요청/응답 확인

2. **Console 탭 확인**
   - 에러 메시지 확인
   - JSON-RPC 통신 로그 확인

3. **MCP Server 로그와 함께 확인**
   ```bash
   # 터미널 1: MCP Server 로그
   docker logs mcp-server -f

   # 터미널 2: MCP Inspector 실행
   npx @modelcontextprotocol/inspector
   ```

### 트러블슈팅

**MCP Server 연결 안됨**
```bash
# MCP Server 컨테이너 상태 확인
docker ps | grep mcp-server

# 로그 확인
docker logs mcp-server

# 포트 확인
curl http://localhost:8001/mcp
```

**MCP Inspector 연결 실패**
```bash
# 1. MCP Server가 실행 중인지 확인
curl -X POST http://localhost:8001/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'

# 2. CORS 문제인 경우 - 브라우저 콘솔 확인
# 개발자 도구 (F12) > Console 탭에서 에러 확인

# 3. 포트가 이미 사용 중인 경우
# MCP Inspector는 기본적으로 5173 포트 사용
lsof -i :5173
```

**빌드 오류**
```bash
cd mcp_server_practice
rm -rf dist node_modules
npm install
npm run build
```

## 📡 API 엔드포인트

### Customer Users API

- `GET /customer-users` - 모든 고객 사용자 조회
- `POST /customer-users` - 새 고객 사용자 생성
- `GET /customer-users/:id` - 특정 고객 사용자 조회
- `PUT /customer-users/:id` - 고객 사용자 정보 수정
- `DELETE /customer-users/:id` - 고객 사용자 삭제

### Customer User Logs API

- `GET /customer-user-logs` - 모든 로그 조회
- `POST /customer-user-logs` - 로그 생성
- `GET /customer-user-logs/user/:userId` - 특정 사용자 로그 조회
- `GET /customer-user-logs/user/:userId/stats` - 사용자 로그 통계
- `GET /customer-user-logs/event/:eventType` - 이벤트 타입별 로그 조회

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
│   │   ├── 📁 users/                  # 고객 사용자 관리 모듈 (customer-users API)
│   │   ├── 📁 user-logs/              # 고객 사용자 로그 모듈 (customer-user-logs API)
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

### Customer Users 테이블

- 기본 정보: id, email, password, firstName, lastName
- 추가 정보: phoneNumber, birthDate, role, profileImageUrl
- 설정: preferences (알림 설정, 관심 카테고리, 언어)
- 주소: address (도로명, 도시, 지역, 우편번호)
- 로그인 정보: loginCount, lastLoginAt, lastLoginIp
- 메타데이터: metadata (추가 정보 저장용)

### Customer User Logs 테이블

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
