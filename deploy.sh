# Exemplo de Deploy Script
# Este script automatiza o deploy da aplicação em um servidor

#!/bin/bash

set -e

echo "🚀 Iniciando deploy da aplicação Spring Course..."

# Configurações
DEPLOY_DIR="/opt/spring-course"
IMAGE_NAME="ghcr.io/dalmosantos/java-spring-boot"
IMAGE_TAG="${1:-latest}"

echo "📦 Usando imagem: $IMAGE_NAME:$IMAGE_TAG"

# Verificar se está no diretório correto
if [ ! -d "$DEPLOY_DIR" ]; then
    echo "❌ Diretório $DEPLOY_DIR não existe!"
    exit 1
fi

cd $DEPLOY_DIR

# Backup do banco de dados
echo "💾 Fazendo backup do banco de dados..."
if docker-compose ps | grep -q "db"; then
    BACKUP_FILE="backup_$(date +%Y%m%d_%H%M%S).sql"
    docker-compose exec -T db pg_dump -U postgres springcourse > "backups/$BACKUP_FILE"
    echo "✅ Backup salvo em: backups/$BACKUP_FILE"
fi

# Pull da nova imagem
echo "⬇️  Baixando nova versão da imagem..."
docker pull $IMAGE_NAME:$IMAGE_TAG

# Atualizar docker-compose.yml com a nova tag
sed -i "s|image: $IMAGE_NAME:.*|image: $IMAGE_NAME:$IMAGE_TAG|g" docker-compose.production.yml

# Parar containers antigos
echo "⏹️  Parando containers antigos..."
docker-compose -f docker-compose.production.yml down

# Iniciar novos containers
echo "▶️  Iniciando novos containers..."
docker-compose -f docker-compose.production.yml up -d

# Aguardar aplicação ficar pronta
echo "⏳ Aguardando aplicação iniciar..."
sleep 10

# Health check
MAX_RETRIES=30
RETRY_COUNT=0
while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -sf http://localhost:8080/actuator/health > /dev/null; then
        echo "✅ Aplicação está rodando e saudável!"
        break
    fi
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "⏳ Tentativa $RETRY_COUNT/$MAX_RETRIES..."
    sleep 2
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "❌ Aplicação não respondeu ao health check!"
    echo "📋 Logs da aplicação:"
    docker-compose -f docker-compose.production.yml logs --tail=50 app
    exit 1
fi

# Limpeza
echo "🧹 Limpando imagens antigas..."
docker image prune -f

echo "✨ Deploy concluído com sucesso!"
echo "📊 Status dos containers:"
docker-compose -f docker-compose.production.yml ps

echo ""
echo "📝 Comandos úteis:"
echo "  Ver logs: docker-compose -f docker-compose.production.yml logs -f"
echo "  Status: docker-compose -f docker-compose.production.yml ps"
echo "  Parar: docker-compose -f docker-compose.production.yml down"
