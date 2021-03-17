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
    ~&  >  (action jon)
    (action jon)
    |%
    ++  action
      %-  of
      :~  [%bid-item-json (ot :~(['email' so] ['exhibit-id' ni] ['bid-amt' so]))]
          [%add-bidder (ot :~(['email' so] ['nick' so]))]
      ==
    --
  --
--