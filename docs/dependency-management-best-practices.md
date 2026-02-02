# Dependency Management and Object-Oriented Design Best Practices

This document outlines fundamental principles for managing dependencies and interactions between objects in object-oriented systems, with a focus on achieving high-quality, maintainable Java code.

## Types of Dependencies

### Usage Dependency

**Usage Dependency** occurs when a class uses another class temporarily, without maintaining a permanent reference to it as an attribute. This relationship is weak and circumstantial. It typically manifests when:

- An object is received as a parameter in a method
- An object is used as a local variable within a method
- A static method of another class is called

In UML, it is represented with a dashed line and an open arrow pointing towards the used class.

#### Best Practices for Usage Dependency

**• Prioritize Usage Dependency:** Whenever possible, it is a good practice to prefer receiving objects as parameters rather than creating them internally. This translates into **lower coupling** between classes, which in turn offers **greater flexibility** and **facilitates unit testing**.

**• Momentary Use:** It is ideal to use usage dependency when the object is only needed momentarily, for a specific task.

**• Dependency Injection:** Applying dependency injection is a good practice for managing the creation and injection of dependent objects.

**• Interfaces over Implementations:** To further reduce coupling, it is recommended to depend on interfaces or abstract classes instead of concrete implementations.

**• Null Validation:** It is crucial to **always validate that object references are not null** before using them, especially if they are received as parameters.

### Creation Dependency

**Creation Dependency** occurs when a class is responsible for creating instances of another class internally, within one of its methods, using `new`. In this case, the dependent class knows the construction details of the other class and assumes responsibility for its lifecycle. In UML, it is represented with a dashed line with an arrow and the legend `<<create>>` pointing towards the created class.

#### Best Practices for Creation Dependency

**• Creation Responsibility:** It is appropriate when the class containing the method is the one that has the responsibility for creating the objects.

**• Design Patterns:** This type of dependency is suitable when implementing design patterns such as the _Factory_ pattern.

**• Lifecycle Control:** Useful when explicit control over the lifecycle of the created object is needed.

**• Specific Implementation:** Used when the created object is a specific implementation that should not be passed from the outside.

**• Constructor Knowledge:** Implies that the dependent class has knowledge of the construction details of the object it creates.

#### Considerations about Creation Dependency

Although it allows controlling instantiation, this type of dependency generates **higher coupling** between classes and **less flexibility** compared to usage dependency, which can make it difficult to change implementations and perform unit testing.

## General Best Practices for Dependency Management

Beyond the specific types of dependency, the following fundamental principles are essential for designing high-quality object systems:

### 1. Tell, Don't Ask Principle

**• Delegate the Logic:** Instead of asking an object for data to process it outside, you should **"tell the object what to do"**, delegating the task to it so that it performs it with its own data.

**• Avoid Object Getters:** While you don't have to be fundamentalist and getters for simple data can be useful, you should **think carefully when a class exposes a getter that returns a reference to another object** (like `getEngine()` or `getOwner()`). This often indicates that external logic is being performed that should be the responsibility of the internal object.

**• Benefits:** Applying this principle **improves encapsulation**, **reduces coupling between classes**, and makes the **code clearer and more maintainable**. It also helps to **distribute logic** instead of centralizing it in one place.

#### Examples

❌ **Bad Practice (Ask):**
```java
// Asking for data and processing it externally
Engine engine = car.getEngine();
if (engine.getTemperature() > 100) {
    engine.activateCoolingSystem();
}
```

✅ **Good Practice (Tell):**
```java
// Telling the object what to do
car.coolDownIfNecessary();

// Inside Car class:
public void coolDownIfNecessary() {
    if (engine.isTooHot()) {
        engine.activateCoolingSystem();
    }
}
```

### 2. Proper Encapsulation

**• Private Attributes:** Keep attributes private and provide access methods (getters/setters) only when appropriate or necessary.

**• Expose Behavior, Not Data:** Classes should expose what they can do (methods), not what they have (getters for all attributes).

### 3. Low Coupling and High Cohesion

These are fundamental principles in OOP that should be maintained in all interactions between classes:

**• Low Coupling:** Classes depend little on each other. Changes in one class should minimally impact others.

**• High Cohesion:** A class focuses on a single responsibility. All its methods and attributes should be related to that responsibility.

### 4. Logic Modularization

**• Helper Methods:** Break down complex logic into smaller, specialized helper methods (or functions) so that main methods (like `processPayment`) are shorter and easier to understand.

**• Single Responsibility per Method:** Each method should do one thing and do it well.

#### Example

❌ **Bad Practice (Complex method):**
```java
public void processPayment(double amount, int installments) {
    if (amount <= 0) throw new IllegalArgumentException("Invalid amount");
    if (installments < 1 || installments > 12) throw new IllegalArgumentException("Invalid installments");
    double surcharge = 0;
    if (installments > 1) surcharge = amount * 0.05;
    double total = amount + surcharge;
    double installmentAmount = total / installments;
    // More complex logic...
}
```

✅ **Good Practice (Modularized):**
```java
public void processPayment(double amount, int installments) {
    validatePaymentData(amount, installments);
    double total = calculateTotalWithSurcharge(amount, installments);
    double installmentAmount = calculateInstallmentAmount(total, installments);
    // Clear, readable main flow
}

private void validatePaymentData(double amount, int installments) {
    if (amount <= 0) throw new IllegalArgumentException("Invalid amount");
    if (installments < 1 || installments > MAX_INSTALLMENTS) {
        throw new IllegalArgumentException("Invalid installments");
    }
}

private double calculateTotalWithSurcharge(double amount, int installments) {
    if (installments > 1) {
        return amount * (1 + SURCHARGE_RATE);
    }
    return amount;
}

private double calculateInstallmentAmount(double total, int installments) {
    return total / installments;
}
```

### 5. Use of Constants

**• Avoid Hardcoded Values:** Use **static final class attributes (constants)** for fixed values like surcharge percentages or installment limits. This improves code readability and maintainability.

#### Example

❌ **Bad Practice:**
```java
if (installments > 12) throw new IllegalArgumentException("Too many installments");
double surcharge = amount * 0.05;
```

✅ **Good Practice:**
```java
private static final int MAX_INSTALLMENTS = 12;
private static final double SURCHARGE_RATE = 0.05;

if (installments > MAX_INSTALLMENTS) {
    throw new IllegalArgumentException("Too many installments");
}
double surcharge = amount * SURCHARGE_RATE;
```

### 6. Data Validation

**• Early Validation:** Validate input data (amounts, installments, non-null objects) as early as possible, ideally in a private helper method to keep the main logic clean and readable.

**• Fail Fast:** Detect and report errors as soon as possible rather than allowing invalid state to propagate.

### 7. Iterative Design

**• UML and Code as a Cycle:** UML modeling and coding should be seen as a back-and-forth process, not linear. Design decisions can evolve as you progress in the code, and the UML should reflect those changes.

**• Refactor Continuously:** Don't be afraid to refactor as you learn more about the domain and the problem you're solving.

## Summary

These best practices aim to build software systems that are robust, flexible, easy to understand, and maintain over time, distributing responsibilities logically among objects.

### Key Takeaways

1. **Prefer Usage Dependency** over Creation Dependency when possible (lower coupling, easier testing)
2. **Tell, Don't Ask** - delegate behavior to objects rather than extracting data
3. **Validate early** and fail fast
4. **Use constants** for fixed values
5. **Modularize logic** into small, focused methods
6. **Maintain low coupling and high cohesion**
7. **Depend on abstractions** (interfaces) rather than concrete implementations
8. **Design iteratively** - improve as you learn

By following these principles, you create code that is not only functional but also maintainable, testable, and adaptable to changing requirements.
