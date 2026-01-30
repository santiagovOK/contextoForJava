# API & Controller Rules (Web Layer)
- NEVER return JPA Entities directly; always use DTOs.
- Document public endpoints using OpenAPI/Swagger annotations.
- Use @RestControllerAdvice for global exception handling.
- Return ResponseEntity<?> for full control over HTTP responses.