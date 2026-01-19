# Node.js Endpoint Discovery Patterns

## Express.js

### Application-Level Routes

```javascript
const express = require('express');
const app = express();

// Direct app routes
app.get('/api/users', (req, res) => { });
app.post('/api/users', (req, res) => { });
app.put('/api/users/:id', (req, res) => { });
app.delete('/api/users/:id', (req, res) => { });
app.patch('/api/users/:id', (req, res) => { });
```

### Router-Level Routes

```javascript
const express = require('express');
const router = express.Router();

// Router routes (mounted at /api/users in app.js)
router.get('/', (req, res) => { });           // GET /api/users
router.get('/:id', (req, res) => { });        // GET /api/users/:id
router.post('/', (req, res) => { });          // POST /api/users
router.put('/:id', (req, res) => { });        // PUT /api/users/:id
router.delete('/:id', (req, res) => { });     // DELETE /api/users/:id

module.exports = router;

// In app.js:
app.use('/api/users', userRouter);
```

### Parameter Access

| Type | Access Pattern | Example |
|------|---------------|---------|
| Path | `req.params.id` | `/users/:id` |
| Query | `req.query.filter` | `/users?filter=active` |
| Body | `req.body.name` | JSON body |
| Header | `req.headers['authorization']` | Auth header |

### Middleware (Auth Detection)

```javascript
// Auth middleware patterns
router.get('/', authenticate, (req, res) => { });
router.get('/', requireAuth, (req, res) => { });
router.get('/', passport.authenticate('jwt'), (req, res) => { });
router.get('/', verifyToken, (req, res) => { });
```

### Grep Patterns

```bash
# Find Express routes
grep -rn "app\.get\|app\.post\|app\.put\|app\.delete\|app\.patch" --include="*.js" --include="*.ts" src/

# Find router routes
grep -rn "router\.get\|router\.post\|router\.put\|router\.delete\|router\.patch" --include="*.js" --include="*.ts" src/

# Find route mounts
grep -rn "app\.use.*Router\|app\.use('/" --include="*.js" --include="*.ts" src/
```

## NestJS

### Controller Decorators

```typescript
import { Controller, Get, Post, Put, Delete, Param, Body, Query } from '@nestjs/common';

@Controller('users')  // Base path: /users
export class UsersController {

    @Get()              // GET /users
    findAll(@Query('filter') filter: string) { }

    @Get(':id')         // GET /users/:id
    findOne(@Param('id') id: string) { }

    @Post()             // POST /users
    create(@Body() createUserDto: CreateUserDto) { }

    @Put(':id')         // PUT /users/:id
    update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) { }

    @Delete(':id')      // DELETE /users/:id
    remove(@Param('id') id: string) { }
}
```

### Parameter Decorators

| Decorator | Source |
|-----------|--------|
| `@Param('id')` | Path parameter |
| `@Query('filter')` | Query parameter |
| `@Body()` | Request body |
| `@Headers('authorization')` | HTTP header |

### Auth Guards

```typescript
@UseGuards(AuthGuard('jwt'))
@Get('profile')
getProfile() { }

@UseGuards(RolesGuard)
@Roles('admin')
@Get('admin')
getAdminData() { }
```

### Grep Patterns

```bash
# Find NestJS controllers
grep -rn "@Controller" --include="*.ts" src/

# Find NestJS endpoints
grep -rn "@Get\|@Post\|@Put\|@Delete\|@Patch" --include="*.ts" src/

# Find guarded routes
grep -rn "@UseGuards" --include="*.ts" src/
```

## Common TypeScript Patterns

### Route Registration Files

Look for route registration in:
- `routes/index.ts`
- `app.ts` or `server.ts`
- `*.routes.ts` files
- `*.controller.ts` files (NestJS)

### OpenAPI/Swagger Decorators (NestJS)

```typescript
@ApiTags('users')
@ApiOperation({ summary: 'Get all users' })
@ApiResponse({ status: 200, type: [User] })
@ApiParam({ name: 'id', type: 'string' })
@ApiQuery({ name: 'filter', required: false })
```
