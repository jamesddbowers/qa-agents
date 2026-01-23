# Postman Assertion Patterns

## Status Code Assertions

### Exact Status

```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Status code is 201 Created", function () {
    pm.response.to.have.status(201);
});

pm.test("Status code is 204 No Content", function () {
    pm.response.to.have.status(204);
});
```

### Status Range

```javascript
pm.test("Status code is 2xx", function () {
    pm.expect(pm.response.code).to.be.within(200, 299);
});

pm.test("Status code is not 5xx", function () {
    pm.expect(pm.response.code).to.be.below(500);
});
```

### Status Name

```javascript
pm.test("Status is OK", function () {
    pm.response.to.have.status("OK");
});

pm.test("Status is Created", function () {
    pm.response.to.have.status("Created");
});
```

## Response Time Assertions

```javascript
pm.test("Response time is less than 200ms", function () {
    pm.expect(pm.response.responseTime).to.be.below(200);
});

pm.test("Response time is less than 500ms", function () {
    pm.expect(pm.response.responseTime).to.be.below(500);
});

// Variable threshold
pm.test("Response time is acceptable", function () {
    const threshold = pm.environment.get("responseTimeThreshold") || 500;
    pm.expect(pm.response.responseTime).to.be.below(parseInt(threshold));
});
```

## JSON Structure Assertions

### Property Existence

```javascript
pm.test("Response has id", function () {
    const json = pm.response.json();
    pm.expect(json).to.have.property('id');
});

pm.test("Response has required fields", function () {
    const json = pm.response.json();
    pm.expect(json).to.have.property('id');
    pm.expect(json).to.have.property('name');
    pm.expect(json).to.have.property('email');
});

pm.test("Response has nested property", function () {
    const json = pm.response.json();
    pm.expect(json).to.have.nested.property('user.id');
});
```

### Property Values

```javascript
pm.test("ID is a number", function () {
    const json = pm.response.json();
    pm.expect(json.id).to.be.a('number');
});

pm.test("Name is not empty", function () {
    const json = pm.response.json();
    pm.expect(json.name).to.not.be.empty;
});

pm.test("Status is active", function () {
    const json = pm.response.json();
    pm.expect(json.status).to.eql('active');
});
```

### Array Assertions

```javascript
pm.test("Response is an array", function () {
    const json = pm.response.json();
    pm.expect(json).to.be.an('array');
});

pm.test("Response array is not empty", function () {
    const json = pm.response.json();
    pm.expect(json).to.have.length.above(0);
});

pm.test("Response has at least 5 items", function () {
    const json = pm.response.json();
    pm.expect(json.length).to.be.at.least(5);
});

pm.test("All items have id", function () {
    const json = pm.response.json();
    json.forEach(item => {
        pm.expect(item).to.have.property('id');
    });
});
```

## Header Assertions

```javascript
pm.test("Content-Type is JSON", function () {
    pm.response.to.have.header("Content-Type", "application/json");
});

pm.test("Content-Type contains json", function () {
    pm.expect(pm.response.headers.get("Content-Type")).to.include("json");
});

pm.test("Has pagination headers", function () {
    pm.response.to.have.header("X-Total-Count");
    pm.response.to.have.header("X-Page");
});
```

## Error Assertions

```javascript
pm.test("Error response has message", function () {
    const json = pm.response.json();
    pm.expect(json).to.have.property('error');
    pm.expect(json.error).to.have.property('message');
});

pm.test("Validation error returns 400", function () {
    pm.response.to.have.status(400);
    const json = pm.response.json();
    pm.expect(json).to.have.property('errors');
});
```

## Data Validation

```javascript
pm.test("Email is valid format", function () {
    const json = pm.response.json();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    pm.expect(json.email).to.match(emailRegex);
});

pm.test("Date is ISO format", function () {
    const json = pm.response.json();
    const date = new Date(json.createdAt);
    pm.expect(date.toISOString()).to.not.eql('Invalid Date');
});

pm.test("ID matches request", function () {
    const requestedId = pm.variables.get('userId');
    const json = pm.response.json();
    pm.expect(json.id.toString()).to.eql(requestedId);
});
```

## Combined Test Pattern

```javascript
// Standard test suite for GET endpoint
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Response time is acceptable", function () {
    pm.expect(pm.response.responseTime).to.be.below(500);
});

pm.test("Content-Type is JSON", function () {
    pm.expect(pm.response.headers.get("Content-Type")).to.include("json");
});

pm.test("Response has required structure", function () {
    const json = pm.response.json();
    pm.expect(json).to.be.an('array');
    if (json.length > 0) {
        pm.expect(json[0]).to.have.property('id');
        pm.expect(json[0]).to.have.property('name');
    }
});
```
