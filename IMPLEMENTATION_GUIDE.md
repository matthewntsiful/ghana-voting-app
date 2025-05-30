# Ghana Voting Application - Implementation Guide

This guide provides step-by-step instructions for implementing the Ghana Voting Application. It is designed for students and colleagues who want to understand and deploy this microservices-based voting system.

## Project Overview

The Ghana Voting Application is a distributed system that simulates an election process with:
- A voting interface for citizens to cast votes
- A worker service that processes votes
- A results dashboard that displays real-time election results

## Technology Stack

- **Frontend**: HTML, CSS, JavaScript
- **Vote App**: Python with Flask
- **Worker**: .NET Core
- **Results App**: Node.js with Express
- **Message Broker**: Redis
- **Database**: PostgreSQL
- **Containerization**: Docker and Docker Compose

## Implementation Steps

### 1. Prerequisites

Ensure you have the following installed:
- Docker and Docker Compose
- Git
- A code editor (VS Code recommended)

### 2. Clone the Repository

```bash
git clone https://github.com/yourusername/ghana-voting-app.git
cd ghana-voting-app
```

### 3. Understanding the Project Structure

```
ghana-voting-app/
├── config/                  # Shared configuration
│   └── parties.json         # Political party definitions
├── db-init/                 # Database initialization
│   └── init.sql             # SQL setup script
├── vote/                    # Vote application (Flask)
│   ├── static/              # CSS and assets
│   ├── templates/           # HTML templates
│   ├── app.py               # Main application
│   └── Dockerfile           # Container definition
├── worker/                  # Vote processor (.NET)
│   ├── Program.cs           # Main application
│   └── Dockerfile           # Container definition
├── result/                  # Results dashboard (Node.js)
│   ├── public/              # Frontend files
│   ├── src/                 # Application code
│   └── Dockerfile           # Container definition
└── docker-compose.yml       # Service definitions
```

### 4. Running the Application

Start all services:
```bash
docker-compose up -d
```

Access the applications:
- Voting interface: http://localhost:5000
- Results dashboard: http://localhost:5001

### 5. Implementation Details

#### A. Vote Application (Flask/Python)

1. **Key Files**:
   - `vote/app.py`: Main application logic
   - `vote/templates/index.html`: Voting interface
   - `vote/templates/confirmation.html`: Vote confirmation page

2. **How It Works**:
   - Displays political parties from `config/parties.json`
   - Accepts user votes via form submission
   - Publishes votes to Redis
   - Shows confirmation page

3. **Implementation Focus**:
   - Study the Flask routes and Redis publishing
   - Understand the template rendering with Jinja2
   - Note how shared configuration is used

#### B. Worker Service (.NET)

1. **Key Files**:
   - `worker/Program.cs`: Vote processing logic

2. **How It Works**:
   - Subscribes to Redis channel for votes
   - Processes incoming votes
   - Updates PostgreSQL database

3. **Implementation Focus**:
   - Understand the Redis subscription pattern
   - Study the database update logic
   - Note the error handling approach

#### C. Results Application (Node.js)

1. **Key Files**:
   - `result/server.js`: Main server
   - `result/src/routes/results.js`: API endpoint
   - `result/public/index.html`: Dashboard UI

2. **How It Works**:
   - Provides REST API for vote results
   - Queries PostgreSQL for current standings
   - Displays real-time results with auto-refresh

3. **Implementation Focus**:
   - Study the Express.js routes
   - Understand the PostgreSQL queries
   - Note the frontend JavaScript for updating the UI

### 6. Customization Options

#### A. Adding Political Parties

1. Edit `config/parties.json`:
```json
{
  "PARTY_CODE": {
    "name": "Party Full Name",
    "color": "#HEX_COLOR"
  }
}
```

2. Update `db-init/init.sql` to include the new party:
```sql
INSERT INTO votes (party_code, party_name) VALUES ('PARTY_CODE', 'Party Full Name');
```

#### B. Modifying the UI

1. **Vote App UI**:
   - Edit templates in `vote/templates/`
   - Update CSS in `vote/static/css/style.css`

2. **Results Dashboard**:
   - Modify `result/public/index.html`

### 7. Testing the Application

1. **Vote Testing**:
   - Access http://localhost:5000
   - Select different parties and submit votes
   - Verify confirmation pages

2. **Results Testing**:
   - Access http://localhost:5001
   - Verify votes are being counted
   - Test auto-refresh functionality

3. **Reset Votes** (for testing):
   ```bash
   make reset-votes
   ```

### 8. Common Issues and Solutions

1. **Services not starting**:
   - Check Docker logs: `docker-compose logs [service_name]`
   - Verify ports 5000 and 5001 are available

2. **Votes not appearing in results**:
   - Check Redis connection: `docker-compose logs redis`
   - Verify worker is processing: `docker-compose logs worker`

3. **Database issues**:
   - Check PostgreSQL: `docker-compose logs db`
   - Connect directly: `docker-compose exec db psql -U postgres`

### 9. Learning Objectives

By implementing this project, you should understand:

1. **Microservices Architecture**:
   - How separate services communicate
   - Benefits of service isolation

2. **Message Queues**:
   - Pub/sub pattern with Redis
   - Asynchronous processing

3. **Containerization**:
   - Docker container configuration
   - Multi-container orchestration

4. **Full-Stack Development**:
   - Frontend and backend integration
   - Real-time data updates

### 10. Extension Ideas

1. **Authentication**:
   - Add user login to prevent duplicate voting
   - Implement admin authentication for results

2. **Analytics**:
   - Add voting analytics dashboard
   - Implement geographic distribution of votes

3. **Scaling**:
   - Implement load balancing for the vote app
   - Add database replication

## Conclusion

This implementation guide should help you understand and deploy the Ghana Voting Application. The project demonstrates modern software architecture principles and provides a practical example of microservices in action.

For additional help, refer to the documentation in the `docs` directory or contact the project maintainer.