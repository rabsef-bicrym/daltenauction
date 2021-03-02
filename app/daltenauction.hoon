/-  daltenauction
/+  *server, default-agent, dbug
|%
+$  versioned-state
    $%  state-zero
    ==
+$  state-zero
    $:  %0
    exhibits=exhibits:daltenauction
    current-bids=current-bids:daltenauction
    biddermap=biddermap:daltenauction
    allow-bidding=?
    ==
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-zero
=*  state  -
^-  agent:gall
=<
|_  =bowl:gall
+*  this   .
    def    ~(. (default-agent this %|) bowl)
    hc  ~(. +> bowl)
++  on-init
  ^-  (quip card _this)
  ~&  >  '%daltenauction app is online'
  =.  state  [%0 `exhibits:daltenauction`~ `current-bids:daltenauction`~ `biddermap:daltenauction`(my :~([0 ['0x0' '0x0' '0x0' '~dalten Collection']])) %.n]
  `this
++  on-save
  ^-  vase 
  !>(state)
++  on-load
  |=  incoming-state=vase
  ^-  (quip card _this)
  ~&  >  '%daltenauction has recompiled'
  `this(state !<(versioned-state incoming-state))
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  =^  cards  state
  ?+  mark  (on-poke:def mark vase)
    %daltenauction-action  (poke-actions !<(action:daltenauction vase))
  ==
  [cards this]
  ::
  ++  poke-actions
    |=  =action:daltenauction
    ^-  (quip card _state)
    =^  cards  state
    ?-  -.action
      %add-item
    (add-item:hc exhibit.action)
      %bid-item
    (bid-item:hc crypto-add.action exhibit-id.action bid-amt.action)
      %start-over
    ?.  check.action
      `state
    `state(exhibits ~, current-bids ~, biddermap `biddermap:daltenauction`(my :~([0 ['0x0' '0x0' '0x0' '~dalten Collection']])), allow-bidding %.n)
      %allow-bidding
    `state(allow-bidding %.y)
    ==
    [cards state]
--
++  on-watch  on-watch:def
++  on-arvo   on-arvo:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-fail   on-fail:def
--
|_  bol=bowl:gall
++  add-item
  |=  [inc-ex=exhibit:daltenauction]
  ^-  (quip card _state)
  |^
  ?:  =(~ exhibits)
    :-  ~
    %=  state
    exhibits      (~(put by exhibits) 0 [inc-ex min-bid.inc-ex '~dalten Collection'])
    current-bids  (~(put by current-bids) inc-ex `bids:daltenauction`(my :~([0 [0 '0x0' min-bid.inc-ex]])))
    ==
  =/  list-exhibits=(list exhibit:daltenauction)  (roll ~(tap by exhibits) extractor)
  =/  next-ex=@ud  +(i:-:(sort `(list @ud)`~(tap in ~(key by exhibits)) gth))
  ?.  =(~ (find [inc-ex]~ list-exhibits))
    ~&  >>>  "Duplicate Exhibit Blocked: {<inc-ex>}"
    `state
  :-  ~
  %=  state
  exhibits      (~(put by exhibits) next-ex [inc-ex min-bid.inc-ex '~dalten Collection'])
  current-bids  (~(put by current-bids) inc-ex `bids:daltenauction`(my :~([0 [0 '0x0' min-bid.inc-ex]])))
  ==
  ++  extractor
    |=  [current=[id=@ud [exhibit=exhibit:daltenauction top-bid=@rh top-bidder=@tU]] out=(list exhibit:daltenauction)]
    [exhibit:+:current out]
  --
++  bid-item
  |=  [bidder-address=crypto-add:daltenauction item=@ud bid=@rh]
  |^
  ?.  (~(has by exhibits) item)
    ~&  >>>  "Invalid Bid on Non-Existent Item {<item>}"
    `state
  ?.  (gth bid top-bid:(~(got by exhibits) item))
    ~&  >>>  "Inadequate Bid - bid {<bid>} less than current top bid"
    `state
  :-  ~
  %=  state
  exhibits      (~(put by exhibits) update-exhibits-map)
  current-bids  (~(put by current-bids) -:add-bid +:add-bid)
  ==
  ++  add-bid
    =/  ex=exhibit:daltenauction    exhibit:(~(got by exhibits) item)
    =/  bid-map=bids:daltenauction  (~(got by current-bids) ex)
    =/  next-bid=@ud                +(i:-:(sort `(list @ud)`~(tap in ~(key by bid-map)) gth))
    [ex (~(put by bid-map) next-bid [-:(find-user currency.ex) bidder-address bid])]
  ++  update-exhibits-map
    =/  ex=exhibit:daltenauction  exhibit:(~(got by exhibits) item)
    [item [ex bid +:(find-user currency.ex)]]
  ++  find-user
  |=  currency-type=currency:daltenauction
  ?-  currency-type
    %eth
  (roll ~(tap by biddermap) get-user-id-eth)
    %bsv
  (roll ~(tap by biddermap) get-user-id-bsv)
    %raven
  (roll ~(tap by biddermap) get-user-id-raven)
  ==
  ++  get-user-id-eth
    |=  [map-item=[id=@ud eth=@tU bsv=@tU raven=@tU nic=@tU] user=[@ud @tU]]
    ?:  =(eth.map-item bidder-address)
      =.  user  [id.map-item nic.map-item]
      user
    user
  ++  get-user-id-bsv
    |=  [map-item=[id=@ud eth=@tU bsv=@tU raven=@tU nic=@tU] user=[@ud @tU]]
    ?:  =(bsv.map-item bidder-address)
      =.  user  [id.map-item nic.map-item]
      user
    user
  ++  get-user-id-raven
    |=  [map-item=[id=@ud eth=@tU bsv=@tU raven=@tU nic=@tU] user=[@ud @tU]]
    ?:  =(raven.map-item bidder-address)
      =.  user  [id.map-item nic.map-item]
      user
    user
  --
--