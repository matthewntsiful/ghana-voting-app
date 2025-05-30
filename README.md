# Ghana Voting Application

A distributed voting application for Ghana elections using microservices architecture.

## Architecture

```mermaid
graph TD
    subgraph "User Interface"
        A[Voter] -->|Accesses| B[Vote App<br>Flask/Python]
        C[Admin] -->|Views| D[Results App<br>Node.js]
    end

    subgraph "Backend Services"
        B -->|Publishes vote| E[Redis<br>Message Broker]
        E -->|Consumes vote| F[Worker<br>.NET]
        F -->|Updates| G[PostgreSQL<br>Database]
        D -->|Reads| G
    end

    subgraph "Shared Configuration"
        H[parties.json] -->|Used by| B
        H -->|Used by| D
    end

    subgraph "Admin Operations"
        I[CLI Commands] -->|Reset votes| G
    end

    style B fill:#9CF,stroke:#333
    style D fill:#9CF,stroke:#333
    style E fill:#FCC,stroke:#333
    style F fill:#CFC,stroke:#333
    style G fill:#FCF,stroke:#333
```

The application consists of several microservices:

- **Vote**: A Flask web app where users cast their votes
- **Worker**: A .NET service that processes votes and updates the database
- **Result**: A Node.js web app that displays real-time voting results
- **Redis**: Used as a message queue
- **PostgreSQL**: Stores the voting data

## Shared Configuration

All services use a shared configuration for political parties stored in `/config/parties.json`.

## Running the Application

```bash
docker-compose up
```

- Vote application: http://localhost:5000
- Results dashboard: http://localhost:5001

## Reset Votes

To reset all votes (admin only):

```bash
make reset-votes
```

## Powered By

Blakk Brother Inc.