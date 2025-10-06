# MCP Server (Model Context Protocol)

AI 에이전트(Claude, n8n 등)가 백엔드 시스템과 상호작용할 수 있도록 하는 통합 레이어입니다.

## 📋 개요

MCP Server는 AI 에이전트가 Backend API를 호출할 수 있도록 표준화된 인터페이스를 제공합니다.

### MCP Server 구성 요소

- **Tools**: AI가 호출할 수 있는 함수들 (예: DB 쿼리, API 호출)
- **Resources**: AI가 읽을 수 있는 데이터 소스 (예: 파일, 설정)
- **Prompts**: 미리 정의된 프롬프트 템플릿

## 🚀 MCP Tools 목록

```
┌─────────────────────────────────────────────────────────────────────┐
│                         MCP Server Tools                             │
│                    (AI ↔ Backend API Bridge)                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  📋 Customer Users (고객 관리)                                        │
│  ├─ fetch-user                          GET /customer-users/:id     │
│                                                                       │
│  👥 Internal Users (직원 관리)                                        │
│  ├─ fetch-internal-user                 GET /internal-users/:id     │
│  ├─ fetch-internal-user-by-employee-id  GET /internal-users/employee/:id │
│  ├─ fetch-all-internal-users            GET /internal-users         │
│  └─ fetch-available-agents              GET /internal-users/available-agents │
│                                                                       │
│  📝 User Logs (사용자 로그)                                           │
│  ├─ fetch-user-logs                     GET /customer-user-logs/user/:userId │
│  ├─ fetch-user-log-stats                GET /customer-user-logs/user/:userId/stats │
│  ├─ fetch-all-user-logs                 GET /customer-user-logs     │
│  └─ fetch-logs-by-event-type            GET /customer-user-logs/event/:type │
│                                                                       │
│  🎫 Complaints (민원 관리) - Read                                     │
│  ├─ fetch-all-complaints                GET /complaints             │
│  ├─ fetch-complaint                     GET /complaints/:id         │
│  ├─ fetch-complaint-by-ticket-number    GET /complaints/ticket/:number │
│  ├─ fetch-complaints-by-user            GET /complaints/user/:userId │
│  ├─ fetch-complaints-by-category        GET /complaints/category/:cat │
│  ├─ fetch-pending-complaints            GET /complaints/pending     │
│  ├─ fetch-complaint-stats               GET /complaints/stats       │
│  └─ fetch-complaint-responses           GET /complaints/:id/responses │
│                                                                       │
│  ✏️  Complaints (민원 관리) - Write                                   │
│  ├─ assign-complaint                    PUT /complaints/:id         │
│  │   └─ 담당자 배정 + 상태를 '처리중'으로 변경                        │
│  ├─ update-complaint-jira-ticket        PUT /complaints/:id         │
│  │   └─ JIRA 티켓 키 업데이트                                        │
│  └─ update-complaint                    PUT /complaints/:id         │
│      └─ 상태, 우선순위, 긴급도, JIRA 티켓, 담당자, 에스컬레이션 등   │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘

             ↓ Backend API (http://backend:3000)
             ↓
    ┌────────────────────────────┐
    │   NestJS Backend Server    │
    │   - REST API Endpoints     │
    │   - Prisma ORM             │
    └────────┬───────────────────┘
             ↓
    ┌────────────────────────────┐
    │   PostgreSQL Database      │
    │   - 17 Tables              │
    │   - Complaint Data         │
    └────────────────────────────┘
```

## 🛠️ 접속 정보

| 항목 | 값 |
|------|-----|
| **MCP Server URL** | http://localhost:8001/mcp |
| **컨테이너 이름** | mcp-server |
| **포트** | 8001 (외부) → 3000 (내부) |
| **전송 방식** | HTTP/SSE (Server-Sent Events) |

## 🔧 사용 방법

### 1. Docker로 실행 (추천)

```bash
# docker-compose로 자동 실행 (이미 포함됨)
docker-compose up -d mcp-server

# 로그 확인
docker logs mcp-server -f

# 상태 확인
curl http://localhost:8001/mcp
```

### 2. 로컬에서 개발 모드로 실행

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

## 📁 프로젝트 구조

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
└── 📄 README.md               # MCP Server 문서
```

## 🔌 n8n에서 MCP Server 사용하기

### 1. n8n 워크플로우에서 HTTP Request 노드 추가

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

### 2. 사용 가능한 MCP Tools 확인

```bash
curl -X POST http://localhost:8001/mcp \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "tools/list"
  }'
```

### 3. Tool 호출 예제

```bash
# 민원 조회
curl -X POST http://localhost:8001/mcp \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "tools/call",
    "params": {
      "name": "fetch-all-complaints",
      "arguments": {}
    }
  }'

# 담당자 배정
curl -X POST http://localhost:8001/mcp \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "tools/call",
    "params": {
      "name": "assign-complaint",
      "arguments": {
        "complaintId": "uuid-here",
        "agentId": "agent-uuid",
        "assignedTeam": "CS 1팀"
      }
    }
  }'
```

## 🖥️ Claude Desktop 연동

### 1. Claude Desktop 설정 파일 열기
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

### 2. MCP Server 설정 추가

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

### 3. Claude Desktop 재시작

## 🔍 MCP Inspector로 테스트하기

MCP Inspector는 MCP Server를 시각적으로 테스트하고 디버깅할 수 있는 공식 도구입니다.

### 설치 및 실행

```bash
# npx로 바로 실행 (설치 불필요)
npx @modelcontextprotocol/inspector

# 또는 글로벌 설치
npm install -g @modelcontextprotocol/inspector
mcp-inspector
```

### MCP Inspector 사용법

1. **MCP Inspector 실행**
   - 브라우저가 자동으로 열리며 `http://localhost:5173` 에서 실행됩니다.

2. **Server 연결 설정**
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

## 🛠️ MCP Server 개발 가이드

### 새로운 Tool 추가하기

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

    // Backend API 호출
    const response = await fetch(`http://backend:3000/api/endpoint`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ param1 })
    })

    const data = await response.json()

    return {
      content: [{
        type: "text",
        text: JSON.stringify(data, null, 2)
      }]
    }
  }
})
```

## 🐳 Docker 배포

### Dockerfile

```dockerfile
FROM node:20-alpine

WORKDIR /app

# 의존성 설치
COPY package*.json ./
RUN npm install

# 소스 복사 및 빌드
COPY . .
RUN npm run build

# 포트 노출
EXPOSE 3000

# MCP Server 실행
CMD ["node", "dist/index.js"]
```

### 포트 설정

- **내부 포트**: 3000 (컨테이너 내부)
- **외부 포트**: 8001 (호스트 머신)

## 🔧 트러블슈팅

### MCP Server 연결 안됨

```bash
# MCP Server 컨테이너 상태 확인
docker ps | grep mcp-server

# 로그 확인
docker logs mcp-server

# 포트 확인
curl http://localhost:8001/mcp
```

### MCP Inspector 연결 실패

```bash
# 1. MCP Server가 실행 중인지 확인
curl -X POST http://localhost:8001/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'

# 2. CORS 문제인 경우 - 브라우저 콘솔 확인
# 개발자 도구 (F12) > Console 탭에서 에러 확인

# 3. 포트가 이미 사용 중인 경우
lsof -i :5173
```

### 빌드 오류

```bash
cd mcp_server_practice
rm -rf dist node_modules
npm install
npm run build
```

### Backend API 호출 실패

```bash
# Backend 컨테이너가 실행 중인지 확인
docker ps | grep backend

# Docker 네트워크 확인
docker network inspect n8n_with_mcp_server_example_default

# MCP Server에서 Backend 연결 테스트
docker exec mcp-server curl http://backend:3000/complaints
```

## 📚 관련 문서

- [Root README](../README.md) - 전체 프로젝트 개요
- [Frontend README](../frontend/README.md) - Frontend 문서
- [Backend README](../backend_junggo/README.md) - Backend API 문서
- [MCP Protocol Specification](https://modelcontextprotocol.io) - MCP 공식 문서
