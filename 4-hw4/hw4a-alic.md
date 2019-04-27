% Artificial Intelligence \
 Homework 4, Part A
% Alic Szecsei
% March 29, 2019

# Domain Modeling in First-Order Logic

1.  Do Problem 8.9 from the textbook. Report just the question number and for each alternative in the question your classification.

    Example:

    ```
    f. (i) - (2)
    (ii) - (1)
    (iii) - (3)
    (iv) - (1)
    ```

2.  For this problem and the next you should use only the relation and function symbols in Figure 1. _Do not use your own symbols._

    (a) Translate each of the following FOL sentences in _good, natural_ English (they should have no $x$'s or $y$'s). Note that, for readability, square brackets are also used as parentheses.

        i. $\forall x [Person(x) \Rightarrow \exists y (Person(y) \wedge Needs(x,y))]$
        ii. $\forall x [Loves(Mary,x) \Rightarrow Loves(John,x)]$
        iii. $\forall x [Person(x) \Rightarrow \exists y (Has(x,y) \wedge Heart(y))]$
        iv. $\forall x [Person(x) \Rightarrow \exists y \exists z (Parent(x,y) \wedge Parent(x,z) \wedge \neg(y = z))]$
        v. $\forall s [(Student(s) \wedge Likes(s, AI)) \Rightarrow Likes(s, CS4420)]$
        vi. $\neg [\exists x \forall y (Person(y) \Rightarrow Likes(y,x))]$
        vii. $\exists x \exists y [Bug(x) \wedge Program(y) \wedge Wrote(John, y) \wedge In(x,y)]$
        viii. $\neg \exists y Needs(Mary, y)$
        ix. $\forall x Parent(x, mother(x))$
        x. $\neg \forall x (Person(x) \Rightarrow Knows(x, mother(x)))$

    (b) Translate each of the following English statements to FOL. Use only logical symbols from the set $\{\forall, \exists, \wedge, \vee, \neg, \Rightarrow, \Leftrightarrow, =\}$. You can use the constant symbols $Fred$, $Jane$, $France$, $Louvre$, with the expected meaning.

        Make sure you use parentheses to avoid ambiguous readings of your sentences.

        i. Students love museums.
        ii. Not every student likes a good museum.
        iii. Some Americans like wines from France.
        iv. Americans who dislike wines from France dislike American wines.
        v. Jane visited all the museums in France except the Louvre.
        vi. Fred knows any museum visited by Jane.
        vii. Everyone knows someone from France.
        viii. Fred likes all kinds of wine.
        ix. Fred only drinks wine.
        x. Everybody has exactly two parents.
        xi. Not everyone knows someone with a French mother.
        xii. Those who know Jane's mother love her.
        xiii. You cannot dislike people you love.
        xiv. Jane only loves people with a good heart.
        xv. No one has something that everybody wants.

| Predicate        | Intended Meaning              |
| :--------------- | :---------------------------- |
| American(x)      | x is American                 |
| Bug(x)           | x is a (software) bug         |
| Class(x)         | x is a class                  |
| Drinks(x,y)      | x drinks y                    |
| From(x,y)        | x is from y                   |
| Good(x)          | x is good                     |
| Grandparent(x,y) | y is a grandparent of x       |
| Has(x,y)         | x has y                       |
| Heart(x)         | x is a heart                  |
| In(x,y)          | x is in y                     |
| Knows(x,y)       | x knows y                     |
| Likes(x,y)       | x likes y                     |
| Loves(x,y)       | x loves y                     |
| Museum(x)        | x is a museum                 |
| Needs(x,y)       | x needs y                     |
| Parent(x,y)      | y is a biological parent of x |
| Person(x)        | x is a person                 |
| Program(x)       | x is a program                |
| Student(x)       | x is a student                |
| Teaches(x,y)     | x teaches y                   |
| Tease(x,y,z)     | x teases y at time z          |
| Time(x)          | x is a time                   |
| Visited(x,y)     | x visited y                   |
| Wants(x,y)       | x wants y                     |
| Wine(x)          | x is a kind of wine           |
| Wrote(x,y)       | x wrote y                     |

| Function  | Intended Meaning           |
| :-------- | :------------------------- |
| mother(x) | the biological mother of x |

## Solution

1.  Problem 1
    (a) Paris and Marseilles are both in France.

         i. 2
         ii. 1
         iii. 3

    (b) There is a country that borders both Iraq and Pakistan.

         i. 1
         ii. 3
         iii. 2
         iv. 2

    (c) All countries that border Ecuador are in South America.

        i. 1
        ii. 1
        iii. 3
        iv. 3

    (d) No region in South America borders any region in Europe.

        i. 1
        ii. 1
        iii. 3
        iv. 1

    (e) No two adjacent countries have the same map color.

        i. 3
        ii. 1
        iii. 3
        iv. 2

2.  Problem 2

    (a) Part A

        i. Everyone needs someone.
        ii. Everyone who loves Mary loves John.
        iii. Everyone has a heart.
        iv. Everyone has at least two separate parents.
        v. Students who like AI like CS4420.
        vi. Nothing is liked by everybody.
        vii. John has written a bug in a program.
        viii. Mary needs nothing.
        ix. A mother is always a parent.
        x. Not everyone knows their mother.

    (b) Part B

        i. $\forall s \forall m [Student(s) \wedge Museum(m) \Rightarrow Loves(s, m)]$
        ii. $\neg \forall s \exists m [Student(s) \wedge Museum(m) \wedge Good(m) \wedge Likes(s, m)]$
        iii. $\exists p \forall w [Person(p) \wedge American(p) \wedge Wine(w) \wedge From(w, France) \Rightarrow Likes(p, w)]$
        iv. $\forall a \forall w1 [(\exists w2 (Person(a) \wedge American(a) \wedge Wine(w2) \wedge From(w2, France)) \wedge American(w1)) \Rightarrow \neg Likes(w1)]$
        v. $[forall m (Museum(m) \wedge \neg m = Louvre \Rightarrow Visited(Jane, m))] \wedge \neg Visited(Jane, Louvre)$
        vi. $\forall m (Museum(m) \wedge Visited(Jane, m) \Rightarrow Knows(Fred, m))$
        vii. $\forall p1 (Person(p1) \Rightarrow \exists p2 (Person(p2) \wedge From(p2, France)))$
        viii. $\forall w (Wine(w) \Rightarrow Likes(Fred, w))$
        ix. $\forall d (\neg Wine(d) \Rightarrow \neg Drinks(Fred, w))$
        x. $\forall p [Person(p) \Rightarrow \exists p1 \exists p2 \neg \exists p3 Parent(p, p1) \wedge Parent(p, p2) \wedge Parent(p, p3)]$
        xi. $\neg \forall p1 \exists p2 [Knows(p1, p2) \wedge From(mother(p2), France)]$
        xii. $\forall p [Knows(p, mother(Jane)) \Rightarrow Loves(p, mother(Jane))]$
        xiii. $\forall p1 \forall p2 \neg [Loves(p1, p2) \Rightarrow \neg Likes(p1, p2)]$
        xiv. $\forall p [Loves(Jane, p) \Rightarrow \exists h Heart(h) \wedge Good(h) \wedge Has(p, h)]$
        xv. $\neg \forall p1 \exists obj \forall p2 [Has(p1, obj) \wedge Wants(p2, obj)]$

# Validity and Entailment in FOL with equality

For the problems below it is helpful to recall that all interpretations in FOL are assumed to have a non-empty domain.

1. For each FOL sentence below say whether it is valid or not and _briefly explain why_. Specifically, for each valid sentence argue informally but precisely why every possible interpretation makes the sentence true; for each invalid sentence describe an interpretation that makes the sentence fale.

   (a) $\forall x \forall y (x = y \Rightarrow y = x)$
   (b) $\forall x \forall y [(x < y) \Rightarrow \neg (x = y)]$
   (c) $\exists x \exists y x = y$
   (d) $\forall x \exists y \neg (x = y)$
   (e) $(\forall x P(x)) \Rightarrow \exists y P(y)$
   (f) $(\exists x P(x)) \Rightarrow \forall y P(y)$
   (g) $(\forall x P(x)) \Rightarrow P(f(g(a,b)))$

2. Optional, extra credit

   Let $\Gamma$ be the knowledge base $\{Married(Jim, Laura), \neg (Jim = George)\}$ and let $\alpha$ be the sentence $\neg Married(George, Laura)$.

   (a) Argue informally but convincingly that $\Gamma$ does not entail $\alpha$.
   (b) Provide enough FOL sentences that when added to $\Gamma$ ensure that $\Gamma \models \alpha$.

## Solution

1.  Problem 1

    (a) True - equality is commutative, so for all x and y, if equality works in one direction it also works in the other.
    (b) True - if x equals y it cannot be strictly less than y, so the implication holds.
    (c) True - if you select an object once, you can select it again, and everything is equal to itself.
    (d) False - if your domain is {0}, then you cannot select any element not equal to 0.
    (e) True - if a predicate is true for all domain elements, then it's true for at least one domain element.
    (f) False - If P(x) is "x > 0" and the domain is {-1, 1} then let x be 1 and y be -1.
    (g) False - if P(x) is "x < 0", the domain is {-1}, $f(x) = x + 1$ and $g(x,y) = x - y$ then $f(g(a,b)) = 1$ and $P(f(g(a,b)))$ is false.

2.  Problem 2

    (a) We don't know that marriage to one person precludes marriage to another (i.e. polygamy can be possible). Thus, Jim and Laura can be married at the same time as George and Laura without Jim and George being the same person.
    (b) $Married(x,y) \wedge \neg (x = z) \Rightarrow \neg Married(z, y)$
