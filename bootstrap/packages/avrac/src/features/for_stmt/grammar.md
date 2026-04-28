## For Statement

```ebnf
for_stmt  ::= "for" IDENTIFIER "in" expr ".." expr block
```

The loop variable is scoped to the body, incremented by 1 each
iteration, and the range is half-open (start inclusive, end exclusive).
