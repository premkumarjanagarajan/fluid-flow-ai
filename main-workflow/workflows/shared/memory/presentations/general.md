# AI Rules for Slidev Presentations (sli.dev)

This file provides guidance for AI tools such as Cursor and GitHub
Copilot when generating or editing Slidev presentations.

------------------------------------------------------------------------

# Core Principle

Slides must always fit within the slide viewport.

If content risks overflowing the slide:

-   Split the slide into multiple slides
-   Reduce bullet density
-   Use columns
-   Move extra explanation to speaker notes

Never shrink text excessively just to fit more content.

------------------------------------------------------------------------

# Slide Density Guidelines

Title - Prefer a single line - Maximum approximately 60 characters

Bullet Points - Maximum 5 bullets per slide - Maximum about 10 words per
bullet

Sections - Maximum 3 sections per slide

Code Snippets - Prefer short examples - If code exceeds roughly 12
lines, move it to another slide

------------------------------------------------------------------------

# Layout Patterns

If a slide contains multiple concepts, use columns or split slides.

Recommended flow:

Overview\
Architecture\
Details\
Examples

------------------------------------------------------------------------

# Diagrams

**When diagrams are needed, use Mermaid**.

Example:

``` mermaid
flowchart LR
User --> Frontend
Frontend --> API
API --> Database
```

Guidelines:

-   Prefer horizontal diagrams (LR)
-   Keep node labels short
-   Avoid large complex diagrams on a single slide
-   Break complex systems into multiple diagrams
-   Ensure diagrams remain readable during presentations

------------------------------------------------------------------------

# Speaker Notes

Detailed explanations should go into notes rather than on the slide.

Example:

    note:
    Explain implementation details here.

Slides should contain only the key points the audience needs to see.

------------------------------------------------------------------------

# AI Editing Behaviour

When generating or modifying slides, AI should:

1.  Check whether the slide could overflow
2.  Reduce density if necessary
3.  Split slides when needed
4.  Keep diagrams simple and readable
5.  Prefer clarity over compression

If unsure whether content fits on a slide, create an additional slide.

------------------------------------------------------------------------

# Quick Slide Fit Checklist

Before finalising a slide:

-   No more than about 5 bullets
-   No long paragraphs
-   Diagrams readable at presentation scale
-   Code blocks short
-   Slide readable from the back of a room

If any of these fail, split the slide.