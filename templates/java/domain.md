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