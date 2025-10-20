# GitHub Actions Workflows - Quick Reference

## 🎯 Resumo dos Workflows Criados

### 1️⃣ Build and Test (`build-and-test.yml`)
✅ **O que faz:**
- Compila o projeto
- Executa testes automaticamente
- Gera relatórios de teste
- Verifica qualidade do código

📅 **Quando executa:** Automaticamente em push/PR nas branches main, develop, upgrade-java-21-spring-boot-3

### 2️⃣ Docker Build and Push (`docker-build-push.yml`)
✅ **O que faz:**
- Constrói imagem Docker
- Publica no GitHub Container Registry (ghcr.io)
- Faz scan de segurança
- Suporta multi-arquitetura

📅 **Quando executa:** Push em main/develop ou criação de tags v*

### 3️⃣ Deploy (`deploy.yml`)
✅ **O que faz:**
- Deploy manual para ambientes
- Health check pós-deploy
- Exemplos para SSH, Kubernetes, Azure, AWS

📅 **Quando executa:** Manualmente via GitHub Actions UI

### 4️⃣ Release (`release.yml`)
✅ **O que faz:**
- Cria release no GitHub
- Anexa JAR e arquivos
- Gera release notes

📅 **Quando executa:** Criação de tags v*

### 5️⃣ Cleanup (`cleanup.yml`)
✅ **O que faz:**
- Remove artifacts antigos
- Economiza espaço

📅 **Quando executa:** Semanalmente ou manualmente

---

## 📝 Checklist de Configuração

### Setup Inicial (Obrigatório)
- [ ] Verificar permissões do repositório (Settings → Actions → Read and write permissions)
- [ ] Fazer primeiro push para testar workflow básico
- [ ] Verificar se build passou com sucesso

### Para Docker (Recomendado)
- [ ] GitHub Packages já está configurado (nada a fazer!)
- [ ] Fazer push em main ou criar tag para testar build
- [ ] Verificar imagem em: github.com/seu-usuario/java-spring-boot/pkgs/container/java-spring-boot

### Para Deploy (Quando Necessário)
Escolha UMA opção e configure:

#### Opção A: Deploy via SSH
- [ ] Adicionar secrets: `DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_SSH_KEY`
- [ ] Ativar no `deploy.yml` (mudar `if: false` para `if: true`)

#### Opção B: Deploy Kubernetes
- [ ] Configurar kubectl com seu cluster
- [ ] Aplicar manifests: `kubectl apply -f k8s/`
- [ ] Ativar no `deploy.yml`

#### Opção C: Deploy Azure
- [ ] Adicionar secrets: `AZURE_APP_NAME`, `AZURE_PUBLISH_PROFILE`
- [ ] Ativar no `deploy.yml`

#### Opção D: Deploy AWS
- [ ] Adicionar secrets AWS
- [ ] Configurar ECS/EKS
- [ ] Ativar no `deploy.yml`

---

## 🎬 Testando os Workflows

### Teste 1: Build Básico
```bash
git add .
git commit -m "test: GitHub Actions setup"
git push
```
✅ Deve aparecer em Actions → Build and Test

### Teste 2: Docker Build
```bash
git checkout main
git push origin main
```
✅ Deve criar imagem em Packages

### Teste 3: Release
```bash
git tag v1.0.0
git push origin v1.0.0
```
✅ Deve criar release com JAR anexado

### Teste 4: Deploy Manual
1. Ir em Actions → Deploy Application
2. Run workflow
3. Escolher environment e version
✅ Deve executar deploy (ajustar secrets antes)

---

## 🔗 Links Úteis

- **Actions**: https://github.com/dalmosantos/java-spring-boot/actions
- **Packages**: https://github.com/dalmosantos/java-spring-boot/pkgs/container/java-spring-boot
- **Releases**: https://github.com/dalmosantos/java-spring-boot/releases

---

## 🐳 Usando a Imagem Docker

```bash
# Pull
docker pull ghcr.io/dalmosantos/java-spring-boot:latest

# Run
docker run -p 8080:8080 ghcr.io/dalmosantos/java-spring-boot:latest

# Com Docker Compose
docker-compose -f docker-compose.production.yml up -d
```

---

## 📚 Documentação Completa

- 📖 [Guia de Deployment Completo](./.github/DEPLOYMENT_GUIDE.md)
- 🛠️ [Comandos Úteis](./.github/COMMANDS.md)
- 🐳 [Docker Guide](./DOCKER.md)

---

## 🆘 Precisa de Ajuda?

1. Veja os logs em: Actions → Workflow → Run específica
2. Leia o Deployment Guide completo
3. Abra uma issue no repositório

**Próximo passo sugerido:** Testar o workflow básico com um push!
