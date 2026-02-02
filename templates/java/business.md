# Business Logic Rules (Service Layer)
- Public methods should be @Transactional(readOnly = true) by default.
- Write operations must explicitly override with @Transactional.
- Business logic MUST NOT depend on web objects (HttpServletRequest, etc).
- Use constructor injection (Lombok @RequiredArgsConstructor).

## Dependency and Design Best Practices
- **Prefer Usage Dependency**: Receive dependencies as constructor parameters (via DI) rather than creating them with `new` inside methods.
- **Null Validation**: Always validate that object references received as parameters are not null before using them.
- **Modularize Logic**: Break down complex methods into smaller, focused private helper methods. Each method should have a single responsibility.
- **Use Constants**: Define business rules (limits, rates, thresholds) as `static final` constants at the class level.
- **Early Validation**: Validate input parameters early in the method flow, ideally in dedicated validation helper methods.
- **Tell, Don't Ask**: When working with domain objects, tell them what to do rather than asking for their data and performing logic externally.