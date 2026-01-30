# Persistence Rules (Data Layer)
- Avoid complex logic in SQL; use JPQL, Criteria API, or Specifications.
- ALWAYS use FetchType.LAZY for all relationships (@ManyToOne, @OneToOne, @OneToMany, @ManyToMany).
- Use Optional<Entity> for ID lookups.
- Beware of the N+1 problem; use @EntityGraph or 'join fetch' when necessary.