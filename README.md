# Ghana Voting Application

A distributed voting application for Ghana elections using microservices architecture.

## Architecture

![Architecture Diagram](https://mermaid.ink/img/pako:eNqNVE1v2zAM_SuETgOaLnGSNsAOA7ZhwIBhQNHDLgNqkbG42JIhyUmC1P99lGwnTtcWPcQS-fjI90iK5xQbTWmWZtpYdKDxGRvQDVjUYLBCB9_QgVGwRQfGgYUKnYYXcPgEDVZQoYEtOFDWGrRQgUdXgwNdgcMGHFZQWrQOXsGiRVOBRQMVGrBYgkVXgwNXgcUGLFZQGnQOXsGhQ1uBQ4sVWnRYgkNfg4NQgcMGHFZQGvIOXsGjR1-BR4cVOvRYgsdQg4dYgccGPFZQGgoOXqHAQFGhwEAVBgxYKCBU6CFW6LEBD1VQGo4cXuGIgaOCI44qHHHEEo6xQo-xQo8NeKyC0nDi8AonDBwVnHBU4YQTlnCKFXqMFXpswGMVlIYzh1c4Y-Co4IyjCmecscQQKwwYKwzYQMCqKA0XDq9wwcBRwQVHFS64YIlhrDDECkNsMOBYFaXhyuEVrhg4KrjiqMIVVywxxgo9xgo9NuCxCkrDjcMr3DBwVHDDUYUbblhijBXGWGHEBiJWRWm4c3iFOwaOCu44qnDHHUuMscIYK4zYQMSqKA0PDq_wwMBRwQNHFR54YIkxVhhihQEbCFgVpeHJ4RWeGDgqeOKowhNPLDHGCmOsMGIDEauiNLw4vMILA0cFLxxVeOGFJcZYYYwVRmwgYlWUhjeHV3hj4KjgjaMKb7yxxBgrjLHCiA1ErIrS8OHwCh8MHBV8cFTh4_-Jf_8Bm-Hl_w)

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