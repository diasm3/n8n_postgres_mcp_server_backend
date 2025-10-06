-- Customer Users 테이블 생성
CREATE TABLE IF NOT EXISTS customer_users (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    "firstName" VARCHAR(100) NOT NULL,
    "lastName" VARCHAR(100) NOT NULL,
    "phoneNumber" VARCHAR(20),
    "birthDate" DATE,
    role VARCHAR(50) DEFAULT 'customer',
    "isActive" BOOLEAN DEFAULT true,
    "profileImageUrl" TEXT,
    preferences JSONB,
    address JSONB,
    "loginCount" INTEGER DEFAULT 0,
    "lastLoginAt" TIMESTAMP,
    "lastLoginIp" VARCHAR(50),
    metadata JSONB DEFAULT '{}',
    "createdAt" TIMESTAMP DEFAULT NOW(),
    "updatedAt" TIMESTAMP DEFAULT NOW()
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_customer_users_email ON customer_users(email);
CREATE INDEX IF NOT EXISTS idx_customer_users_role ON customer_users(role);

-- Customer User Logs 테이블 생성
CREATE TABLE IF NOT EXISTS customer_user_logs (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    "userId" TEXT NOT NULL,
    "eventType" VARCHAR(100) NOT NULL,
    "eventCategory" VARCHAR(100),
    "eventData" JSONB,
    "ipAddress" VARCHAR(50),
    "userAgent" TEXT,
    "deviceInfo" JSONB,
    location JSONB,
    "sessionId" VARCHAR(255),
    referrer TEXT,
    "currentUrl" TEXT,
    "responseTime" INTEGER,
    "httpMethod" VARCHAR(10),
    "statusCode" INTEGER,
    tags JSONB DEFAULT '[]',
    level VARCHAR(20) DEFAULT 'info',
    "createdAt" TIMESTAMP DEFAULT NOW(),

    CONSTRAINT fk_customer_user_logs_user FOREIGN KEY ("userId") REFERENCES customer_users(id) ON DELETE CASCADE
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_customer_user_logs_user_created ON customer_user_logs("userId", "createdAt");
CREATE INDEX IF NOT EXISTS idx_customer_user_logs_event_created ON customer_user_logs("eventType", "createdAt");
