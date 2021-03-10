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
  =/  dalten-auction  [%file-server-action !>([%serve-dir /'~auction' /app/daltenauction %.n %.n])]
  =.  state  [%0 `exhibits:daltenauction`~ `current-bids:daltenauction`~ `biddermap:daltenauction`(my :~([0 ['dalten@daltencollective.org' '~dalten Collection']])) %.n]
  :_  this
  :~  [%pass /srv %agent [our.bowl %file-server] %poke daltenauction]
  ==
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
    (bid-item:hc email.action exhibit-id.action bid-amt.action)
      %add-bidder
    (add-bidder:hc email.action nick.action)
      %start-over
    ?.  check.action
      `state
    `state(exhibits ~, current-bids ~, biddermap `biddermap:daltenauction`(my :~([0 ['dalten@daltencollective.org' '~dalten Collection']])), allow-bidding %.n)
      %allow-bidding
    `state(allow-bidding %.y)
      %produce-test-json
    ~&  >>  "{<(produce-json exhibits.state)>}"
    `state
    ==
    [cards state]
--
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+  path  (on-watch:def path)
    [%auctionsite ~]
  ~&  >>>  "I'm being watched"
  :_  this
  ~[[%give %fact ~[path] [%json !>((json (produce-json:hc exhibits)))]]]
  ==
++  on-arvo   on-arvo:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-fail   on-fail:def
--
|_  bol=bowl:gall
++  add-item
  |=  [inc-ex=exhibit:daltenauction]
  |^
  ^-  (quip card _state)
  ?:  =(~ exhibits)
    :-  ~
    %=  state
    exhibits      (~(put by exhibits) 0 [inc-ex min-bid.inc-ex '~dalten Collection'])
    current-bids  (~(put by current-bids) inc-ex `bids:daltenauction`(my :~([0 [0 'dalten@daltencollective.org' min-bid.inc-ex]])))
    ==
  =/  list-exhibits=(list exhibit:daltenauction)  (roll ~(tap by exhibits) extractor)
  =/  next-ex=@ud  +(i:-:(sort `(list @ud)`~(tap in ~(key by exhibits)) gth))
  ?.  =(~ (find [inc-ex]~ list-exhibits))
    ~&  >>>  "Duplicate Exhibit Blocked: {<inc-ex>}"
    `state
  =.  exhibits      (~(put by exhibits) next-ex [inc-ex min-bid.inc-ex '~dalten Collection'])
  =.  current-bids  (~(put by current-bids) inc-ex `bids:daltenauction`(my :~([0 [0 'dalten@daltencollective.org' min-bid.inc-ex]])))
  :-  ~[[%give %fact ~[/auctionsite] [%json !>((json (produce-json exhibits)))]]]
  state
  ++  extractor
    |=  [current=[id=@ud [exhibit=exhibit:daltenauction top-bid=@ud top-bidder=@tU]] out=(list exhibit:daltenauction)]
    [exhibit:+:current out]
  --
++  bid-item
  |=  [email=@tU item=@ud bid=@ud]
  |^
  ^-  (quip card _state)
  ?.  (~(has by exhibits) item)
    ~&  >>>  "Invalid Bid on Non-Existent Item {<item>}"
    `state
  ?.  (gth bid top-bid:(~(got by exhibits) item))
    ~&  >>>  "Inadequate Bid - bid {<bid>} less than current top bid"
    `state
  =.  exhibits      (~(put by exhibits) update-exhibits-map)
  =.  current-bids  (~(put by current-bids) -:add-bid +:add-bid)
  :-  ~[[%give %fact ~[/auctionsite] [%json !>((json (produce-json exhibits)))]]]
  state
  ++  add-bid
    =/  ex=exhibit:daltenauction    exhibit:(~(got by exhibits) item)
    =/  bid-map=bids:daltenauction  (~(got by current-bids) ex)
    =/  next-bid=@ud                +(i:-:(sort `(list @ud)`~(tap in ~(key by bid-map)) gth))
    [ex (~(put by bid-map) next-bid [-:(roll ~(tap by biddermap) get-user-by-email) email bid])]
  ++  update-exhibits-map
    =/  ex=exhibit:daltenauction  exhibit:(~(got by exhibits) item)
    [item [ex bid +:(roll ~(tap by biddermap) get-user-by-email)]]
  ++  get-user-by-email
    |=  [map-item=[id=@ud email=@tU nic=@tU] user=[@ud @tU]]
    ^-  [@ud @tU]
    ?:  =(email.map-item email)
      =.  user  [id.map-item nic.map-item]
      user
    user
  --
++  add-bidder
  |=  [email=@tU nick=@tU]
  ^-  (quip card _state)
  =/  next-bidder  +(i:-:(sort `(list @ud)`~(tap in ~(key by biddermap)) gth))
  :-  ~
  %=  state
  biddermap  (~(put by biddermap) next-bidder [email nick])
  ==
++  produce-json
  |=  exs=exhibits:daltenauction
  |^
  ^-  json
  =/  exhibit-list=(list [id=@ud ex=[title=@tU img=@tU min-bid=@ud artist=@tU uri=@tU cur=?(%eth %bsv %raven)] top-bid=@ud top-bidder=@tU])  ~(tap by exhibits:state)
  =/  objs=(list json)  (roll exhibit-list object-maker)
  [%a objs]
  ++  object-maker
    |=  [in=[id=@ud ex=[title=@tU img=@tU min-bid=@ud artist=@tU uri=@tU cur=?(%eth %bsv %raven)] top-bid=@ud top-bidder=@tU] out=(list json)]
    ^-  (list json)
    :-
    %-  pairs:enjs:format
    :~
    ['id' (numb:enjs:format id.in)]    ['title' [%s title.ex.in]]
    ['image' [%s img.ex.in]]           ['chain' [%s cur.ex.in]]
    ['artist' [%s artist.ex.in]]       ['topBid' (numb:enjs:format top-bid.in)]
    ['topBidder' [%s top-bidder.in]]   ['uri' [%s uri.ex.in]]
    ==
    out
  --
--