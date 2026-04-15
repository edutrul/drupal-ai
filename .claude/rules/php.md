# PHP Rules

- New concrete classes: prefer `final` (skip if abstract, inheritance-intended, or project style differs).
- Properties: `private` by default; `protected` only for inheritable classes; no `public` properties.
- Prefer `readonly` for injected dependencies; use constructor injection.
- Prefer clear typing, encapsulation, and immutability.
