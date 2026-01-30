# ContextoForJava

An **experimental**, modular, rule-based context generator for Java/Spring Boot projects, designed to help AI Agents understand your project's architecture and conventions.

## Features
- **Auto-Detection**: Scans your project to find the base package.
- **Modular Templates**: Easy to customize rules for API, Persistence, Service, and Domain layers.
- **Role-Based Context**: Activates specialized personas like "Spring Architect" or "Performance Expert".
- **Standardized**: Enforces 12-Factor App principles and industry best practices.

## Installation & Usage

1.  Clone this repository or copy the files to your machine.
2.  Navigate to your target Java project.
3.  Run the initialization script:

```bash
/path/to/ContextoForJava/bin/contexto-init.sh
```

4.  Follow the interactive prompts to generate the `AGENTS.md` map and layer-specific rule files.

## Directory Structure

```plaintext
ContextoForJava/
├── .github/          # CI and Templates
├── bin/              # Executable scripts
├── templates/        # The "Gold Standard" rules
│   ├── java/         # Java layer-specific rules
│   └── roles/        # Persona-based context
├── examples/         # Sample project structure
└── README.md
```

## Contributing
We welcome contributions! Please see `.github/ISSUE_TEMPLATE` for how to report bugs or suggest new rules.
