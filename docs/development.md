# Development Guide

This guide provides information for developers working on the Ghana Voting Application.

## Table of Contents

1. [Development Environment Setup](#development-environment-setup)
2. [Project Structure](#project-structure)
3. [Adding a New Party](#adding-a-new-party)
4. [Modifying the UI](#modifying-the-ui)
5. [Testing](#testing)
6. [Contributing Guidelines](#contributing-guidelines)

## Development Environment Setup

### Prerequisites

- Docker and Docker Compose
- Git
- Python 3.11+ (for Vote App)
- Node.js 18+ (for Result App)
- .NET 8.0 SDK (for Worker)

### Local Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/ghana-voting-app.git
   cd ghana-voting-app
   ```

2. **Run in development mode**:
   ```bash
   docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
   ```

   This will:
   - Mount code directories as volumes
   - Enable hot-reloading for the Vote and Result apps
   - Expose additional debugging ports

3. **Access the applications**:
   - Voting interface: http://localhost:5000
   - Results dashboard: http://localhost:5001

## Project Structure

```
ghana-voting-app/
├── config/                  # Shared configuration
│   └── parties.json         # Political party definitions
├── db-init/                 # Database initialization scripts
│   └── init.sql             # Creates tables and initial data
├── vote/                    # Vote application (Flask/Python)
│   ├── static/              # Static assets
│   ├── templates/           # HTML templates
│   ├── app.py               # Main application code
│   └── Dockerfile           # Container definition
├── worker/                  # Vote processor (.NET)
│   ├── Program.cs           # Main application code
│   ├── Worker.csproj        # Project file
│   └── Dockerfile           # Container definition
├── result/                  # Results dashboard (Node.js)
│   ├── public/              # Static assets
│   ├── src/                 # Application code
│   ├── server.js            # Main server code
│   └── Dockerfile           # Container definition
└── docker-compose.yml       # Service definitions
```

## Adding a New Party

1. **Update the party configuration**:

   Edit `config/parties.json` to add a new party:

   ```json
   {
     "NPP": {"name": "New Patriotic Party", "color": "#0F4CA8"},
     "NDC": {"name": "National Democratic Congress", "color": "#006B3F"},
     "CPP": {"name": "Convention People's Party", "color": "#D21034"},
     "NEW": {"name": "New Party Name", "color": "#HEX_COLOR"}
   }
   ```

2. **Update the database**:

   Edit `db-init/init.sql` to add the new party:

   ```sql
   INSERT INTO votes (party_code, party_name) VALUES 
   ('NPP', 'New Patriotic Party'),
   ('NDC', 'National Democratic Congress'),
   ('CPP', 'Convention People''s Party'),
   ('NEW', 'New Party Name');
   ```

3. **Rebuild and restart the application**:
   ```bash
   docker-compose down
   docker-compose up -d --build
   ```

## Modifying the UI

### Vote App UI

The Vote App uses Flask templates located in `vote/templates/`:

- `index.html` - The voting page
- `confirmation.html` - The vote confirmation page

CSS styles are in `vote/static/css/style.css`.

### Result App UI

The Result App UI is a single HTML file with embedded JavaScript and CSS:

- `result/public/index.html`

## Testing

### Manual Testing

1. **Test voting flow**:
   - Access the Vote App
   - Select a party and submit
   - Verify the confirmation page
   - Check the Results App to see the vote counted

2. **Test reset functionality**:
   ```bash
   make reset-votes
   ```
   - Verify all vote counts are reset to zero in the Results App

### Automated Testing

To add automated tests:

1. **For Vote App**:
   - Create tests in `vote/tests/`
   - Use pytest for testing

2. **For Worker**:
   - Create tests in `worker/tests/`
   - Use xUnit for testing

3. **For Result App**:
   - Create tests in `result/tests/`
   - Use Jest for testing

## Contributing Guidelines

1. **Branch naming convention**:
   - Feature: `feature/short-description`
   - Bugfix: `bugfix/issue-description`
   - Hotfix: `hotfix/critical-issue`

2. **Commit messages**:
   - Use present tense ("Add feature" not "Added feature")
   - First line should be a summary
   - Include the issue number if applicable

3. **Pull request process**:
   - Create a pull request with a clear description
   - Link to any relevant issues
   - Ensure all tests pass
   - Request review from at least one team member