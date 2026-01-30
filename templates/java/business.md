# Business Logic Rules (Service Layer)
- Public methods should be @Transactional(readOnly = true) by default.
- Write operations must explicitly override with @Transactional.
- Business logic MUST NOT depend on web objects (HttpServletRequest, etc).
- Use constructor injection (Lombok @RequiredArgsConstructor).