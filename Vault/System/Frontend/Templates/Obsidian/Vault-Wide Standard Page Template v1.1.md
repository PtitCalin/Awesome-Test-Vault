<%*
const today = tp.date.now("YYYY-MM-DD");
const title = tp.file.title;
const type = await tp.system.suggester(
  ["note", "lesson", "quest", "project", "task", "journal", "template", "meeting-note", "creative-writing-draft"],
  "Choose type"
);
const status = await tp.system.suggester(["draft", "in progress", "complete", "archived"], "Choose status");
const visibility = await tp.system.suggester(["public", "private", "draft-only"], "Choose visibility");
-%>
---

```yaml
# 📄 Identity & Classification
id: <% title.toLowerCase().replaceAll(" ", "-") %>
title: "<% title %>"
aliases: []
type: <% type %>
category: 
tags: []
version: 1.0

# 📊 Status & Lifecycle
status: <% status %>                 # draft, in progress, complete, archived
visibility: <% visibility %>         # public, private, draft-only
created: <% today %>
updated: <% today %>

# 📚 Context & Description
summary: ""

# 🧭 Relationships
parent: ""                           # One parent
children: []                         # Ordered or unordered children
friends: []                          # Related items of similar nature
related: []                          # General related content
```

---

> [!nav] 🧭 Vault Navigation  
> [[🖼 Media Gallery]] • [[🗓 Daily Notes]] • [[📚 Encyclopedia]] • [[📘 Learnings]] • [[🧠 System]]


---

> 🎛 Quick Actions  
> ➕ [New Project Ticket](obsidian://new?name=Projects/New%20Project%20-%20<% tp.file.title %>)  
> 🏹 [New Quest](obsidian://new?name=Quests/New%20Quest%20-%20<% tp.file.title %>)  
> 🎯 [New Task](obsidian://new?name=Tasks/New%20Task%20-%20<% tp.file.title %>)  
> 📅 [Schedule Event](obsidian://new?name=Events/New%20Event%20-%20<% tp.file.title %>)  
> 📝 [Brain Dump](obsidian://new?name=Notes/Brain%20Dump%20-%20<% tp.file.title %>)  
> 📚 [New Lesson](obsidian://new?name=Lessons/New%20Lesson%20-%20<% tp.file.title %>)

---

## ✍️ Content Starts Here

<!-- Add your content below -->







---

## 🔗 Related Notes

> [!info] 🧠 Relationships  
> This note is part of a larger structure. Below are its connections:

```dataview
table
  parent as "Parent",
  children as "Subpages",
  friends as "Friends",
  related as "Related"
from ""
where file.link = this.file.link
