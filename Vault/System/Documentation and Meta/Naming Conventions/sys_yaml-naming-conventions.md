YAML Field Standards

All YAML fields should follow `snake_case`, ordered logically from identity → structure → metadata → relationships.

### ✅ Common Fields

```yaml
id: qst_example-id
title: "Descriptive Title Here"
type: quest
version: 1.0
status: active
priority: medium
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: []
aliases: []
summary: >
  One-line description.
related: []
```