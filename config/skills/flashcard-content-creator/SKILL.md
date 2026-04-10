---
name: flashcard-content-creator
description: Create high-quality flashcards from notes, books, lectures, docs, or transcripts. Use whenever user asks to make/improve flashcards.
---

# Flashcard Content Creator

Goal: generate high-retention flashcard content.

## How (process)

1) Extract meaning first
- Identify claims, mechanisms, conditions, contrasts, and key numbers.
- If meaning is unclear, ask for missing context before generating cards.

2) Build dependency order
- Output foundation cards first.
- Then detail cards that depend on foundations.

3) Generate atomic cards
- One card = one retrieval target.
- Split any card with multiple facts in answer.

4) Use precise cues
- Prefer Why/How/When when possible.
- Use What for direct labels/facts.
- Add disambiguators for confusable items (context, comparator, boundary).

5) Keep answer minimal
- Short, exact expected answer.
- No paragraph answers unless unavoidable.
- However if a question requires a list of items (e.g., "what are three ..."), keep them together in a single card. Use bullet points

6) Prioritize high-yield content
- Keep: prerequisite, frequently used, error-prone, decision-critical.
- Drop/defer: trivial, decorative, unclear.

7) Validate each card
- Unambiguous
- Fast to answer
- Understandable months later
- Not duplicated unless intentional

## Obsidian Spaced Repetition formatting (when user asks for plugin-ready cards)

Use default separators unless user says otherwise.
Always assign deck in note (tag or folder-based deck setup). Safe default: top line tag.

Deck tag example:
```md
#flashcards/test-plugin-cards
```

Card types + exact syntax:

1) Basic (1 card)
- Format: question block, then `?`, then answer block
- No blank lines around `?`
- Example:
```md
Name two layers of the atmosphere
and one trait of each
?
Troposphere: weather occurs
Stratosphere: ozone layer
```

Image in answer:
```md
What does a slotted-page B-Tree node look like?
?
![[Pasted image 20241128153231.png]]
```

2) Bidirectional (2 sibling cards)
- Format: block A, then `??`, then block B
- No blank lines around `??`
- Example:
```md
TCP
Reliable, ordered delivery
??
UDP
Low-latency, no delivery guarantees
```

3) Cloze (1+ cards based on deletions)
- Standalone text with deletions marked by `==...==`. No `?` or `??` separator.
- Single deletion = 1 card:
```md
The first female prime minister of Australia was ==Julia Gillard==
```
- Multiple deletions = sibling cards. Each card hides one deletion while showing the others. Only use when the visible answers don't spoil the hidden one.
- Grouped deletions = one card with all grouped blanks hidden together. Same sequence number (`==[123;;]answer==`) groups them. Use when seeing one answer would give away the other:
```md
In bloom filters, false ==1;;positives== are possible but not false ==1;;negatives==.
```
- Optional hint: `==1;;answer;;hint==` or `==answer;;hint==`
- Do not mix grouped and ungrouped cloze in the same note.

Card separation:
- Use `---` between cards.
- A blank line ends the card block. Do not put blank lines between `?`/`??` and the question/answer content.
- Example:
```md
#flashcards/test

---

Question one?
?
- Answer bullet one.
- Answer bullet two.

---

Question two?
?
Single line answer.
```
