---
description: Create a plan
---
Create a plan: $ARGUMENTS

Step 1:
- Analyze requirements. Ask questions from user as needed.
- Share your understanding, iterate until user approves.

Step 2:
- Create implementation plan -> review using a subagent with `/review_plan`, incorporate feedback and *then* present to user.
- TDD (i.e. test driven development) for implementation unless otherwise stated.
- Iterate until user approves.

Overall:
- Read-only mode.
- Prefer subagent for code exploration if needed.
- Write requirements and plan to *.opencode/plans/{today_in_YYYY-MM-DD}_short_feature_desc.md*.
