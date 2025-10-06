-- =====================================================
-- Vector Embeddings Table for AI/ML features
-- =====================================================

-- pgvector 확장 활성화
CREATE EXTENSION IF NOT EXISTS vector;

-- Embeddings 테이블 생성
CREATE TABLE IF NOT EXISTS embeddings (
    id SERIAL PRIMARY KEY,
    embedding vector,
    text text,
    created_at timestamptz DEFAULT now()
);

-- 인덱스 생성 (벡터 유사도 검색 성능 향상)
CREATE INDEX IF NOT EXISTS embeddings_embedding_idx ON embeddings USING ivfflat (embedding vector_cosine_ops);

COMMENT ON TABLE embeddings IS 'AI/ML을 위한 벡터 임베딩 저장소';
COMMENT ON COLUMN embeddings.embedding IS '텍스트의 벡터 표현';
COMMENT ON COLUMN embeddings.text IS '원본 텍스트';
