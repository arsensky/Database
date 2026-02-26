# Database Design Basics — Summary

## Entity-Relationship Modeling
Visually represent DB structure before implementation.
- **Entity** → table (e.g. Student, Course)
- **Attribute** → column (e.g. Name, Email); can be simple, composite, derived, or key
- **Relationship** → how entities connect (1:M, M:M)

## Normalization
Reduces redundancy and improves data integrity.
- **1NF** — atomic values, no repeating groups, unique rows
- **2NF** — 1NF + no partial dependencies on composite PK
- **3NF** — 2NF + no transitive dependencies between non-key attributes

## Design Process
1. **Requirements Analysis** — what data, who uses it
2. **Conceptual Design** — high-level ER diagram
3. **Logical Design** — tables, keys, normalization, data types
4. **Physical Design** — indexes, partitioning, backup

## Finding Entities & Attributes
- Entities → look for **nouns** in requirements
- Attributes → ask *"what do we need to store about this entity?"*

## Example: Library System
Entities: `Book`, `Author`, `Member`, `Loan`
- Author ↔ Book: M:M
- Member → Loan → Book: 1:M