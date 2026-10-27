-- ==============================================================================
-- PROJETO EA2: AGENTE DE IA COM RAG E WEBHOOKS
-- SCRIPT DE CONFIGURAÇÃO DO BANCO DE DADOS VETORIAL (SUPABASE / PGVECTOR)
-- ==============================================================================

-- 1. Habilitar a extensão pgvector no PostgreSQL
CREATE EXTENSION IF NOT EXISTS vector;

-- 2. Criar a tabela 'documents' para armazenamento dos chunks e embeddings
-- Obs: A dimensão 1536 corresponde aos modelos de embedding da OpenAI (text-embedding-3-small e text-embedding-ada-002)
CREATE TABLE IF NOT EXISTS documents (
    id BIGSERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    metadata JSONB,
    embedding VECTOR(1536)
);

-- 3. Criar índice HNSW para otimizar busca por similaridade de cosseno
CREATE INDEX IF NOT EXISTS documents_embedding_hnsw_idx 
ON documents 
USING hnsw (embedding vector_cosine_ops);

-- 4. Criar a função RPC de busca semântica (match_documents) utilizada pelo n8n
CREATE OR REPLACE FUNCTION match_documents (
    query_embedding VECTOR(1536),
    match_count INT DEFAULT 5,
    filter JSONB DEFAULT '{}'
)
RETURNS TABLE (
    id BIGINT,
    content TEXT,
    metadata JSONB,
    similarity FLOAT
)
LANGUAGE plpgsql
AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT
        d.id,
        d.content,
        d.metadata,
        1 - (d.embedding <=> query_embedding) AS similarity
    FROM documents d
    WHERE d.metadata @> filter
    ORDER BY d.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;

