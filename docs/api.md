# API Documentation

This document describes the APIs available in the Ghana Voting Application.

## Results API

The Results API provides access to the current voting results and administrative functions.

### Base URL

```
http://localhost:5001/api
```

### Endpoints

#### Get Voting Results

Retrieves the current voting results.

**URL**: `/results`

**Method**: `GET`

**Authentication**: None

**Response Format**:

```json
{
  "results": [
    {
      "party_code": "NPP",
      "name": "New Patriotic Party",
      "count": 42,
      "percentage": 56,
      "color": "#0F4CA8"
    },
    {
      "party_code": "NDC",
      "name": "National Democratic Congress",
      "count": 30,
      "percentage": 40,
      "color": "#006B3F"
    },
    {
      "party_code": "CPP",
      "name": "Convention People's Party",
      "count": 3,
      "percentage": 4,
      "color": "#D21034"
    }
  ],
  "totalVotes": 75,
  "lastUpdated": "2023-05-30T12:34:56Z"
}
```

**Response Fields**:

| Field | Type | Description |
|-------|------|-------------|
| results | Array | List of party results |
| results[].party_code | String | Party code identifier |
| results[].name | String | Full party name |
| results[].count | Number | Number of votes received |
| results[].percentage | Number | Percentage of total votes |
| results[].color | String | Hex color code for the party |
| totalVotes | Number | Total number of votes cast |
| lastUpdated | String | ISO timestamp of last update |

**Example Request**:

```bash
curl http://localhost:5001/api/results
```

#### Reset Votes

Resets all vote counts to zero. This endpoint is restricted to localhost access only.

**URL**: `/reset`

**Method**: `POST`

**Authentication**: None (IP restricted to localhost)

**Request Body**: None

**Response Format**:

```json
{
  "success": true,
  "message": "All votes have been reset"
}
```

**Response Fields**:

| Field | Type | Description |
|-------|------|-------------|
| success | Boolean | Whether the operation was successful |
| message | String | Description of the result |

**Example Request**:

```bash
curl -X POST http://localhost:5001/api/reset
```

**Error Responses**:

- **403 Forbidden**: If the request is not from localhost
  ```json
  {
    "error": "Access denied. This endpoint can only be accessed via CLI."
  }
  ```

- **500 Internal Server Error**: If there was a database error
  ```json
  {
    "error": "Failed to reset votes"
  }
  ```

## Vote API

The Vote API handles the submission of votes.

### Base URL

```
http://localhost:5000
```

### Endpoints

#### Submit Vote

Submits a vote for a specific party.

**URL**: `/vote`

**Method**: `POST`

**Authentication**: None

**Form Parameters**:

| Parameter | Type | Description |
|-----------|------|-------------|
| vote | String | Party code to vote for |

**Response**: HTML page with vote confirmation

**Example Request**:

```bash
curl -X POST -d "vote=NPP" http://localhost:5000/vote
```

## Internal APIs

These APIs are used internally by the application components.

### Redis Message Format

The Vote App publishes messages to Redis with the following format:

**Channel**: `ghana_votes`

**Message**: Party code as a string (e.g., "NPP")

### Database Schema

The PostgreSQL database has the following schema:

**Table**: `votes`

| Column | Type | Description |
|--------|------|-------------|
| party_code | VARCHAR(10) | Primary key, party identifier |
| party_name | VARCHAR(100) | Full name of the party |
| count | INT | Number of votes for the party |