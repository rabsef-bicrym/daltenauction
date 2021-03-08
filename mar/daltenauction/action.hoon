::
::  daltenauction mar file
::
/-  daltenauction
=,  dejs:format
|_  act=action:daltenauction
++  grab
  |%
  ++  noun  action:daltenauction
  ++  json
    |=  jon=^json
    %-  action:daltenauction
    =<
    ~&  >  jon
    ~&  >  (action jon)
    (action jon)
    |%
    ++  action
      %-  of
      :~  [%bid-item (ot :~(['email' so] ['exhibit-id' ni] ['bid-amt' ni]))]
          [%add-bidder (ot :~(['email' so] ['nick' so]))]
      ==
    --
  --
--