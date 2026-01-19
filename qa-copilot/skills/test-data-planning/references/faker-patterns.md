# Faker Patterns for Postman

## Built-in Dynamic Variables

### Names

| Variable | Example Output |
|----------|---------------|
| `{{$randomFirstName}}` | John |
| `{{$randomLastName}}` | Smith |
| `{{$randomFullName}}` | John Smith |
| `{{$randomNamePrefix}}` | Dr. |
| `{{$randomNameSuffix}}` | Jr. |

### Contact

| Variable | Example Output |
|----------|---------------|
| `{{$randomEmail}}` | john.smith@example.com |
| `{{$randomPhoneNumber}}` | 555-123-4567 |

### Internet

| Variable | Example Output |
|----------|---------------|
| `{{$randomUserName}}` | jsmith42 |
| `{{$randomPassword}}` | xK9#mP2$vL |
| `{{$randomUrl}}` | https://example.com/page |
| `{{$randomDomainName}}` | example.com |
| `{{$randomIPV4}}` | 192.168.1.1 |
| `{{$randomIPV6}}` | 2001:0db8:85a3::8a2e |

### Numbers

| Variable | Example Output |
|----------|---------------|
| `{{$randomInt}}` | 42 |
| `{{$randomDouble}}` | 3.14159 |
| `{{$randomPrice}}` | 99.99 |

### Identifiers

| Variable | Example Output |
|----------|---------------|
| `{{$guid}}` | 550e8400-e29b-41d4-a716-446655440000 |
| `{{$randomUUID}}` | 550e8400-e29b-41d4-a716-446655440000 |
| `{{$timestamp}}` | 1640000000 |
| `{{$isoTimestamp}}` | 2024-01-15T10:30:00.000Z |

### Address

| Variable | Example Output |
|----------|---------------|
| `{{$randomStreetAddress}}` | 123 Main St |
| `{{$randomCity}}` | Springfield |
| `{{$randomCountry}}` | United States |
| `{{$randomCountryCode}}` | US |
| `{{$randomZipCode}}` | 12345 |

### Business

| Variable | Example Output |
|----------|---------------|
| `{{$randomCompanyName}}` | Acme Corp |
| `{{$randomJobTitle}}` | Software Engineer |
| `{{$randomDepartment}}` | Engineering |

### Text

| Variable | Example Output |
|----------|---------------|
| `{{$randomLoremWord}}` | lorem |
| `{{$randomLoremSentence}}` | Lorem ipsum dolor sit amet. |
| `{{$randomLoremParagraph}}` | (paragraph of text) |

## Pre-Request Script Patterns

### Generate Unique Email

```javascript
const uniqueEmail = `test_${Date.now()}_${Math.random().toString(36).substr(2, 5)}@test.com`;
pm.environment.set('testEmail', uniqueEmail);
```

### Generate Unique Username

```javascript
const username = `user_${Math.random().toString(36).substr(2, 8)}`;
pm.environment.set('testUsername', username);
```

### Generate Date Range

```javascript
// Random date in last 30 days
const now = Date.now();
const thirtyDaysAgo = now - (30 * 24 * 60 * 60 * 1000);
const randomDate = new Date(thirtyDaysAgo + Math.random() * (now - thirtyDaysAgo));
pm.environment.set('randomDate', randomDate.toISOString().slice(0, 10));
```

### Generate Random Selection

```javascript
const statuses = ['active', 'pending', 'inactive'];
const randomStatus = statuses[Math.floor(Math.random() * statuses.length)];
pm.environment.set('randomStatus', randomStatus);
```

## Request Body Examples

### User Creation

```json
{
    "firstName": "{{$randomFirstName}}",
    "lastName": "{{$randomLastName}}",
    "email": "{{testEmail}}",
    "phone": "{{$randomPhoneNumber}}"
}
```

### Product Creation

```json
{
    "name": "Product {{$randomInt}}",
    "description": "{{$randomLoremSentence}}",
    "price": {{$randomPrice}},
    "sku": "SKU-{{$guid}}"
}
```

### Order Creation

```json
{
    "userId": "{{testUserId}}",
    "items": [
        {
            "productId": "{{testProductId}}",
            "quantity": {{$randomInt}},
            "price": {{$randomPrice}}
        }
    ],
    "shippingAddress": {
        "street": "{{$randomStreetAddress}}",
        "city": "{{$randomCity}}",
        "zipCode": "{{$randomZipCode}}",
        "country": "{{$randomCountryCode}}"
    }
}
```

## Custom Faker Functions

### Phone with Format

```javascript
function generatePhone(format = 'XXX-XXX-XXXX') {
    return format.replace(/X/g, () => Math.floor(Math.random() * 10));
}
pm.environment.set('formattedPhone', generatePhone());
```

### Credit Card (Test Only)

```javascript
function generateTestCard() {
    // Test card numbers (not real)
    const prefixes = ['4111111111111', '5500000000000'];
    const prefix = prefixes[Math.floor(Math.random() * prefixes.length)];
    return prefix + Math.floor(Math.random() * 1000).toString().padStart(4, '0');
}
pm.environment.set('testCardNumber', generateTestCard());
```

### Date in Range

```javascript
function randomDateBetween(start, end) {
    const startTime = new Date(start).getTime();
    const endTime = new Date(end).getTime();
    const randomTime = startTime + Math.random() * (endTime - startTime);
    return new Date(randomTime).toISOString().slice(0, 10);
}
pm.environment.set('randomBirthDate', randomDateBetween('1970-01-01', '2000-12-31'));
```
