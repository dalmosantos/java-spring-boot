# Comandos Úteis - GitHub Actions

## 🚀 Deploy e CI/CD

### GitHub CLI (gh)

```bash
# Instalar GitHub CLI
# Ubuntu/Debian
sudo apt install gh

# Login
gh auth login

# Listar workflows
gh workflow list

# Executar workflow manualmente
gh workflow run deploy.yml -f environment=development -f version=latest

# Ver execuções recentes
gh run list

# Ver detalhes de uma execução
gh run view <run-id>

# Ver logs
gh run view <run-id> --log

# Baixar artefatos
gh run download <run-id>

# Cancelar execução
gh run cancel <run-id>

# Re-executar workflow
gh run rerun <run-id>
```

### Docker - Trabalhando com GitHub Container Registry

```bash
# Login no GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Ou usando Personal Access Token
echo $PERSONAL_ACCESS_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Pull da imagem
docker pull ghcr.io/dalmosantos/java-spring-boot:latest

# Executar localmente
docker run -p 8080:8080 ghcr.io/dalmosantos/java-spring-boot:latest

# Com variáveis de ambiente
docker run -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=dev \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/springdb \
  ghcr.io/dalmosantos/java-spring-boot:latest

# Ver tags disponíveis (via API)
curl -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/users/dalmosantos/packages/container/java-spring-boot/versions
```

### Git - Tags e Releases

```bash
# Criar tag anotada
git tag -a v1.0.0 -m "Release version 1.0.0"

# Criar tag com assinatura GPG
git tag -s v1.0.0 -m "Signed release v1.0.0"

# Listar tags
git tag

# Ver detalhes de uma tag
git show v1.0.0

# Push de tag específica
git push origin v1.0.0

# Push de todas as tags
git push origin --tags

# Deletar tag local
git tag -d v1.0.0

# Deletar tag remota
git push origin :refs/tags/v1.0.0
# ou
git push origin --delete v1.0.0

# Criar tag de um commit específico
git tag -a v1.0.0 9fceb02 -m "Release v1.0.0"
```

### Maven - Build Local

```bash
# Build completo
mvn clean package

# Skip tests
mvn clean package -DskipTests

# Executar apenas testes
mvn test

# Gerar relatório de testes
mvn surefire-report:report

# Verificar dependências
mvn dependency:tree

# Atualizar dependências
mvn versions:display-dependency-updates

# Build com perfil específico
mvn clean package -P production
```

### Docker Compose - Deploy Local

```bash
# Subir ambiente completo
docker-compose up -d

# Ver logs
docker-compose logs -f

# Ver logs apenas da aplicação
docker-compose logs -f app

# Rebuild e restart
docker-compose up -d --build

# Parar todos os serviços
docker-compose down

# Parar e remover volumes
docker-compose down -v

# Ver status
docker-compose ps

# Executar comando em container
docker-compose exec app bash
```

## 📊 Monitoramento

### Verificar Health da Aplicação

```bash
# Health check simples
curl http://localhost:8080/actuator/health

# Health check detalhado (se configurado)
curl http://localhost:8080/actuator/health | jq

# Metrics
curl http://localhost:8080/actuator/metrics

# Info
curl http://localhost:8080/actuator/info

# Ver todas as endpoints do actuator
curl http://localhost:8080/actuator | jq
```

### Logs Docker

```bash
# Ver logs em tempo real
docker logs -f <container-id>

# Últimas 100 linhas
docker logs --tail 100 <container-id>

# Logs com timestamp
docker logs -t <container-id>

# Logs de um período específico
docker logs --since 2024-01-01 <container-id>
docker logs --since 1h <container-id>
```

## 🔒 Segurança

### Scan de Vulnerabilidades

```bash
# Trivy - Scan de imagem Docker
trivy image ghcr.io/dalmosantos/java-spring-boot:latest

# Scan com severidade específica
trivy image --severity HIGH,CRITICAL ghcr.io/dalmosantos/java-spring-boot:latest

# Scan de dependências Maven
mvn org.owasp:dependency-check-maven:check

# Scan com Grype
grype ghcr.io/dalmosantos/java-spring-boot:latest
```

## 🛠️ Desenvolvimento

### Setup Inicial

```bash
# Clone do repositório
git clone https://github.com/dalmosantos/java-spring-boot.git
cd java-spring-boot

# Criar branch de feature
git checkout -b feature/nova-funcionalidade

# Build local
mvn clean install

# Executar aplicação
mvn spring-boot:run

# Ou com perfil específico
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

### Testes

```bash
# Executar todos os testes
mvn test

# Executar teste específico
mvn test -Dtest=CrudbootApplicationTests

# Executar teste com método específico
mvn test -Dtest=CrudbootApplicationTests#contextLoads

# Testes com coverage
mvn test jacoco:report

# Ver relatório de coverage
open target/site/jacoco/index.html
```

### Limpeza

```bash
# Limpar build artifacts
mvn clean

# Limpar e remover dependências não usadas
mvn clean dependency:purge-local-repository

# Docker - Remover containers parados
docker container prune -f

# Docker - Remover imagens não usadas
docker image prune -a -f

# Docker - Remover volumes não usados
docker volume prune -f

# Docker - Limpeza completa
docker system prune -a --volumes -f
```

## 🚀 Deploy em Servidor

### Via SSH

```bash
# Conectar ao servidor
ssh user@server-ip

# Deploy manual
cd /opt/spring-course
docker-compose pull
docker-compose up -d

# Verificar status
docker-compose ps

# Ver logs
docker-compose logs -f app

# Backup do banco de dados (PostgreSQL)
docker-compose exec db pg_dump -U postgres springcourse > backup.sql

# Restore
cat backup.sql | docker-compose exec -T db psql -U postgres springcourse
```

### Kubernetes

```bash
# Aplicar manifests
kubectl apply -f k8s/

# Ver status
kubectl get pods
kubectl get services
kubectl get deployments

# Ver logs
kubectl logs -f deployment/spring-course

# Executar comando no pod
kubectl exec -it <pod-name> -- bash

# Port forward para teste local
kubectl port-forward deployment/spring-course 8080:8080

# Atualizar imagem
kubectl set image deployment/spring-course \
  spring-course=ghcr.io/dalmosantos/java-spring-boot:v1.0.0

# Ver histórico de deploys
kubectl rollout history deployment/spring-course

# Rollback
kubectl rollout undo deployment/spring-course
```

## 📈 Performance

### Análise de Performance

```bash
# Ver uso de recursos do container
docker stats

# Ver processos no container
docker top <container-id>

# Heap dump
jcmd <pid> GC.heap_dump /tmp/heapdump.hprof

# Thread dump
jcmd <pid> Thread.print > threaddump.txt

# JMX monitoring (se habilitado)
jconsole localhost:9010
```

## 🔍 Debug

### Debug Remoto

```bash
# Executar com debug habilitado
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005 \
  -jar target/spring-course-1.0.jar

# Docker com debug
docker run -p 8080:8080 -p 5005:5005 \
  -e JAVA_TOOL_OPTIONS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005" \
  ghcr.io/dalmosantos/java-spring-boot:latest
```

### Verificações Rápidas

```bash
# Verificar porta em uso
netstat -tlnp | grep 8080
lsof -i :8080

# Teste de conectividade
nc -zv localhost 8080

# HTTP request com timing
curl -w "\nTime: %{time_total}s\n" http://localhost:8080/

# Load test simples com Apache Bench
ab -n 1000 -c 10 http://localhost:8080/
```

## 💾 Backup e Restore

```bash
# Backup do banco (PostgreSQL)
docker exec postgres_container pg_dump -U postgres springcourse > backup_$(date +%Y%m%d).sql

# Backup comprimido
docker exec postgres_container pg_dump -U postgres springcourse | gzip > backup_$(date +%Y%m%d).sql.gz

# Restore
gunzip -c backup_20240101.sql.gz | docker exec -i postgres_container psql -U postgres springcourse

# Backup de volumes Docker
docker run --rm -v spring_course_data:/data -v $(pwd):/backup ubuntu \
  tar czf /backup/volume-backup.tar.gz /data
```

## 📦 Otimização

```bash
# Ver tamanho da imagem Docker
docker images ghcr.io/dalmosantos/java-spring-boot

# Analisar camadas da imagem
dive ghcr.io/dalmosantos/java-spring-boot:latest

# Otimizar JAR com Spring Boot
mvn clean package spring-boot:repackage

# Análise de dependências não usadas
mvn dependency:analyze
```

---

💡 **Dica:** Crie aliases para comandos frequentes no `~/.bashrc` ou `~/.zshrc`

```bash
# Exemplos de aliases úteis
alias gs='git status'
alias gp='git push'
alias dc='docker-compose'
alias k='kubectl'
alias mvnci='mvn clean install'
alias mvnp='mvn clean package -DskipTests'
```
