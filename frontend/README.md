# Frontend (Next.js 15)

고객이 CS 민원을 접수할 수 있는 웹 인터페이스입니다.

## 📋 기술 스택

- **Framework**: Next.js 15 (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **Form Management**: React Hook Form
- **Validation**: Zod
- **API Communication**: Fetch API

## 🚀 주요 기능

### 1. CS 민원 접수 폼

고객 정보와 문의 내용을 입력받는 폼:

**고객 정보**
- 이름 (필수)
- 이메일 (필수)
- 전화번호 (선택)

**문의 정보**
- 카테고리 (필수): 가격정보, 상품정보, 배송구매, 리뷰평점, 회원개인정보, 시스템기술
- 제목 (필수, 5자 이상)
- 상세 내용 (필수, 10자 이상)
- 관련 상품 ID (자동 생성, 읽기 전용)
- 관련 주문 ID (자동 생성, 읽기 전용)

### 2. 자동 ID 생성

카테고리에 따라 관련 ID가 자동으로 생성됩니다:

- **상품정보 또는 배송구매** 선택 시 → 관련 상품 ID 자동 생성
- **배송구매** 선택 시 → 관련 주문 ID 자동 생성

### 3. 폼 검증

Zod 스키마를 사용한 클라이언트 측 검증:

```typescript
- 이름: 2자 이상
- 이메일: 유효한 이메일 형식
- 제목: 5자 이상
- 상세 내용: 10자 이상
```

### 4. 접수 완료 정보 표시

민원 등록 성공 시 다음 정보를 표시합니다:

- ✅ 티켓 번호 (예: CS-2025-10-00001)
- 접수 ID (UUID)
- 관련 상품 ID (있는 경우)
- 관련 주문 ID (있는 경우)

## 🛠️ 개발 환경

### 로컬 개발

```bash
cd frontend

# 의존성 설치
yarn install

# 개발 서버 실행 (http://localhost:3000)
yarn dev

# 프로덕션 빌드
yarn build

# 프로덕션 서버 실행
yarn start
```

### 환경 변수

`.env.local` 파일:

```bash
NEXT_PUBLIC_API_URL=http://localhost:3003
```

### Docker로 실행

```bash
# Frontend 컨테이너만 빌드 및 시작
docker compose up -d frontend

# Frontend 로그 확인
docker logs junggo_frontend -f

# Frontend 재시작
docker compose restart frontend
```

## 📁 프로젝트 구조

```
frontend/
├── 📁 app/                    # Next.js App Router
│   ├── 📄 page.tsx           # 홈 페이지 (메인 폼)
│   ├── 📄 layout.tsx         # 루트 레이아웃
│   └── 📄 globals.css        # 전역 스타일
├── 📁 components/             # React 컴포넌트
│   └── 📄 ComplaintForm.tsx  # CS 민원 접수 폼
├── 📁 lib/                    # 유틸리티 함수
│   └── 📄 api.ts             # API 클라이언트
├── 📁 types/                  # TypeScript 타입 정의
│   └── 📄 complaint.ts       # Complaint 관련 타입
├── 📄 Dockerfile              # Docker 이미지 설정
├── 📄 .dockerignore           # Docker 빌드 제외 파일
├── 📄 .env.local              # 로컬 환경 변수
├── 📄 next.config.ts          # Next.js 설정 (Standalone 모드)
├── 📄 tailwind.config.ts      # Tailwind CSS 설정
├── 📄 tsconfig.json           # TypeScript 설정
└── 📄 package.json            # 의존성 관리
```

## 🔌 API 통신

Frontend는 Backend API (`http://localhost:3003`)와 통신합니다:

**민원 접수 API**
```typescript
POST /complaints
Content-Type: application/json

{
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
}
```

**응답**
```json
{
  "id": "uuid-here",
  "ticketNumber": "CS-2025-10-00001",
  "customerName": "홍길동",
  "customerEmail": "hong@example.com",
  "category": "배송구매",
  "status": "접수",
  "priority": "medium",
  "urgency": "normal",
  "relatedProductId": "PROD-ABC123",
  "relatedOrderId": "ORD-XYZ789",
  "createdAt": "2025-10-06T12:00:00Z",
  "updatedAt": "2025-10-06T12:00:00Z"
}
```

## 🐳 배포 구성

### Standalone 모드

Next.js Standalone 모드로 빌드되어 최소한의 파일만 포함:

```dockerfile
# 빌드 시점에 API URL 설정
ARG NEXT_PUBLIC_API_URL=http://localhost:3003
ENV NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}

# Standalone 출력물 복사
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

# Node.js로 직접 실행
CMD ["node", "server.js"]
```

### 포트 설정

- **내부 포트**: 3000 (컨테이너 내부)
- **외부 포트**: 3002 (호스트 머신)
- **Backend API**: 3003 (브라우저에서 접근)

## 🔧 트러블슈팅

### CORS 에러
```bash
# Backend에서 CORS 설정 확인
# backend_junggo/src/main.ts에서 Frontend URL 허용 확인
app.enableCors({
  origin: ['http://localhost:3002', ...],
  ...
});
```

### 빌드 에러
```bash
cd frontend
rm -rf .next node_modules
yarn install
yarn build
```

### API 연결 실패
```bash
# Backend가 실행 중인지 확인
curl http://localhost:3003/complaints

# Frontend 환경변수 확인
docker exec junggo_frontend env | grep NEXT_PUBLIC_API_URL
```

## 📚 관련 문서

- [Root README](../README.md) - 전체 프로젝트 개요
- [Backend README](../backend_junggo/README.md) - Backend API 문서
- [MCP Server README](../mcp_server_practice/README.md) - MCP Server 문서
