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
    (action jon)
    |%
    ++  action
      %-  of
      :~  [%add-item ni]
      ==
    --
  --
--