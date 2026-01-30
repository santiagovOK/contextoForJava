# Domain Model Rules (Model Layer)
- Favor immutability where possible.
- Use Lombok @Data with caution on Entities (watch out for circular equals/hashCode).
- Entities should have a default constructor (protected if required by JPA).