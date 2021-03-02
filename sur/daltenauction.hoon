::
::  daltenauction sur file
::
|%

+$  action
  $%
  [%add-item =exhibit]
  [%bid-item =crypto-add exhibit-id=@ud bid-amt=@rh]
  ::[%add-bidder =crypto-add nick=@tU]
  [%start-over check=?]
  [%allow-bidding ~]
  ==
+$  bids          (map id=@ud [bidder-id=@ud bid-add=crypto-add bid=@rh])
+$  current-bids  (map =exhibit =bids)
+$  exhibits      (map id=@ud [=exhibit top-bid=@rh top-bidder=@tU])
+$  biddermap     (map id=@ud [eth-add=crypto-add bsv-add=crypto-add raven-add=crypto-add nick=@tU])
+$  crypto-add    @tU
+$  exhibit       [title=@tU img=@tU min-bid=@rh =currency]
+$  currency      ?(%eth %bsv %raven)
--