# 데이터베이스 초기화 가이드

이 디렉토리는 중고나라 프로젝트의 PostgreSQL 데이터베이스 초기화 스크립트를 포함합니다.

## 📁 디렉토리 구조

```
database/
├── README.md                          # 이 문서
├── backups/                           # 데이터베이스 백업
│   └── full-dump.sql                 # 전체 데이터 덤프 (310MB, Git 포함)
└── scripts/
    ├── init/                          # 초기 데이터베이스 설정
    │   └── 01-init-databases.sql     # 데이터베이스 생성
    ├── migrations/                    # 스키마 마이그레이션
    │   └── 02-create-cs-tables.sql   # CS 시스템 테이블 생성
    └── seeds/                         # 더미 데이터
        └── 03-seed-dummy-data.sql    # 개발용 더미 데이터
```

## 🚀 빠른 시작

### 1. Docker Compose로 자동 초기화

프로젝트 루트의 `docker-compose.yml`에 설정되어 있어, Docker 컨테이너 시작 시 자동으로 실행됩니다:

```bash
# Docker 컨테이너 시작 (자동으로 스크립트 실행)
docker-compose up -d

# 볼륨 삭제 후 재시작 (완전 초기화)
docker-compose down
docker volume rm n8n_with_mcp_server_example_postgres_data
docker-compose up -d
```

### 2. 수동 실행

각 스크립트를 개별적으로 실행할 수도 있습니다:

```bash
# 1. 데이터베이스 초기화
docker exec -i junggo_postgres psql -U junggo_user -d postgres < database/scripts/init/01-init-databases.sql

# 2. CS 테이블 생성
docker exec -i junggo_postgres psql -U junggo_user -d junggo_db < database/scripts/migrations/02-create-cs-tables.sql

# 3. 전체 데이터 복구 (백업 파일 사용)
docker exec -i junggo_postgres psql -U junggo_user -d junggo_db < database/backups/full-dump.sql
```

## 📋 스크립트 상세 설명

### 01-init-databases.sql
- **목적**: PostgreSQL 데이터베이스 초기 생성
- **생성 DB**:
  - `junggo_db` - 메인 애플리케이션 DB
  - `n8n_db` - n8n 워크플로우 DB
  - `jira_db` - Jira DB (선택사항)

### 02-create-cs-tables.sql
- **목적**: 고객 서비스(CS) 시스템 테이블 생성
- **생성 테이블**:
  - `customer_complaints` - 고객 컴플레인 메인
  - `complaint_responses` - 응답/댓글
  - `complaint_history` - 처리 이력
  - `complaint_templates` - 응답 템플릿
  - `complaint_sla_rules` - SLA 규칙
  - `complaint_knowledge_base` - FAQ/지식베이스
- **특징**:
  - 자동 티켓 번호 생성 (`CS-YYYY-MM-00001`)
  - SLA 규칙 기반 관리
  - 미처리 컴플레인 대시보드 뷰

### 03-seed-dummy-data.sql (사용 안 함)
- **목적**: 개발/테스트용 더미 데이터 생성
- **⚠️ 주의**: 현재는 `04-full-dump.sql`을 사용합니다
- **참고**: 필요 시 새로운 더미 데이터 생성 템플릿으로 활용 가능

### 04-full-dump.sql (backups/full-dump.sql)
- **목적**: 전체 데이터베이스 백업/복구
- **파일 크기**: 310MB
- **포함 데이터**:
  - Users: 10,000명
  - User Logs: 484,797개
  - CS Complaints: 1,000건
  - Complaint Responses: 3,500개
  - Complaint History: 3,000개
  - Templates: 20개
  - SLA Rules: 18개
  - Knowledge Base: 50개
- **특징**: Git에 포함되어 팀원 간 동일한 데이터 공유

## 🔧 유용한 명령어

### 데이터베이스 접속
```bash
# PostgreSQL CLI 접속
docker exec -it junggo_postgres psql -U junggo_user -d junggo_db

# 테이블 목록 확인
\dt

# 특정 테이블 구조 확인
\d customer_complaints

# 데이터 조회
SELECT * FROM customer_complaints LIMIT 10;
```

### 데이터 확인
```bash
# 각 테이블 레코드 수 확인
docker exec junggo_postgres psql -U junggo_user -d junggo_db -c "
SELECT
    'users' as table_name, COUNT(*) FROM users
UNION ALL
SELECT 'user_logs', COUNT(*) FROM user_logs
UNION ALL
SELECT 'customer_complaints', COUNT(*) FROM customer_complaints;
"
```

### 데이터베이스 백업/복구
```bash
# 전체 백업
docker exec junggo_postgres pg_dump -U junggo_user -d junggo_db > backup.sql

# 복구
docker exec -i junggo_postgres psql -U junggo_user -d junggo_db < backup.sql

# 특정 테이블만 백업
docker exec junggo_postgres pg_dump -U junggo_user -d junggo_db -t customer_complaints > complaints_backup.sql
```

## 📊 생성되는 데이터 구조

### Users 테이블
- 10,000명의 사용자
- 역할: customer, seller, admin
- 한국식 이름 및 주소
- 로그인 기록 포함

### User Logs 테이블
- 약 500,000개의 로그
- 다양한 이벤트 타입 (login, purchase, search 등)
- 디바이스 정보 및 위치 데이터 포함

### CS 시스템
- 1,000건의 컴플레인
- 6개 주요 카테고리 (가격정보, 상품정보, 배송구매 등)
- 우선순위 및 상태 관리
- SLA 규칙 기반 처리

## 🔐 환경별 실행 가이드

### 개발 환경
```bash
# 모든 스크립트 실행 (더미 데이터 포함)
./database/scripts/init/01-init-databases.sql
./database/scripts/migrations/02-create-cs-tables.sql
./database/scripts/seeds/03-seed-dummy-data.sql
```

### 스테이징 환경
```bash
# 스키마만 생성 (더미 데이터 제외)
./database/scripts/init/01-init-databases.sql
./database/scripts/migrations/02-create-cs-tables.sql
```

### 운영 환경
```bash
# 스키마만 생성, 더미 데이터는 절대 실행 금지!
./database/scripts/init/01-init-databases.sql
./database/scripts/migrations/02-create-cs-tables.sql
```

## 🐛 문제 해결

### "relation already exists" 에러
```bash
# 기존 테이블 삭제 후 재생성
docker exec junggo_postgres psql -U junggo_user -d junggo_db -c "DROP TABLE IF EXISTS customer_complaints CASCADE;"
```

### 더미 데이터 재생성
```bash
# 기존 데이터 삭제
docker exec junggo_postgres psql -U junggo_user -d junggo_db -c "
TRUNCATE TABLE user_logs, users, customer_complaints CASCADE;
"

# 더미 데이터 재생성
docker exec -i junggo_postgres psql -U junggo_user -d junggo_db < database/scripts/seeds/03-seed-dummy-data.sql
```

### Docker 볼륨 완전 초기화
```bash
# 모든 데이터 삭제 및 재시작
docker-compose down -v
docker-compose up -d
```

## 📝 참고 문서

- [Customer Complaint Guideline](../customer-complaint-guideline.md) - CS 대응 지침서
- [Complaint Response Templates](../complaint-response-templates.md) - 응답 템플릿
- [n8n Workflow Guide](../n8n-workflow-guide.md) - n8n 워크플로우 가이드

## ⚠️ 주의사항

1. **`full-dump.sql`은 Git에 포함되어 있어 팀원과 공유됩니다**
2. **운영 환경에서는 실제 데이터 백업을 별도로 관리하세요**
3. **데이터베이스 백업은 정기적으로 수행**
4. **민감한 정보는 .env 파일로 관리**
5. **추가 백업 파일은 `database/backups/`에 생성되지만 Git에서 제외됩니다**

## 🔄 업데이트 이력

- 2025-10-06: 초기 스크립트 구조 생성
- CS 시스템 테이블 추가
- 더미 데이터 생성 스크립트 추가
