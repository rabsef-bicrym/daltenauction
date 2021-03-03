::
::  daltenauction sur file
::
|%

+$  action
  $%
  [%add-item =exhibit]
  [%bid-item email=@tU exhibit-id=@ud bid-amt=@rh]
  [%add-bidder email=@tU nick=@tU]
  [%start-over check=?]
  [%allow-bidding ~]
  [%produce-test-json ~]
  ==
+$  bids          (map id=@ud [bidder-id=@ud email=@tU bid=@rh])
+$  current-bids  (map =exhibit =bids)
+$  exhibits      (map id=@ud [=exhibit top-bid=@rh top-bidder=@tU])
+$  biddermap     (map id=@ud [email=@tU nick=@tU])
+$  exhibit       [title=@tU img=@tU min-bid=@rh =currency]
+$  currency      ?(%eth %bsv %raven)
--