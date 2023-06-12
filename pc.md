---
title: "Product checker"
author: Joseph Yap
shortauthor: J. Yap
date: ...
<!-- institute: <++> -->
instituteshorthand: <++>
toc: false
header-includes:
  - \renewenvironment{quote}{\begin{center}}{\end{center}}
output:
  beamer_presentation:
    toc: false
    keep_tex: true
    slide_level: 1
    theme: "templates/amsterdam.beamer"
    highlight: tango
...

# Most recent project I have worked on

## Product checker

- compares the result of a sequence of user-specified reactions against a given product
- warns if any chiral centres are set incorrectly, due to implications in pharmacological activity

# Product checker

![Single step example: Grignard addition with cyclisation](./pc_rxn)

<!-- # Product checker -->

. . .

```
rxn smiles:
CC(C)=Cc1ncccc1C(=O)N1CCOCC1.CC[Mg]Br
    >>CC(C)Cc1ncccc1C1(N2CCOCC2)CC1
rxn smarts:
Br[Mg][CH2:1][C:2].O=[C:3]([#7:4])[*:5]
    >>[#7:4][C:3]1([*:5])[C:2][CH2:1]1
```

<!-- smarts from template -->

# Product checker

For each reaction:

1. SMARTS LHS = SMILES LHS (mol count)
   - convert strings to RDKit objects (`str` &rarr; `list[Chem.Mol]`)

```
assert 'A.B'.count('.') == 'a.b'.count('.')
rxn smiles: 'A.B>>C' -MolFromSmiles-> [*A, *B], [*C]
rxn smarts: 'a.b>>c' -MolFromSmarts-> [*a, *b], [*c]
```

<!-- assert len([*A, *B]) == len([*a, *b]) -->

<!-- edge case: component grouping (a.b) -->

. . .

2. each rct SMARTS only matches a single mol

```
GetSubstructMatches
[*A <-- *a] [*A </- *b]
[*B <-- *b] [*B </- *a]
```

. . .

3. each rct SMARTS only matches _within_ a mol exactly once

```
assert *A.GetSubstructMatches(*a).count() == 1
assert *B.GetSubstructMatches(*b).count() == 1
```

# Product checker

![rxn smarts: `a.b>>c`](./pc_rxn)

1. SMARTS LHS = SMILES LHS (mol count)
2. each rct SMARTS only matches a single mol
3. each rct SMARTS only matches _within_ a mol exactly once

# Product checker

4. rxn leads to some valid product

```
prods = r.RxnFromSmarts('a.b>>c').RunReactants([*A, *B])
assert prods is not None
```

5. only 1 product obtained

```
assert len(flatten(prods)) == 1
```

6. product matches example

```
assert prod == *C
assert to_smiles(prod) == to_smiles(*C)
```

##

Repeat for multiple steps (a sequence), then multiple sequences...
