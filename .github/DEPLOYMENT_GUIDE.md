# Guia de GitHub Actions - Deploy e CI/CD

Este guia explica como configurar e usar os workflows de GitHub Actions criados para a aplicação Spring Boot.

## 📋 Índice

1. [Workflows Disponíveis](#workflows-disponíveis)
2. [Configuração Inicial](#configuração-inicial)
3. [Secrets Necessários](#secrets-necessários)
4. [Como Usar](#como-usar)
5. [Deploy em Diferentes Plataformas](#deploy-em-diferentes-plataformas)

## 🚀 Workflows Disponíveis

### 1. Build and Test (`build-and-test.yml`)
Executa testes e build da aplicação automaticamente em cada push/PR.

**Quando é executado:**
- Push nas branches: `main`, `develop`, `upgrade-java-21-spring-boot-3`
- Pull Requests para estas branches

**O que faz:**
- ✅ Executa testes unitários
- 📦 Compila a aplicação
- 📊 Gera relatórios de teste
- 💾 Salva artefatos (JAR) por 7 dias
- 🔍 Análise de qualidade de código (opcional)

### 2. Docker Build and Push (`docker-build-push.yml`)
Constrói e publica imagens Docker no GitHub Container Registry.

**Quando é executado:**
- Push nas branches: `main`, `develop`
- Criação de tags `v*`
- Pull Requests para `main`

**O que faz:**
- 🐳 Build da imagem Docker
- 📤 Push para GitHub Container Registry (ghcr.io)
- 🏷️ Tagueamento automático
- 🔒 Scan de segurança com Trivy
- 🏗️ Suporte multi-arquitetura (amd64, arm64)

### 3. Deploy (`deploy.yml`)
Deploy manual para diferentes ambientes.

**Quando é executado:**
- Manualmente via GitHub Actions UI

**O que faz:**
- 🚀 Deploy para ambiente escolhido (dev/staging/prod)
- 🔍 Health check pós-deploy
- 📝 Relatório de deployment

### 4. Release (`release.yml`)
Cria releases automaticamente quando uma tag é criada.

**Quando é executado:**
- Push de tags com formato `v*` (ex: v1.0.0)

**O que faz:**
- 📦 Cria release no GitHub
- 📎 Anexa JAR e arquivos importantes
- 📝 Gera notas de release automaticamente

### 5. Cleanup (`cleanup.yml`)
Remove artefatos antigos para economizar espaço.

**Quando é executado:**
- Semanalmente (segundas-feiras às 2h UTC)
- Manualmente

## ⚙️ Configuração Inicial

### 1. Habilitar GitHub Packages

As imagens Docker serão publicadas no GitHub Container Registry (ghcr.io). Não requer configuração adicional!

### 2. Configurar Permissões do Repositório

Vá em: **Settings** → **Actions** → **General**

Marque:
- ✅ Read and write permissions
- ✅ Allow GitHub Actions to create and approve pull requests

### 3. Testar o Workflow Básico

Faça um commit simples para testar:

```bash
git add .
git commit -m "test: configure GitHub Actions"
git push
```

Acompanhe em: **Actions** tab no GitHub

## 🔐 Secrets Necessários

Configure os secrets em: **Settings** → **Secrets and variables** → **Actions**

### Para Deploy via SSH (Servidor VPS/Cloud)

```
DEPLOY_HOST         # IP ou hostname do servidor (ex: 192.168.1.100)
DEPLOY_USER         # Usuário SSH (ex: ubuntu)
DEPLOY_SSH_KEY      # Chave privada SSH
```

### Para Azure App Service

```
AZURE_APP_NAME          # Nome do App Service
AZURE_PUBLISH_PROFILE   # Profile de publicação (download no Azure Portal)
```

### Para AWS

```
AWS_ACCESS_KEY_ID       # Access key da AWS
AWS_SECRET_ACCESS_KEY   # Secret key da AWS
AWS_REGION              # Região (ex: us-east-1)
```

### Para Health Check

```
APP_URL                 # URL da aplicação (ex: https://myapp.com)
```

## 📖 Como Usar

### Build e Test Automático

Simplesmente faça push do código:

```bash
git add .
git commit -m "feat: nova funcionalidade"
git push origin main
```

### Build da Imagem Docker

#### Opção 1: Push na branch main/develop
```bash
git checkout main
git push origin main
```

#### Opção 2: Criar uma tag de versão
```bash
git tag v1.0.0
git push origin v1.0.0
```

A imagem estará disponível em:
```
ghcr.io/dalmosantos/java-spring-boot:latest
ghcr.io/dalmosantos/java-spring-boot:v1.0.0
```

### Deploy Manual

1. Vá para **Actions** → **Deploy Application**
2. Clique em **Run workflow**
3. Escolha:
   - Environment: `development`, `staging` ou `production`
   - Version: tag da imagem (ex: `latest`, `v1.0.0`)
4. Clique em **Run workflow**

### Criar uma Release

```bash
# Criar e fazer push de uma tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

Isso automaticamente:
- Cria uma release no GitHub
- Anexa o JAR compilado
- Gera release notes

## 🌐 Deploy em Diferentes Plataformas

### 1. Deploy via SSH (VPS/Cloud Server)

**Passos:**

1. Configure os secrets necessários
2. Ative o deploy SSH no arquivo `deploy.yml`:
   ```yaml
   - name: Deploy to Server via SSH
     if: true  # ← Mude de false para true
   ```

3. No servidor, prepare o ambiente:
   ```bash
   # Instalar Docker
   curl -fsSL https://get.docker.com | sh
   
   # Criar diretório
   sudo mkdir -p /opt/spring-course
   cd /opt/spring-course
   
   # Copiar docker-compose.yml
   ```

4. Execute o workflow de deploy

### 2. Deploy para Docker Compose

Crie um `docker-compose.prod.yml`:

```yaml
version: '3.8'

services:
  app:
    image: ghcr.io/dalmosantos/java-spring-boot:latest
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=production
      - SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/springcourse
      - SPRING_DATASOURCE_USERNAME=postgres
      - SPRING_DATASOURCE_PASSWORD=${DB_PASSWORD}
    depends_on:
      - db
    restart: unless-stopped

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=springcourse
      - POSTGRES_PASSWORD=${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  postgres_data:
```

Script de deploy no servidor:
```bash
#!/bin/bash
cd /opt/spring-course
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
docker system prune -f
```

### 3. Deploy para Kubernetes

Crie manifestos Kubernetes:

```yaml
# k8s/deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spring-course
spec:
  replicas: 2
  selector:
    matchLabels:
      app: spring-course
  template:
    metadata:
      labels:
        app: spring-course
    spec:
      containers:
      - name: spring-course
        image: ghcr.io/dalmosantos/java-spring-boot:latest
        ports:
        - containerPort: 8080
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: "production"
```

Ative no workflow:
```yaml
- name: Deploy to Kubernetes
  if: true  # ← Ativar
  run: |
    kubectl set image deployment/spring-course spring-course=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ inputs.version }}
    kubectl rollout status deployment/spring-course
```

### 4. Deploy para Azure App Service

1. Crie um App Service no Azure Portal
2. Download do Publish Profile
3. Adicione como secret: `AZURE_PUBLISH_PROFILE`
4. Ative no workflow:
   ```yaml
   - name: Deploy to Azure App Service
     if: true  # ← Ativar
   ```

### 5. Deploy para AWS ECS

1. Configure AWS CLI com secrets
2. Crie task definition e service no ECS
3. Ative no workflow:
   ```yaml
   - name: Deploy to AWS ECS
     if: true  # ← Ativar
   ```

## 🔄 Workflow Completo Sugerido

```
1. Desenvolvimento
   ├─> Commit/Push → Build & Test automático
   ├─> PR → Build & Test + Code Review
   └─> Merge → Build & Test

2. Build Docker
   ├─> Merge to main → Build Docker Image (tag: latest, main-sha)
   └─> Tag (v*) → Build Docker Image + Create Release

3. Deploy
   ├─> Manual: Actions → Deploy → Choose environment
   └─> Automatic: Configure branch-based deploy

4. Monitoramento
   └─> Health checks após deploy
```

## 📊 Monitoramento e Logs

### Ver logs de build
```bash
# Via GitHub CLI
gh run list
gh run view <run-id> --log
```

### Baixar artefatos
```bash
gh run download <run-id>
```

### Ver imagens Docker
```bash
# Listar imagens
docker pull ghcr.io/dalmosantos/java-spring-boot:latest

# Ver tags disponíveis
# Acesse: https://github.com/dalmosantos/java-spring-boot/pkgs/container/java-spring-boot
```

## 🛠️ Troubleshooting

### Erro: "Resource not accessible by integration"
- Verifique as permissões do workflow em Settings → Actions

### Erro: "docker login failed"
- Certifique-se que as permissões de packages estão habilitadas

### Erro no health check
- Verifique se a aplicação expõe `/actuator/health`
- Adicione Spring Boot Actuator:
  ```xml
  <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-actuator</artifactId>
  </dependency>
  ```

### Imagem Docker muito grande
- Use multi-stage build (já configurado)
- Considere usar imagens Alpine
- Revise dependências desnecessárias

## 📚 Recursos Adicionais

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Spring Boot in Containers](https://spring.io/guides/topicals/spring-boot-docker/)

## 🎯 Próximos Passos

1. ✅ Testar workflow básico
2. 🐳 Verificar build Docker
3. 🔒 Configurar secrets necessários
4. 🚀 Testar deploy manual
5. 📊 Configurar monitoramento
6. 🔄 Automatizar deploy (opcional)
7. 📈 Integrar análise de código (SonarCloud)

## 💡 Dicas

- Use ambientes diferentes (dev/staging/prod) no GitHub
- Configure branch protection rules
- Adicione badges no README
- Use semantic versioning para tags
- Mantenha secrets rotacionados
- Monitore custos de storage de imagens/artifacts

---

**Precisa de ajuda?** Abra uma issue no repositório!
