# Domain Model Rules (Model Layer)
- Favor immutability where possible.
- Use Lombok @Data with caution on Entities (watch out for circular equals/hashCode).
- Entities should have a default constructor (protected if required by JPA).

## Object-Oriented Design Principles
- **Tell, Don't Ask**: Implement behavior within domain objects rather than exposing getters for all internal state. Domain objects should encapsulate both data and behavior.
- **Validate Early**: Perform validation in constructors or factory methods to ensure objects are always in a valid state.
- **Use Constants**: Define business rules and magic numbers as `static final` constants (e.g., `MAX_INSTALLMENTS`, `SURCHARGE_RATE`).
- **Encapsulation**: Keep attributes private. Only expose getters/setters when necessary for the object's API.
- **Rich Domain Models**: Methods like `isEligibleForDiscount()`, `calculateTotal()`, or `canBeProcessed()` belong in the domain object, not in a service that asks for data.

## Getters and Setters Guidelines
- **Avoid unnecessary setters** for immutable identifiers (ID, IMEI, serial numbers) and fixed characteristics.
- **Avoid unnecessary getters** for internal implementation details that break encapsulation.
- **Use `final` fields** for attributes that shouldn't change after construction.
- **Provide setters only** for attributes that legitimately need to change during the object's lifecycle.
- **Expose behavior over data**: Instead of `getEngine()`, provide `startEngine()`, `isTooHot()`, etc.

## Relationship Implementation Guidelines
- **Composition**: Container class creates and owns the contained object. No setter for the contained object.
- **Bidirectional Association**: Both classes reference each other. Setters must maintain consistency automatically.
- **Respect relationship structure**: Don't create direct relationships not specified in your design.
- **Encapsulate navigation**: Provide behavior methods instead of exposing getter chains.

See `docs/dependency-management-best-practices.md` for detailed criteria on:
- Determining necessary vs unnecessary getters/setters
- Implementing 1-to-1 relationships (composition and bidirectional associations)