-- =====================================================
-- Vector Embeddings Table for AI/ML features
-- =====================================================

-- pgvector 확장 활성화
CREATE EXTENSION IF NOT EXISTS vector;

-- Embeddings 테이블 생성
CREATE TABLE IF NOT EXISTS embeddings (
    id SERIAL PRIMARY KEY,
    embedding vector(1536),  -- OpenAI embedding dimension
    text text,
    created_at timestamptz DEFAULT now()
);

-- 인덱스는 데이터가 충분히 쌓인 후에 생성하는 것이 좋습니다
-- ivfflat 인덱스는 최소 수백 개의 행이 필요합니다
-- CREATE INDEX IF NOT EXISTS embeddings_embedding_idx ON embeddings USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);

COMMENT ON TABLE embeddings IS 'AI/ML을 위한 벡터 임베딩 저장소';
COMMENT ON COLUMN embeddings.embedding IS '텍스트의 벡터 표현';
COMMENT ON COLUMN embeddings.text IS '원본 텍스트';
