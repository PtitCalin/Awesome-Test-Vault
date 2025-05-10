## 1️⃣ Change Log Format

Include a changelog at the **bottom of all versioned pages** in a `## 🔄 Change Log` section.

### ✅ Format
```markdown
## 🔄 Change Log

| Version | Date       | Notes                              |
| ------- | ---------- | ---------------------------------- |
| 1.0     | 2025-05-06 | Initial YAML standard established. |
```

- Use `|`-based Markdown tables
- Log only when `version` in YAML changes
- Newest entries go at the bottom

🛠 *Auto-generating changelog script will:*
- Check `version` field
- Compare with last entry in changelog
- Append entry if version is new