# UMLet Diagram Construction Guidelines

This document provides comprehensive instructions for creating UML diagrams using UMLet, ensuring proper syntax, structure, and best practices.

## 1. Base Document Structure

### Mandatory XML Header

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<diagram program="umlet" version="15.1">
  <zoom_level>10</zoom_level>
```

### Document Closing

```xml
</diagram>
```

**Mandatory Rules:**

- Always must open with `<?xml ... ?>` and `<diagram ...>`
- Always must close with `</diagram>`
- Must never be omitted or duplicated

---

## 2. UML Class Definition

### Standard Template

```xml
<element>
  <id>UMLClass</id>
  <coordinates>
    <x>[POS_X]</x>
    <y>[POS_Y]</y>
    <w>[WIDTH]</w>
    <h>[HEIGHT]</h>
  </coordinates>
  <panel_attributes>[CLASS_NAME]
--
[ATTRIBUTES]
--
[METHODS]</panel_attributes>
  <additional_attributes/>
</element>
```

### Syntax Rules

**• Tag `<h>` must always close correctly:** `<h>160</h>`

**• Special characters** (`<`, `>`, `&`) must be escaped:
- `<` → `&lt;`
- `>` → `&gt;`
- `&` → `&amp;`

**• Blocks delimited by `--` are mandatory** for attributes and methods (if no methods, leave empty but keep delimiters)

**• `<additional_attributes/>` is mandatory** in each class, even if empty

### Attribute Rules

**Format:** `[visibility][name]: [type]`

**Visibility:**
- `-` private
- `+` public
- `#` protected

**Example:** `-number: String`

### Method Rules

**Constructors:** `+ClassName()`

**Getters:** `+getName(): String`

**Setters:** `+setName(String): void`

**Custom methods:** `+method(parameters): returnType`

**Complete Example:**

```xml
<element>
  <id>UMLClass</id>
  <coordinates>
    <x>200</x>
    <y>100</y>
    <w>200</w>
    <h>160</h>
  </coordinates>
  <panel_attributes>Passport
--
-number: String
-issueDate: String
-owner: Owner
--
+Passport(String, String)
+getNumber(): String
+setOwner(Owner): void
+showInformation(): void</panel_attributes>
  <additional_attributes/>
</element>
```

---

## 3. Element Positioning

**• Origin `(0,0)`** at top-left corner

**• Standard class size:** 200x160 px

**• Minimum separation:** 100 px horizontal, 80 px vertical

**• Main classes centered**, related classes around them

**Layout Example:**

```
(200,100) - Class A [200x160]
(500,100) - Class B [200x160]  → 100px separation
(350,300) - Class C [200x160]  → 80px vertical separation
```

---

## 4. UML Relationships

### General Template

```xml
<element>
  <id>Relation</id>
  <coordinates>
    <x>[START_X]</x>
    <y>[START_Y]</y>
    <w>[LINE_WIDTH]</w>
    <h>[LINE_HEIGHT]</h>
  </coordinates>
  <panel_attributes>lt=-
m1=[MULT_1]
m2=[MULT_2]</panel_attributes>
  <additional_attributes>[X1];[Y1];[X2];[Y2]</additional_attributes>
</element>
```

### Syntax Rules

**• `<additional_attributes>` must always have valid coordinate pairs**

**• Coordinates must coincide with class borders**

**• Multiplicities (`m1`, `m2`) always defined** at both ends

**• `lt=` defines line type:**
- `-` association
- `<<-` inheritance
- `<<<<-` composition
- `<<<<<-` aggregation

### Relationship Type Examples

#### Simple Association

```xml
<element>
  <id>Relation</id>
  <coordinates>
    <x>400</x>
    <y>150</y>
    <w>120</w>
    <h>30</h>
  </coordinates>
  <panel_attributes>lt=-
m1=1
m2=1</panel_attributes>
  <additional_attributes>10;10;100;10</additional_attributes>
</element>
```

#### Bidirectional Association

```xml
<panel_attributes>lt=-
m1=1
m2=*</panel_attributes>
```

#### Composition (Filled Diamond)

```xml
<panel_attributes>lt=&lt;&lt;&lt;&lt;-
m1=1
m2=1</panel_attributes>
```

#### Inheritance

```xml
<panel_attributes>lt=&lt;&lt;-</panel_attributes>
```

---

## 5. Mandatory Final Validation

Before saving, validate:

1. **Well-formed XML syntax** (all tags correctly closed)
2. **Coordinate coherence** (non-overlapping classes, lines connecting borders)
3. **Escaped characters** (`<`, `>`, `&`)
4. **Unique IDs** (`<id>` not repeated in `<element>`)
5. **Multiplicities defined** in all relationships

### Validation Checklist

- [ ] XML header present and correct
- [ ] All `<element>` tags properly closed
- [ ] All coordinate tags (`<x>`, `<y>`, `<w>`, `<h>`) closed
- [ ] Special characters escaped in class/method names
- [ ] All relationships have `m1` and `m2` multiplicities
- [ ] `<additional_attributes/>` present in all classes
- [ ] `<additional_attributes>` with coordinates in all relations
- [ ] Document closes with `</diagram>`

---

## 6. Best Practices

### Naming Conventions

**• Classes:** PascalCase (`Teacher`, `Course`, `Student`)

**• Attributes:** camelCase (`courseName`, `studentId`)

**• Methods:** camelCase with `()` (`getName()`, `calculateGrade()`)

### Visual Organization

**• Central class:** Main entity of the diagram

**• Related classes:** Positioned around the main class

**• Avoid unnecessary line crossings**

**• Use consistent spacing:** Keep uniform distances between elements

**• Logical flow:** Arrange inheritance hierarchies top-to-bottom, compositions left-to-right

### Code Organization

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<diagram program="umlet" version="15.1">
  <zoom_level>10</zoom_level>
  
  <!-- Main/Central Classes First -->
  <element>
    <id>UMLClass</id>
    <!-- Main class definition -->
  </element>
  
  <!-- Related Classes -->
  <element>
    <id>UMLClass</id>
    <!-- Related class 1 -->
  </element>
  
  <!-- Relationships Last -->
  <element>
    <id>Relation</id>
    <!-- Relationship definition -->
  </element>
  
</diagram>
```

---

## Common Mistakes to Avoid

❌ **Unclosed tags:**
```xml
<h>160  <!-- Missing closing tag -->
```

✅ **Correct:**
```xml
<h>160</h>
```

---

❌ **Unescaped generics:**
```xml
+getList(): List<String>  <!-- < and > not escaped -->
```

✅ **Correct:**
```xml
+getList(): List&lt;String&gt;
```

---

❌ **Missing multiplicities:**
```xml
<panel_attributes>lt=-</panel_attributes>
```

✅ **Correct:**
```xml
<panel_attributes>lt=-
m1=1
m2=*</panel_attributes>
```

---

❌ **Missing additional_attributes in class:**
```xml
<element>
  <id>UMLClass</id>
  <coordinates>...</coordinates>
  <panel_attributes>...</panel_attributes>
</element>
```

✅ **Correct:**
```xml
<element>
  <id>UMLClass</id>
  <coordinates>...</coordinates>
  <panel_attributes>...</panel_attributes>
  <additional_attributes/>
</element>
```

---

## Quick Reference Table

| Element Type | `lt=` Value | Symbol | Usage |
|--------------|-------------|--------|-------|
| Association | `lt=-` | ——— | Simple relationship |
| Bidirectional | `lt=-` with m1, m2 | ←—→ | Mutual reference |
| Composition | `lt=<<<<-` | ◆—→ | Strong ownership |
| Aggregation | `lt=<<<<<-` | ◇—→ | Weak ownership |
| Inheritance | `lt=<<-` | △—— | Is-a relationship |
| Dependency | `lt=<<.` | - - → | Uses temporarily |

---

## Integration with Java Code

When creating UML diagrams that represent Java code:

1. **Match visibility modifiers:**
   - Java `private` → UML `-`
   - Java `public` → UML `+`
   - Java `protected` → UML `#`

2. **Represent relationships accurately:**
   - Field composition → UML composition (◆)
   - Bidirectional references → UML bidirectional (←→)
   - Inheritance → UML inheritance (△)

3. **Include essential methods only:**
   - Constructors (especially those defining relationships)
   - Public API methods
   - Key behavior methods (from Tell, Don't Ask principle)

4. **Omit implementation details:**
   - Private helper methods (unless essential)
   - Auto-generated getters/setters (unless they define API)

By following these guidelines, you ensure that your UMLet diagrams are syntactically correct, visually clear, and accurately represent your Java object-oriented designs.
