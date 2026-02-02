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

#### Criteria for Determining Necessary vs Unnecessary Getters and Setters

Understanding when to expose getters and setters is crucial for maintaining proper encapsulation. Follow these criteria:

##### Criteria for Unnecessary Setters

**Natural Immutability**
- **Unique identifiers**: IMEI, ID numbers, serial numbers
- **Fixed physical characteristics**: brand, model, hardware specifications
- **Data that doesn't change by the nature of the object**

**Data Integrity**
- **Attributes critical for system consistency**
- **Values that could break relationships between objects if changed**
- **Information that must remain constant during the lifecycle**

**Example:**
```java
public class Phone {
    private final String imei;  // No setter - immutable identifier
    private final String brand; // No setter - fixed characteristic
    private String ownerName;   // Setter OK - can change ownership
    
    public Phone(String imei, String brand) {
        this.imei = imei;
        this.brand = brand;
    }
    
    // Getter for immutable data is OK
    public String getImei() { return imei; }
    
    // Setter for mutable data
    public void setOwnerName(String ownerName) { 
        this.ownerName = ownerName; 
    }
}
```

##### Criteria for Unnecessary Getters

**Strict Encapsulation**
- **Internal data that doesn't need external exposure**
- **Technical information used only by the class itself**
- **Attributes that are not part of the necessary public interface**

**Single Responsibility Principle**
- **Data that is not the responsibility of other classes to know**
- **Information that breaks abstraction if exposed**

**Example:**
```java
public class BankAccount {
    private double balance;
    private List<Transaction> transactionLog; // Internal detail
    
    // ❌ Don't expose internal collection
    // public List<Transaction> getTransactionLog() { ... }
    
    // ✅ Expose behavior instead
    public int getTransactionCount() {
        return transactionLog.size();
    }
    
    public Transaction getLastTransaction() {
        return transactionLog.isEmpty() ? null : 
               transactionLog.get(transactionLog.size() - 1);
    }
}
```

##### Criteria for Maintaining Getters/Setters

**Essential Functionality**
- **Data necessary for business logic**
- **Information required by other collaborating classes**
- **Attributes that participate in system operations**

**Model Flexibility**
- **Values that can legitimately change** (e.g., username)
- **States that evolve during execution**
- **Modifiable object configurations**

**Example:**
```java
public class UserProfile {
    private String email;        // Getter/Setter - can change
    private String displayName;  // Getter/Setter - can change
    private LocalDate registrationDate; // Getter only - shouldn't change
    
    // Legitimate getters/setters for mutable data
    public String getEmail() { return email; }
    public void setEmail(String email) { 
        validateEmail(email);
        this.email = email; 
    }
    
    public String getDisplayName() { return displayName; }
    public void setDisplayName(String displayName) { 
        this.displayName = displayName; 
    }
    
    // Getter only for immutable data
    public LocalDate getRegistrationDate() { 
        return registrationDate; 
    }
}
```

**Fundamental Principle:** Only expose what truly needs to be accessible or modifiable from the outside, maintaining encapsulation and data model integrity.

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

## Implementing 1-to-1 Relationships in OOP

Understanding how to properly implement different types of 1-to-1 relationships is crucial for creating well-structured object-oriented systems.

### Types of Relationships to Implement

#### Composition

**• Definition:** A class "contains" and is responsible for the lifecycle of another class

**• UML:** Filled diamond ◆—→

**• Implementation:** The container object creates the contained object in its constructor

**• Example:** `Passport → Photo` (the passport creates and manages the photo)

#### Bidirectional Association

**• Definition:** Both classes know each other mutually

**• UML:** Arrows on both ends ←—→

**• Implementation:** Both classes have a reference to each other + methods that maintain consistency

**• Example:** `Passport ↔ Owner` (navigation in both directions)

### Design Principles for Relationships

#### 1. Respect the Relationship Structure

```java
// ✅ Correct: Respect specified relationships
owner.getPassport().getPhoto()  // Owner → Passport → Photo

// ❌ Incorrect: Create direct relationships not specified  
owner.getPhoto()  // Direct relationship Owner → Photo (doesn't exist)
```

#### 2. Tell, Don't Ask (Applied to Relationships)

```java
// ❌ Violation: Chain of getters (Ask, Ask, Ask)
System.out.println("Photo: " + owner.getPassport().getPhoto().getImage());

// ✅ Correct application: Delegate behavior
owner.showCompleteInformation();  // Tell
```

#### 3. Bidirectional Consistency

```java
public void setPassport(Passport passport) {
    this.passport = passport;
    // ✅ Maintain consistency automatically
    if (passport != null && passport.getOwner() != this) {
        passport.setOwner(this);
    }
}
```

### Implementation Criteria

#### Composition (Container Class)

**Requirements:**
1. **Constructor:** Must create the contained object
2. **Getter:** Provide access to the contained object
3. **Behavior:** Methods that delegate operations to the contained object
4. **No Setter:** The contained object should not be replaceable externally

**Example:**
```java
public class Passport {
    private String number;
    private String issueDate;
    private Photo photo;  // Composition
    
    // ✅ Create the contained object in the constructor
    public Passport(String number, String issueDate, String image, String format) {
        this.number = number;
        this.issueDate = issueDate;
        this.photo = new Photo(image, format);  // Composition
    }
    
    // ✅ Getter for access (if needed)
    public Photo getPhoto() {
        return photo;
    }
    
    // ✅ Behavior instead of just getters
    public void showPhotoInformation() {
        System.out.println("Photo: " + photo.getImage() + " (" + photo.getFormat() + ")");
    }
    
    // ❌ NO setter - the photo is created with the passport
    // public void setPhoto(Photo photo) { ... }  // Don't do this!
}
```

#### Bidirectional Association

**Requirements:**
1. **Attributes:** Both classes have a reference to each other
2. **Setters:** Methods that maintain bidirectionality automatically
3. **Getters:** Access to the reference
4. **Behavior:** Methods that use the relationship without exposing internal navigation

**Example:**
```java
public class Owner {
    private String name;
    private String idNumber;
    private Passport passport;  // Bidirectional association
    
    public Owner(String name, String idNumber) {
        this.name = name;
        this.idNumber = idNumber;
    }
    
    // ✅ Setter that maintains bidirectionality
    public void setPassport(Passport passport) {
        this.passport = passport;
        if (passport != null && passport.getOwner() != this) {
            passport.setOwner(this);
        }
    }
    
    // ✅ Getter for access
    public Passport getPassport() {
        return passport;
    }
    
    // ✅ Behavior that encapsulates navigation
    public void showCompleteInformation() {
        System.out.println("Owner: " + name + " - ID: " + idNumber);
        if (passport != null) {
            passport.showPhotoInformation();
        }
    }
}

public class Passport {
    private String number;
    private String issueDate;
    private Owner owner;  // Bidirectional association
    private Photo photo;
    
    public Passport(String number, String issueDate, String image, String format) {
        this.number = number;
        this.issueDate = issueDate;
        this.photo = new Photo(image, format);
    }
    
    // ✅ Setter that maintains bidirectionality
    public void setOwner(Owner owner) {
        this.owner = owner;
        if (owner != null && owner.getPassport() != this) {
            owner.setPassport(this);
        }
    }
    
    // ✅ Getter for access
    public Owner getOwner() {
        return owner;
    }
}
```

#### Contained Class (in Composition)

**Requirements:**
1. **Simplicity:** Only manages its own state
2. **No external references:** Doesn't know its container
3. **Basic Getters/Setters:** For its own state only

**Example:**
```java
public class Photo {
    private String image;
    private String format;
    
    // ✅ Only manages its own state
    public Photo(String image, String format) {
        this.image = image;
        this.format = format;
    }
    
    // Basic getters/setters
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    
    public String getFormat() { return format; }
    public void setFormat(String format) { this.format = format; }
}
```

### Best Practices for Main/Client Code

#### Avoid Encapsulation Violations

```java
// ❌ Avoid getter chains
String photoImage = owner.getPassport().getPhoto().getImage();

// ✅ Use behavior
owner.showCompleteInformation();
```

#### Verify Relationship Integrity

```java
// ✅ Verify bidirectionality
boolean isBidirectional = (passport.getOwner() == owner && owner.getPassport() == passport);
System.out.println("Bidirectionality correct? " + (isBidirectional ? "✅ YES" : "❌ NO"));
```

### UML Diagram Criteria

#### Correct Symbols

- **Composition:** ◆—→ (filled diamond, directional arrow)
- **Bidirectional:** ←—→ (arrows on both ends)
- **Multiplicity:** 1:1 on both ends

#### Methods to Include

- **Constructors:** With appropriate parameters for each relationship type
- **Getters/Setters:** For associations
- **Behavior:** Methods that encapsulate navigation logic

### Implementation Checklist

#### ✅ Structure

- [ ] Composition implemented correctly (object created in constructor)
- [ ] Bidirectionality implemented and maintained automatically
- [ ] No direct relationships not specified in the design

#### ✅ Behavior

- [ ] Methods that implement "Tell, Don't Ask"
- [ ] Encapsulation of navigation between objects
- [ ] Bidirectionality verification in Main/tests

#### ✅ UML Diagram

- [ ] Correct symbols (◆ for composition, ←→ for bidirectional)
- [ ] Behavior methods included
- [ ] Constructors updated according to relationships

**Guiding Principle:** Maintain the integrity of specified relationships while applying OOP best practices.

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
