# Environments Configuration

Este diretório contém configurações para diferentes ambientes de deploy.

## Arquivos de Configuração

- `application.properties` - Configuração base e desenvolvimento local
- `application-docker.properties` - Configuração para execução em container
- `application-production.properties` - Configuração para produção

## Uso

### Desenvolvimento Local
```bash
mvn spring-boot:run
```

### Docker
```bash
docker-compose up
```

### Produção
```bash
docker-compose -f docker-compose.production.yml up -d
```

## Variáveis de Ambiente

### Obrigatórias em Produção

- `DATABASE_URL` - URL de conexão do banco de dados
- `DATABASE_USERNAME` - Usuário do banco
- `DATABASE_PASSWORD` - Senha do banco
- `ADMIN_PASSWORD` - Senha do admin da aplicação

### Opcionais

- `JAVA_OPTS` - Opções da JVM (ex: `-Xms256m -Xmx512m`)
- `SPRING_PROFILES_ACTIVE` - Perfil ativo (production, docker, etc)

## Exemplo de .env

Crie um arquivo `.env` na raiz do projeto:

```env
DB_PASSWORD=sua-senha-super-secreta
ADMIN_PASSWORD=outra-senha-super-secreta
```

**⚠️ IMPORTANTE:** Nunca commite o arquivo `.env` no Git!
