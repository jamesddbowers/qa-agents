# Python Endpoint Discovery Patterns

## FastAPI

### Route Decorators

```python
from fastapi import FastAPI, Path, Query, Body, Header

app = FastAPI()

@app.get("/users")
def get_users(filter: str = Query(None), limit: int = Query(10)):
    pass

@app.get("/users/{user_id}")
def get_user(user_id: int = Path(..., description="User ID")):
    pass

@app.post("/users")
def create_user(user: UserCreate = Body(...)):
    pass

@app.put("/users/{user_id}")
def update_user(user_id: int, user: UserUpdate = Body(...)):
    pass

@app.delete("/users/{user_id}")
def delete_user(user_id: int):
    pass
```

### Router (APIRouter)

```python
from fastapi import APIRouter

router = APIRouter(prefix="/users", tags=["users"])

@router.get("/")
def get_users():
    pass

@router.get("/{user_id}")
def get_user(user_id: int):
    pass

# In main.py:
app.include_router(router)
```

### Parameter Types

| Type | FastAPI Pattern |
|------|----------------|
| Path | `user_id: int` or `Path(...)` |
| Query | `filter: str = Query(None)` |
| Body | `user: UserCreate = Body(...)` |
| Header | `token: str = Header(...)` |

### Auth Dependencies

```python
from fastapi import Depends, Security

@app.get("/protected")
def protected_route(user: User = Depends(get_current_user)):
    pass

@app.get("/admin")
def admin_route(user: User = Security(get_current_user, scopes=["admin"])):
    pass
```

### Grep Patterns

```bash
# Find FastAPI routes
grep -rn "@app\.get\|@app\.post\|@app\.put\|@app\.delete\|@app\.patch" --include="*.py" src/

# Find router routes
grep -rn "@router\.get\|@router\.post\|@router\.put\|@router\.delete" --include="*.py" src/

# Find protected routes
grep -rn "Depends\|Security" --include="*.py" src/
```

## Flask

### Route Decorators

```python
from flask import Flask, request

app = Flask(__name__)

@app.route('/users', methods=['GET'])
def get_users():
    filter_param = request.args.get('filter')
    pass

@app.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    pass

@app.route('/users', methods=['POST'])
def create_user():
    data = request.get_json()
    pass

@app.route('/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    pass

@app.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    pass
```

### Blueprint Routes

```python
from flask import Blueprint

users_bp = Blueprint('users', __name__, url_prefix='/users')

@users_bp.route('/', methods=['GET'])
def get_users():
    pass

@users_bp.route('/<int:user_id>', methods=['GET'])
def get_user(user_id):
    pass

# In app.py:
app.register_blueprint(users_bp)
```

### Auth Decorators

```python
from flask_login import login_required
from functools import wraps

@app.route('/protected')
@login_required
def protected():
    pass

# Custom decorator
def require_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        # Auth logic
        return f(*args, **kwargs)
    return decorated
```

### Grep Patterns

```bash
# Find Flask routes
grep -rn "@app\.route\|@.*\.route" --include="*.py" src/

# Find blueprints
grep -rn "Blueprint\|register_blueprint" --include="*.py" src/

# Find protected routes
grep -rn "@login_required\|@require_auth\|@auth_required" --include="*.py" src/
```

## Django REST Framework

### ViewSet Routes

```python
from rest_framework import viewsets
from rest_framework.decorators import action

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    # Custom action: GET /users/{pk}/orders/
    @action(detail=True, methods=['get'])
    def orders(self, request, pk=None):
        pass

    # Custom action: POST /users/bulk_create/
    @action(detail=False, methods=['post'])
    def bulk_create(self, request):
        pass
```

### URL Router

```python
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register(r'users', UserViewSet)
# Generates: GET/POST /users/, GET/PUT/PATCH/DELETE /users/{pk}/
```

### APIView Routes

```python
from rest_framework.views import APIView

class UserList(APIView):
    def get(self, request):
        pass

    def post(self, request):
        pass

class UserDetail(APIView):
    def get(self, request, pk):
        pass

    def put(self, request, pk):
        pass

    def delete(self, request, pk):
        pass

# In urls.py:
urlpatterns = [
    path('users/', UserList.as_view()),
    path('users/<int:pk>/', UserDetail.as_view()),
]
```

### Permission Classes

```python
from rest_framework.permissions import IsAuthenticated, IsAdminUser

class UserViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]

    @action(detail=False, permission_classes=[IsAdminUser])
    def admin_action(self, request):
        pass
```

### Grep Patterns

```bash
# Find ViewSets
grep -rn "class.*ViewSet\|class.*APIView" --include="*.py" src/

# Find URL patterns
grep -rn "path\|url\|router\.register" --include="*.py" src/

# Find permission classes
grep -rn "permission_classes\|IsAuthenticated\|IsAdminUser" --include="*.py" src/
```
