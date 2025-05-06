Welcome to the **Lessons** hub of the Learning System!  
Here you’ll find structured content designed to build mastery across your Skill Trees.

Lessons are your **knowledge foundation**.  
Each lesson provides clear explanations, examples, and actionable knowledge — followed by a quiz and quest recommendations to turn theory into practice.

## 📚 Lessons Catalog

Check out the [[📚 Lessons Catalog]]. 

## 🔎 How Lessons Work

```plaintext

[ Lesson ] 
   ↓
[ Micro-Quiz ] → Earn Nuggets for correct answers
   ↓
[ Quest Suggestions ] → Apply learning and earn more Nuggets

```

## 🗂 Lesson Structure

Each lesson contains:

1. **Topic Overview**
    - Clear explanation of the concept or skill.
    - Real-world context and relevance.
    
2. **Examples**
    - Demonstrations and best practices.
    
3. **Micro-Quiz**
    - Short multiple-choice quiz.
    - Earn 1 Skill Nugget per correct answer.
    
4. **Recommended Quests**
    - Linked quests.
    - Apply learning in practical challenges.
    
5. **Related Skill Trees & Nugget Types**
    - Shows where this knowledge contributes to your growth.

### 🏷️ YAML Property Template for Lessons

```yaml

---
Title: 
Skill_Tree: 
Difficulty: Beginner | Intermediate | Advanced
Estimated_Time: 
Quizzes: []
Quests: []
Status: Draft | Active | Archived
Last_Updated: 
---

```


### ✅ New Lesson Template

```
# 📚 Lessons Catalog

<%*
const today = tp.date.now("YYYY-MM-DD");
%>

---
Title: <% tp.file.title %>
Skill_Tree: 
Difficulty: Beginner | Intermediate | Advanced
Estimated_Time: 
Quizzes: []
Quests: []
Status: Draft
Last_Updated: <%= today %>
---

# 🧑‍🏫 Lesson: <% tp.file.title %>

## 📝 Overview
_(Brief description of what this lesson covers)_

## 🔍 Key Concepts
- 

## ❓ Related Micro-Quizzes
_(Linked quiz files here)_

## 🎯 Related Quests
_(Linked quest files here)_

## 🧠 Notes & References
- 

```