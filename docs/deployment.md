# Deployment Guide

This guide provides instructions for deploying the Ghana Voting Application to various environments.

## Table of Contents

1. [Local Deployment](#local-deployment)
2. [AWS Deployment](#aws-deployment)
3. [Production Considerations](#production-considerations)

## Local Deployment

### Using Docker Compose

The simplest way to deploy the application locally is using Docker Compose:

```bash
# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

### Manual Deployment

If you need to run services individually:

1. **Start Redis**:
   ```bash
   docker run -d --name redis -p 6379:6379 redis:alpine
   ```

2. **Start PostgreSQL**:
   ```bash
   docker run -d --name postgres -p 5432:5432 \
     -e POSTGRES_USER=postgres \
     -e POSTGRES_PASSWORD=postgres \
     -v ./db-init:/docker-entrypoint-initdb.d \
     postgres:15-alpine
   ```

3. **Start Vote App**:
   ```bash
   cd vote
   docker build -t ghana-vote-app .
   docker run -d --name vote-app -p 5000:80 \
     -e REDIS_HOST=redis \
     ghana-vote-app
   ```

4. **Start Worker**:
   ```bash
   cd worker
   docker build -t ghana-vote-worker .
   docker run -d --name vote-worker \
     -e REDIS_HOST=redis \
     -e POSTGRES_HOST=postgres \
     -e POSTGRES_USER=postgres \
     -e POSTGRES_PASSWORD=postgres \
     ghana-vote-worker
   ```

5. **Start Result App**:
   ```bash
   cd result
   docker build -t ghana-result-app .
   docker run -d --name result-app -p 5001:80 \
     -e POSTGRES_HOST=postgres \
     -e POSTGRES_USER=postgres \
     -e POSTGRES_PASSWORD=postgres \
     ghana-result-app
   ```

## AWS Deployment

### AWS Elastic Beanstalk

1. **Install EB CLI**:
   ```bash
   pip install awsebcli
   ```

2. **Initialize EB application**:
   ```bash
   eb init -p docker ghana-voting-app
   ```

3. **Create environment**:
   ```bash
   eb create ghana-voting-env
   ```

4. **Deploy application**:
   ```bash
   eb deploy
   ```

### AWS ECS (Elastic Container Service)

1. **Install AWS CLI**:
   ```bash
   pip install awscli
   aws configure
   ```

2. **Create ECR repositories**:
   ```bash
   aws ecr create-repository --repository-name ghana-vote-app
   aws ecr create-repository --repository-name ghana-vote-worker
   aws ecr create-repository --repository-name ghana-result-app
   ```

3. **Build and push Docker images**:
   ```bash
   # Login to ECR
   aws ecr get-login-password | docker login --username AWS --password-stdin ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com

   # Build and push images
   docker build -t ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/ghana-vote-app:latest ./vote
   docker push ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/ghana-vote-app:latest

   docker build -t ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/ghana-vote-worker:latest ./worker
   docker push ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/ghana-vote-worker:latest

   docker build -t ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/ghana-result-app:latest ./result
   docker push ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/ghana-result-app:latest
   ```

4. **Create ECS cluster**:
   ```bash
   aws ecs create-cluster --cluster-name ghana-voting-cluster
   ```

5. **Create task definitions and services** using the AWS Console or AWS CLI.

### AWS App Runner

For a simpler deployment of the frontend services:

1. **Push images to ECR** as shown above.

2. **Create App Runner services**:
   - Go to AWS App Runner console
   - Create a service for each frontend (vote-app and result-app)
   - Select the ECR repository and image
   - Configure environment variables
   - Deploy

## Production Considerations

### Security

1. **Add HTTPS**:
   - Use AWS Certificate Manager for SSL certificates
   - Configure Application Load Balancer with HTTPS listeners
   - Redirect HTTP to HTTPS

2. **Secure Redis and PostgreSQL**:
   - Use AWS ElastiCache for Redis with encryption and auth
   - Use Amazon RDS for PostgreSQL with encryption
   - Configure security groups to restrict access

3. **IAM Roles**:
   - Use IAM roles for ECS tasks
   - Follow principle of least privilege

### Scaling

1. **Horizontal Scaling**:
   - Configure Auto Scaling for ECS services
   - Use Application Load Balancer for the Vote and Result apps

2. **Database Scaling**:
   - Use Amazon RDS with read replicas
   - Consider Aurora PostgreSQL for better performance

### Monitoring

1. **Set up monitoring**:
   - Use CloudWatch for metrics and logs
   - Set up CloudWatch Alarms for critical metrics
   - Use X-Ray for distributed tracing

2. **Set up logging**:
   - Configure CloudWatch Logs for all services
   - Set up log retention policies

### Backup

1. **Database Backup**:
   - Enable automated backups for RDS
   - Configure backup retention period

2. **Infrastructure as Code**:
   - Use AWS CloudFormation or Terraform to define infrastructure
   - Store templates in version control