# n8n 워크플로우 가이드

## 📋 개요

n8n은 중고나라의 자동화 플랫폼으로, 고객 문의 처리, 데이터 동기화, 알림 발송 등 다양한 업무를 자동화합니다.

## 🔄 주요 워크플로우

### 1. 고객 문의 자동 분류 및 처리 (Slack 기반)

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Slack Trigger  │────▶│  AI 분류기      │────▶│   Router        │
│ (문의 메시지)   │     │ (카테고리 판단)  │     │ (라우팅 분기)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                                                         │
                    ┌────────────────────────────────────┴───────────┐
                    │                                                │
            ┌───────▼────────┐                            ┌─────────▼────────┐
            │ Confluence     │                            │   JIRA 티켓      │
            │ 지침서 검색    │                            │   자동 생성      │
            └───────┬────────┘                            └─────────┬────────┘
                    │                                                │
            ┌───────▼────────┐                            ┌─────────▼────────┐
            │ Slack 스레드   │                            │  Slack 알림      │
            │ 자동 응답      │                            │  (티켓 생성됨)   │
            └────────────────┘                            └──────────────────┘
```

#### 트리거
- **Slack Event**: 특정 채널(#customer-support)의 새 메시지
- **Slack Command**: /support 명령어 실행

#### 프로세스
1. Slack 채널에서 고객 문의 메시지 수신
2. AI(MCP Server)로 문의 내용 분석 및 카테고리 분류
3. Confluence API로 해당 카테고리 지침서 검색
4. 지침서 존재 시 Slack 스레드로 가이드 답변
5. 지침서 없을 시 JIRA 티켓 생성 후 Slack 알림

#### 노드 구성
```json
{
  "nodes": [
    {
      "name": "Slack Trigger",
      "type": "n8n-nodes-base.slackTrigger",
      "parameters": {
        "channel": "#customer-support",
        "events": ["message"]
      }
    },
    {
      "name": "MCP Server Classify",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "url": "http://mcp-server:3000/classify",
        "method": "POST",
        "body": {
          "inquiry": "={{$json.text}}",
          "user": "={{$json.user}}"
        }
      }
    },
    {
      "name": "Search Confluence",
      "type": "n8n-nodes-base.confluence",
      "parameters": {
        "operation": "search",
        "cql": "space = CS AND type = page AND title ~ '{{$json.category}}'",
        "limit": 5
      }
    },
    {
      "name": "Reply in Thread",
      "type": "n8n-nodes-base.slack",
      "parameters": {
        "operation": "postMessage",
        "channel": "={{$json.channel}}",
        "thread_ts": "={{$json.ts}}",
        "text": "{{$json.guidelineContent}}"
      }
    },
    {
      "name": "Create JIRA Ticket",
      "type": "n8n-nodes-base.jira",
      "parameters": {
        "operation": "create",
        "project": "JUNGGO",
        "issueType": "Task",
        "summary": "[{{$json.category}}] 신규 고객 문의 - 지침서 업데이트 필요",
        "description": "Slack 문의: {{$json.text}}\n카테고리: {{$json.category}}\n고객: {{$json.user}}"
      }
    }
  ]
}
```

#### Slack 메시지 예시
```
고객: 중고나라에서 본 가격이랑 실제 판매처 가격이 달라요!

봇 응답 (지침서 있는 경우):
안녕하세요! 가격 불일치 관련 문의를 주셨네요. 
Confluence 지침서에 따르면:
- 중고나라는 판매처 가격을 실시간으로 업데이트하고 있습니다
- 가격 변동 시점을 확인해 드리겠습니다
[상세 가이드 링크]

봇 응답 (지침서 없는 경우):
문의 주셔서 감사합니다. 
해당 문의는 새로운 유형으로 확인되어 담당팀에 전달했습니다.
JIRA 티켓: JUNGGO-1234
빠른 시일 내에 답변 드리겠습니다.
```

### 2. 사용자 활동 모니터링 및 알림

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Schedule      │────▶│  User Logs API  │────▶│   Condition     │
│ (매 10분)       │     │  (활동 조회)     │     │ (이상 감지)     │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                                                         │
                                                         ▼
                                                ┌─────────────────┐
                                                │  Notification   │
                                                │ (Slack/Email)   │
                                                └─────────────────┘
```

#### 트리거
- **Cron**: 매 10분마다 실행

#### 프로세스
1. User Logs API에서 최근 활동 조회
2. 이상 패턴 감지 (로그인 실패 급증, 특정 오류 반복 등)
3. 조건 충족 시 담당자에게 알림

#### 노드 구성
```json
{
  "nodes": [
    {
      "name": "Schedule Trigger",
      "type": "n8n-nodes-base.scheduleTrigger",
      "parameters": {
        "rule": {
          "interval": [
            {
              "field": "minutes",
              "minutesInterval": 10
            }
          ]
        }
      }
    },
    {
      "name": "Get User Logs",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "url": "http://backend:3000/user-logs",
        "method": "GET",
        "queryParameters": {
          "limit": "100",
          "eventType": "LOGIN_FAILED"
        }
      }
    }
  ]
}
```

### 3. 가격 변동 알림 시스템

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Price Update   │────▶│  Compare Prices │────▶│  Filter Changes │
│  (Webhook)      │     │  (이전값 비교)   │     │  (임계값 확인)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                                                         │
                                                         ▼
                                                ┌─────────────────┐
                                                │  Update DB &    │
                                                │  Notify Users   │
                                                └─────────────────┘
```

#### 트리거
- **Webhook**: 판매처 가격 업데이트 시

#### 프로세스
1. 새로운 가격 정보 수신
2. 기존 가격과 비교
3. 5% 이상 변동 시 필터링
4. 데이터베이스 업데이트
5. 해당 상품 관심 고객에게 알림

### 4. JIRA 티켓 자동화

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  New Issue      │────▶│  Create JIRA    │────▶│  Assign Team    │
│  (트리거)       │     │  Ticket         │     │  (자동 배정)     │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                                                         │
                                                         ▼
                                                ┌─────────────────┐
                                                │  Update Status  │
                                                │  (고객 알림)     │
                                                └─────────────────┘
```

#### JIRA 티켓 템플릿
```json
{
  "fields": {
    "project": {
      "key": "JUNGGO"
    },
    "summary": "[{{category}}] {{title}}",
    "description": {
      "type": "doc",
      "content": [
        {
          "type": "heading",
          "attrs": {"level": 2},
          "content": [{"type": "text", "text": "문의 내용"}]
        },
        {
          "type": "paragraph",
          "content": [{"type": "text", "text": "{{inquiry}}"}]
        },
        {
          "type": "heading",
          "attrs": {"level": 2},
          "content": [{"type": "text", "text": "고객 정보"}]
        },
        {
          "type": "paragraph",
          "content": [{"type": "text", "text": "ID: {{userId}}\nEmail: {{email}}"}]
        }
      ]
    },
    "issuetype": {
      "name": "Task"
    },
    "priority": {
      "name": "{{priority}}"
    },
    "labels": ["customer-complaint", "{{category}}"]
  }
}
```

### 5. Confluence 지침서 동기화

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Confluence     │────▶│  Extract        │────▶│  Process        │
│  Webhook        │     │  Page Content   │     │  Guidelines     │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                                                         │
                                                         ▼
                                                ┌─────────────────┐
                                                │  Update Cache   │
                                                │  & Notify Team  │
                                                └─────────────────┘
```

#### 트리거
- **Confluence Webhook**: 페이지 생성/수정/삭제 시
- **Schedule**: 매일 오전 6시 전체 동기화

#### 프로세스
1. Confluence CS 스페이스의 지침서 변경 감지
2. 변경된 페이지 내용 추출
3. 카테고리별로 정리 및 캐싱
4. Slack으로 팀에 업데이트 알림

#### Confluence 페이지 구조
```
CS Space/
├── 가격 정보 관련/
│   ├── 가격 불일치 대응
│   └── 최저가 보증 안내
├── 상품 정보 관련/
│   ├── 스펙 오류 처리
│   └── 이미지 불일치
├── 배송/구매 관련/
│   ├── 배송 지연 대응
│   └── 판매처 연락두절
└── 템플릿/
    └── 응답 템플릿 모음
```

### 6. 데이터 동기화 워크플로우

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Schedule       │────▶│  Extract Data   │────▶│  Transform      │
│  (매일 02:00)   │     │  (소스 DB)      │     │  (데이터 변환)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                                                         │
                                                         ▼
                                                ┌─────────────────┐
                                                │  Load to Target │
                                                │  (타겟 DB)      │
                                                └─────────────────┘
```

## 🛠️ n8n 설정

### 환경 변수
```bash
# n8n 기본 설정
N8N_HOST=0.0.0.0
N8N_PORT=5678
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=admin

# 데이터베이스 설정
DB_TYPE=postgresdb
DB_POSTGRESDB_DATABASE=n8n_db
DB_POSTGRESDB_HOST=postgres
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_USER=junggo_user
DB_POSTGRESDB_PASSWORD=junggo_password

# 실행 설정
EXECUTIONS_DATA_SAVE_ON_ERROR=all
EXECUTIONS_DATA_SAVE_ON_SUCCESS=all
EXECUTIONS_DATA_SAVE_ON_PROGRESS=true
EXECUTIONS_DATA_SAVE_MANUAL_EXECUTIONS=true
```

### 자격 증명 설정

#### 1. Slack
- **Type**: Slack OAuth2
- **Client ID**: [Slack App Client ID]
- **Client Secret**: [Slack App Client Secret]
- **OAuth Scopes**: 
  - channels:history
  - channels:read
  - chat:write
  - files:read
  - users:read

#### 2. Confluence
- **Type**: Confluence
- **Domain**: junggo.atlassian.net
- **Email**: confluence-admin@junggo.com
- **API Token**: [Confluence API Token]
- **Space Key**: CS (Customer Support)

#### 3. JIRA
- **Type**: JIRA
- **Domain**: junggo.atlassian.net
- **Email**: jira-admin@junggo.com
- **API Token**: [JIRA에서 생성]

#### 4. Backend API
- **Type**: HTTP Request (OAuth2)
- **Base URL**: http://backend:3000
- **Authentication**: API Key

#### 5. MCP Server
- **Type**: HTTP Request
- **Base URL**: http://mcp-server:3000
- **Headers**: 
  - Content-Type: application/json
  - X-API-Key: [MCP_API_KEY]

## 📊 모니터링 및 관리

### 실행 로그 확인
```sql
-- 최근 실행된 워크플로우
SELECT 
  workflow_id,
  status,
  started_at,
  finished_at,
  execution_time
FROM execution_entity
ORDER BY started_at DESC
LIMIT 10;

-- 오류 발생 워크플로우
SELECT 
  workflow_id,
  error_message,
  started_at
FROM execution_entity
WHERE status = 'error'
ORDER BY started_at DESC;
```

### 성능 최적화 팁

1. **병렬 처리**
   - Split In Batches 노드 활용
   - 동시 실행 수 제한 설정

2. **메모리 관리**
   - 대용량 데이터는 스트리밍 처리
   - 불필요한 데이터 필드 제거

3. **에러 처리**
   - Error Trigger 노드로 실패 알림
   - Retry 설정으로 일시적 오류 대응

## 🔧 트러블슈팅

### 일반적인 문제

1. **Webhook이 작동하지 않음**
   - 방화벽 설정 확인
   - n8n URL 접근 가능 여부 확인
   - Webhook URL 정확성 확인

2. **API 연결 실패**
   - 네트워크 연결 확인
   - 자격 증명 유효성 확인
   - API 엔드포인트 가용성 확인

3. **워크플로우 실행 지연**
   - 동시 실행 수 확인
   - 데이터베이스 연결 풀 설정
   - 노드 실행 시간 분석

### 디버깅 방법

1. **Manual Execution**
   - 워크플로우를 수동으로 실행하여 단계별 확인

2. **Expression 테스트**
   - Expression Editor에서 데이터 변환 테스트

3. **로그 레벨 조정**
   ```bash
   N8N_LOG_LEVEL=debug
   ```

## 💬 Slack-Confluence-JIRA 통합 플로우

### 전체 아키텍처
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    Slack    │◀───▶│     n8n     │◀───▶│ Confluence  │
│  (고객문의) │     │ (자동화 허브)│     │  (지침서)   │
└─────────────┘     └──────┬──────┘     └─────────────┘
                           │
                    ┌──────▼──────┐
                    │    JIRA     │
                    │ (이슈 관리) │
                    └─────────────┘
```

### Slack 채널 구조
```
#customer-support (고객 문의 접수)
├── 스레드: 각 문의별 대화
└── 봇 응답: 자동 분류 및 가이드

#cs-team-internal (내부 팀 채널)
├── 새 티켓 알림
├── 지침서 업데이트 알림
└── 에스컬레이션 알림

#guideline-updates (지침서 변경 알림)
└── Confluence 페이지 변경 자동 알림
```

### Confluence 지침서 템플릿
```markdown
# [카테고리] 제목

## 문제 상황
- 고객이 보고하는 증상
- 발생 조건

## 확인 사항
- [ ] 체크리스트 1
- [ ] 체크리스트 2

## 대응 방법
1. 단계별 해결 방법
2. 추가 조치 사항

## Slack 응답 템플릿
\`\`\`
안녕하세요! [문의 유형] 관련 도움 드리겠습니다.
[해결 방법]
추가 문의사항이 있으시면 말씀해 주세요.
\`\`\`

## 관련 문서
- [링크1]
- [링크2]

---
*최종 수정: {{date}}*
*담당자: {{author}}*
```

## 🚀 베스트 프랙티스

1. **워크플로우 구조화**
   - 재사용 가능한 서브 워크플로우 생성
   - 명확한 노드 이름 사용
   - 적절한 주석 추가

2. **보안**
   - 민감한 정보는 자격 증명으로 관리
   - Webhook에 인증 추가
   - 실행 권한 제한

3. **버전 관리**
   - 워크플로우 정기 백업
   - 변경 사항 문서화
   - 테스트 환경 활용

4. **Slack 통합**
   - 스레드 기반 대화 유지
   - 이모지 반응으로 상태 표시
   - 멘션으로 담당자 지정

5. **Confluence 관리**
   - 일관된 페이지 구조 유지
   - 정기적인 리뷰 및 업데이트
   - 변경 이력 추적

## 📚 참고 자료

- [n8n 공식 문서](https://docs.n8n.io)
- [n8n 커뮤니티 포럼](https://community.n8n.io)
- [워크플로우 템플릿](https://n8n.io/workflows)