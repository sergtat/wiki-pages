# Примеры комментариев
// Не работает <!-- worked -->
<!-- Работает-->

![Markdown. Пример]( /img/markdown.png 'Markdown. Пример')<!-- Работает-->

# Math example.

The *Gamma function* satisfying \\(\Gamma(n) = (n-1)!\quad\forall n\in\mathbb N\\) is via the Euler integral

$$
\Gamma(z) = \int_0^\infty t^{z-1}e^{-t}dt\,.
$$

$$
\frac{\sqrt {ab}}{c}
$$

[Example](http://meta.math.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference)

An h1 header
============

Paragraphs are separated by a blank line.

2nd paragraph. *Italic*, **bold**, and `monospace`. Itemized lists
look like:

  * this one
  * that one
  * the other one

Note that --- not considering the asterisk --- the actual text
content starts at 4-columns in.

> Block quotes are
> written like so.
>
> They can span multiple paragraphs,
> if you like.

Use 3 dashes for an em-dash. Use 2 dashes for ranges (ex., "it's all
in chapters 12--14"). Three dots ... will be converted to an ellipsis.
Unicode is supported. ☺



An h2 header
------------

Here's a numbered list:

1. first item
2. second item
3. third item

Note again how the actual text starts at 4 columns in (4 characters
from the left side). Here's a code sample:

    # Let me re-iterate ...
    for i in 1 .. 10 { do-something(i) }

As you probably guessed, indented 4 spaces. By the way, instead of
indenting the block, you can use delimited blocks, if you like:

~~~
define foobar() {
    print "Welcome to flavor country!";
}
~~~

(which makes copying & pasting easier). You can optionally mark the
delimited block for Pandoc to syntax highlight it:

~~~python
import time
# Quick, count to ten!
for i in range(10):
    # (but not *too* quick)
    time.sleep(0.5)
    print i
~~~

### An h3 header ###

Now a nested list:

1. First, get these ingredients:

  * carrots
  * celery
  * lentils

2. Boil some water.

3. Dump everything in the pot and follow
this algorithm:

  1. find wooden spoon
  2. uncover pot
  3. stir
  4. cover pot
  5. balance wooden spoon precariously on pot handle
  6. wait 10 minutes
  7. goto first step (or shut off burner when done)


    Do not bump wooden spoon or it will fall.

Notice again how text always lines up on 4-space indents (including
that last line which continues item 3 above).

Here's a link to [a website](http://foo.bar), to a [local
doc](local-doc.html), and to a [section heading in the current
doc](#an-h2-header). Here's a footnote [^1].

[^1]: Footnote text goes here.

Tables can look like this:

| size | material     | color        |
| ---- | ------------ | ------------ |
| 9    | leather      | brown        |
| 10   | hemp canvas  | natural      |
| 11   | glass        | transparent  |

Table: Shoes, their sizes, and what they're made of

(The above is the caption for the table.) Pandoc also supports
multi-line tables:

| keyword | text                                                       |
|---------|------------------------------------------------------------|
| red     | Sunsets, apples, and other red or reddish things.          |
| green   | Leaves, grass, frogs and other things it's not easy being. |

A horizontal rule follows.

***

Here's a definition list:

apples
  : Good for making applesauce.

oranges
  : Citrus!

tomatoes
  : There's no "e" in tomatoe.

Again, text is indented 4 spaces. (Put a blank line between each
term/definition pair to spread things out more.)

    Here's a "line block":

| Line one
|   Line too
| Line tree

and images can be specified like so:

![example image](example-image.jpg "An exemplary image")

Inline math equations go in like so: \\(\omega = d\phi / dt\\). Display
math should get its own line and be put in in double-dollarsigns:

$$I = \int \rho R^{2} dV$$

And note that you can backslash-escape any punctuation characters
which you wish to be displayed literally, ex.: \`foo\`, \*bar\*, etc.

1. Item 1
  1. A corollary to the above item.
  2. Yet another point to consider.
    1. ;k;k
    2. k;lk;
      1. khkhkj
      2. hkjhhk
        1. hjkhkjhk
        2. jkhkjhk
          1. hjkhk
          2. klhkjjh
2. Item 2
  * A corollary that does not need to be ordered.
    * This is indented four spaces, because it's two spaces further than the item above.
    * You might want to consider making a new list.
3. Item 3

- khkjhk
- sdfsf
  - sdfsdf
  - sdf
    - sdfsd
    - dfg
      - sdfsfd
      - sdfd
        - sfsd
        - sdf
          - sdfds
          -
          - asda

## Проверка $ LaTeX $
\\(y=x^2\\)

\\( y = \sin x \\)

\\( 1 = \frac{1}{2} + \frac{1}{4} + \frac{1}{8} + ... \\)

\\( \vec{a} = \frac{\vec{F}}{m} \\)

\\( \sqrt[3]{27} +5+3\\)

\\( 0,5\,м/с^2 \\)

\\( 36\,\text{км} / \text{ч} \\)

\\(F_{Арх.} = \rho {g} V \\)

\\({F}_{Арх.}\\)

\\(\rm{Н} = \frac{\rm{кг}}{\rm{м}\cdot\rm{с}^2}\\)

В MathJax формулы \\(\frac{1}{1+\frac{1}{1+\frac{1}{2}}}\\) всегда правильно выравниваются в строке.

Буквы в MathJax, например, \\(x\\) и \\( \alpha \\) всегда такого же размера, как и окружающий их текст.

\\({1 \mathord{\left/ {\vphantom {1 2}} \right . -} 2}\\)

\\( \arctg \varphi \\)

\\( \EDS\\)

\\( \phi = 45 \degree \\)

\\( 36\celsius \\)

$$ \left( {\begin{array}{lllllllllllllll}2&\vline& 3&\vline& 4\\\hline8&\vline& 7&\vline& 9\\\hline5&\vline& 6&\vline& 8\end{array}} \right) $$

\\( a \le b \\)

\\( b \ge a \\)

\\(\ln \left( {{{\rm arc}} tgx} \right) + C\\)

$$ 5^7 2_6 $$
