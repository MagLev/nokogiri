# Roadmap for 2.0

## overhaul serialize/pretty printing API

* https://github.com/tenderlove/nokogiri/issues/530
  XHTML formatting can't be turned off

* https://github.com/tenderlove/nokogiri/issues/415
  XML formatting should be no formatting


## overhaul and optimize the SAX parsing

* see fairy wing throwdown - SAX parsing is wicked slow.


## improve CSS query parsing

* https://github.com/tenderlove/nokogiri/issues/528
  support `:not()` with a nontrivial argument, like `:not(div p.c)`

* https://github.com/tenderlove/nokogiri/issues/451
  chained :not pseudoselectors

* better jQuery selector support:
  * https://github.com/tenderlove/nokogiri/issues/621
  * https://github.com/tenderlove/nokogiri/issues/342
  * https://github.com/tenderlove/nokogiri/issues/628

* https://github.com/tenderlove/nokogiri/issues/394
  nth-of-type is wrong, and possibly other selectors as well

* https://github.com/tenderlove/nokogiri/issues/309
  incorrect query being executed

* https://github.com/tenderlove/nokogiri/issues/350
  :has is wrong?


## DocumentFragment

* there are a few tickets about searches not working properly if you
  use or do not use the context node as part of the search.
  - https://github.com/tenderlove/nokogiri/issues/213
  - https://github.com/tenderlove/nokogiri/issues/370
  - https://github.com/tenderlove/nokogiri/issues/454
  - https://github.com/tenderlove/nokogiri/issues/572


## Better Syntax for custom XPath function handler

* https://github.com/tenderlove/nokogiri/pull/464


## Encoding

We have a lot of issues open around encoding. Is this really an issue?
Somebody who knows something about encoding, and cares, should point
this one.


## Reader

It's fundamentally broken, in that we can't stop people from crashing
their application if they want to use object reference unsafely.
