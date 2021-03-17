::
::  daltenauction sur file
::
|%

+$  action
  $%
  [%add-item =exhibit]
  [%bid-item email=@tU exhibit-id=@ud bid-amt=@ud]
  [%bid-item-json email=@tU exhibit-id=@ud bid-amt=@tU]
  [%add-bidder email=@tU nick=@tU]
  [%start-over check=?]
  [%allow-bidding ~]
  [%produce-test-json ~]
  ==
+$  bids          (map id=@ud [bidder-id=@ud email=@tU bid=@ud])
+$  current-bids  (map =exhibit =bids)
+$  exhibits      (map id=@ud [=exhibit top-bid=@ud top-bidder=@tU])
+$  biddermap     (map id=@ud [email=@tU nick=@tU])
+$  exhibit       [title=@tU img=@tU min-bid=@ud artist=@tU uri=@tU =currency]
+$  currency      ?(%eth %bsv %raven)
--