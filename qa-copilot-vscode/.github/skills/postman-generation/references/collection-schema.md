# Postman Collection v2.1 Schema

## Collection Structure

```json
{
    "info": {
        "_postman_id": "uuid",
        "name": "Collection Name",
        "description": "Collection description",
        "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
    },
    "item": [],
    "event": [],
    "variable": [],
    "auth": {}
}
```

## Info Object

```json
{
    "info": {
        "_postman_id": "12345678-1234-1234-1234-123456789012",
        "name": "API Test Collection",
        "description": "Smoke and regression tests for API",
        "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
    }
}
```

## Item (Request or Folder)

### Folder

```json
{
    "name": "Users",
    "description": "User management endpoints",
    "item": [
        // nested requests or folders
    ]
}
```

### Request

```json
{
    "name": "GET List Users [smoke]",
    "request": {
        "method": "GET",
        "header": [
            {
                "key": "Content-Type",
                "value": "application/json"
            }
        ],
        "url": {
            "raw": "{{baseUrl}}/api/users?page=1&limit=10",
            "host": ["{{baseUrl}}"],
            "path": ["api", "users"],
            "query": [
                { "key": "page", "value": "1" },
                { "key": "limit", "value": "10" }
            ]
        }
    },
    "response": [],
    "event": []
}
```

## URL Object

### Simple URL

```json
{
    "url": {
        "raw": "{{baseUrl}}/api/users",
        "host": ["{{baseUrl}}"],
        "path": ["api", "users"]
    }
}
```

### With Path Variables

```json
{
    "url": {
        "raw": "{{baseUrl}}/api/users/:userId",
        "host": ["{{baseUrl}}"],
        "path": ["api", "users", ":userId"],
        "variable": [
            {
                "key": "userId",
                "value": "{{userId}}"
            }
        ]
    }
}
```

### With Query Parameters

```json
{
    "url": {
        "raw": "{{baseUrl}}/api/users?filter=active&limit=10",
        "host": ["{{baseUrl}}"],
        "path": ["api", "users"],
        "query": [
            { "key": "filter", "value": "active" },
            { "key": "limit", "value": "10" }
        ]
    }
}
```

## Request Body

### JSON Body

```json
{
    "body": {
        "mode": "raw",
        "raw": "{\n    \"name\": \"John Doe\",\n    \"email\": \"john@example.com\"\n}",
        "options": {
            "raw": {
                "language": "json"
            }
        }
    }
}
```

### Form Data

```json
{
    "body": {
        "mode": "formdata",
        "formdata": [
            { "key": "name", "value": "John Doe", "type": "text" },
            { "key": "file", "type": "file", "src": "/path/to/file" }
        ]
    }
}
```

### URL Encoded

```json
{
    "body": {
        "mode": "urlencoded",
        "urlencoded": [
            { "key": "grant_type", "value": "client_credentials" },
            { "key": "client_id", "value": "{{clientId}}" }
        ]
    }
}
```

## Event (Scripts)

### Test Script

```json
{
    "event": [
        {
            "listen": "test",
            "script": {
                "type": "text/javascript",
                "exec": [
                    "pm.test('Status code is 200', function () {",
                    "    pm.response.to.have.status(200);",
                    "});"
                ]
            }
        }
    ]
}
```

### Pre-Request Script

```json
{
    "event": [
        {
            "listen": "prerequest",
            "script": {
                "type": "text/javascript",
                "exec": [
                    "console.log('Preparing request...');"
                ]
            }
        }
    ]
}
```

## Collection-Level Auth

```json
{
    "auth": {
        "type": "bearer",
        "bearer": [
            {
                "key": "token",
                "value": "{{ACCESS_TOKEN}}",
                "type": "string"
            }
        ]
    }
}
```

## Collection Variables

```json
{
    "variable": [
        {
            "key": "baseUrl",
            "value": "https://api.example.com"
        },
        {
            "key": "version",
            "value": "v1"
        }
    ]
}
```

## Environment File

```json
{
    "id": "uuid",
    "name": "Development",
    "values": [
        {
            "key": "baseUrl",
            "value": "https://dev-api.example.com",
            "enabled": true
        },
        {
            "key": "clientId",
            "value": "",
            "enabled": true,
            "type": "secret"
        }
    ]
}
```
