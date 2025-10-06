#!/bin/bash

# =====================================================
# ngrok URL을 가져와서 자동으로 .env 업데이트 및 n8n 재시작
# =====================================================

echo "🔍 ngrok 터널 URL 확인 중..."

# ngrok API에서 공개 URL 가져오기
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"https://[^"]*"' | grep -o 'https://[^"]*' | head -n 1)

if [ -z "$NGROK_URL" ]; then
    echo "❌ ngrok URL을 가져올 수 없습니다. ngrok이 실행 중인지 확인하세요."
    echo "💡 다음 명령어로 ngrok을 시작하세요: docker-compose up -d ngrok"
    exit 1
fi

echo "✅ ngrok URL 발견: $NGROK_URL"

# URL에서 호스트명 추출 (https:// 제거)
NGROK_HOST=$(echo "$NGROK_URL" | sed 's|https://||')

echo "   호스트: $NGROK_HOST"

# .env 파일에서 N8N_WEBHOOK_URL과 N8N_HOST 업데이트
ENV_FILE=".env"

if [ ! -f "$ENV_FILE" ]; then
    echo "❌ .env 파일을 찾을 수 없습니다."
    exit 1
fi

echo "📝 .env 파일 업데이트 중..."

# macOS와 Linux 모두 호환되도록 sed 사용
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s|N8N_WEBHOOK_URL=.*|N8N_WEBHOOK_URL=$NGROK_URL|g" "$ENV_FILE"
    sed -i '' "s|N8N_HOST=.*|N8N_HOST=$NGROK_HOST|g" "$ENV_FILE"
else
    # Linux
    sed -i "s|N8N_WEBHOOK_URL=.*|N8N_WEBHOOK_URL=$NGROK_URL|g" "$ENV_FILE"
    sed -i "s|N8N_HOST=.*|N8N_HOST=$NGROK_HOST|g" "$ENV_FILE"
fi

echo "✅ .env 파일 업데이트 완료"
echo "   N8N_HOST=$NGROK_HOST"
echo "   N8N_WEBHOOK_URL=$NGROK_URL"

# n8n 컨테이너 재시작
echo "🔄 n8n 컨테이너 재시작 중..."
docker-compose restart n8n

echo ""
echo "✨ 완료!"
echo "   ngrok URL: $NGROK_URL"
echo "   n8n 접속: http://localhost:5680"
echo "   ngrok 대시보드: http://localhost:4040"
echo ""
