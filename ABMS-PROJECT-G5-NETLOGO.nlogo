patches-own [ section-name item-id stock expiry-date ] ; Item Id is the property of the patch, means that each patch has its own unique ID
breed [ customers customer ] ; We are creating a breed for the agents, and its name is customer
customers-own [
  time-limit ; The amount of time the customer wants to stay in the store [ excluding the entrance time and the checkout time ]
  spent-time ; The amount of time the customer spent so far.
  possesion-money ; The amount of money the customer holds before the start of the shopping
  section-budget-list ; This list is created to assign random budgets for each section of the store
  section-item-list ; This list holds all the items in section-wise format.
  shopped-item-list ; This list holds all the items the customer purchases.
  skipped-item-list ; This list holds all the items the customer doesn't buy, due to some reasons.
  out-stock-list ;
  money-spent ; The amount of money the customer has spent so far.
  money-remaining ; The amount of money that is left after purchasing a product.
  next-section ; This variable is used to easily retrieve the index of the required section in the section-budget-list.
  next-section-name ; We store the name of the section the customer is currently in.
  next-item ; The item-id of the next item the customer wants to purchase will be stored in this.
  next-item-index ; We store the index of the next item the customer wants to purchase so that it will be easy to retrieve the item from the list [ section-item-list ]
  head-direction ; This variable indicates the current direction of the customer.
  prev-head ; This variable is just a helper variable used to align the turtle in a proper way. [ NOTE: This is not a core property to consider ]
  align ; This variable is just a helper variable used to align the turtle in a proper way. [ NOTE: This is not a core property to consider ]
  customer-satisfaction-mean; this varible is for overall satisfaction of individual customers   sekhar
  expired-item-list
]
globals [ total-customers total-items-purchased total-possesion-money total-staying-time total-money-spent total-customers-finished-shopping
          satisfaction-level-list  ; sekhar
        ] ; This variable stores the total number of customers visited between 9:00 - 21:00

to setup
  clear-all
  ; Below horizontal and vertical lines stores all the coordinates and the color of the lines which has to be drawn as part of the in-store structure.
  let vertical-lines [ [ -60 14 42 0 ] [ -58 -2 14 0 ] [ -56 -18 -2 0 ] [ -58 -30 -18 0 ] [ -14 40 41 0 ] [ -2 38 39 0 ] [ 28 39 40 0 ] [ 35 38 39 0 ] [ 40 39 40 0 ] [ 41 36 37 0 ] [ 69 36 37 0 ] [ 72 35 36 0 ] [ 100 33 37 0 ] [ 98 -25 33 0 ] [ 85 -32 -25 0 ] [ 77 -39 -32 0 ] [ 45 -39 -32 0 ] [ 25 -39 -32 0 ] [ 23 -33 -29 125 ] [ 24 -33 -29 125 ] [ 11 -37 -29 125 ] [ 12 -37 -29 125 ] [ 4 -37 -29 125 ] [ 5 -37 -29 125 ] [ -3 -37 -29 125 ] [ -2 -37 -29 125 ] [ -10 -37 -29 125 ] [ -9 -37 -29 125 ] [ -17 -37 -29 125 ] [ -16 -37 -29 125 ] [ -24 -37 -29 125 ] [ -23 -37 -29 125 ] [ 76 23 28 85 ] [ 86 23 28 85 ] [ 76 9 14 85 ] [ 86 9 14 85 ] [ 76 -3 2 85 ] [ 86 -3 2 85 ] [ 74 -18 -13 85 ] [ 88 -18 -13 85 ] [ 53 23 28 85 ] [ 65 23 28 85 ] [ 31 23 28 85 ] [ 42 23 28 85 ] [ 0 23 28 85 ] [ 18 23 28 85 ] [ -22 29 34 85 ] [ -12 29 34 85 ] [ -55 28 36 85 ] [ -32 28 36 85 ] [ -55 20 25 85 ] [ -45 20 25 85 ] [ -53 -28 -26 85 ] [ -43 -28 -26 85 ] [ -47 3 16 85 ] [ -45 3 16 85 ] [ -47 -18 0 85 ] [ -42 -18 0 85 ] [ -36 -18 19 85 ] [ -31 -18 19 85 ] [ -26 -18 19 85 ] [ -21 -18 19 85 ] [ -17 -15 16 85 ] [ -10 -15 16 85 ] [ -5 -18 12 85 ] [ 0 -18 12 85 ] [ 5 -18 12 85 ] [ 10 -18 12 85 ] [ 15 -18 12 85 ] [ 20 -18 12 85 ] [ 25 -17 12 85 ] [ 30 -17 12 85 ] [ 35 7 9 85 ][ 39 7 9 85 ] [ 35 -1 0 85 ][ 37 -1 0 85 ] [ 48 -18 12 85 ] [ 56 -18 12 85 ] ]
  let horizontal-lines [ [ 14 -58 -59 0 ] [ -2 -56 -57 0 ] [ -18 -57 -58 0 ] [ 42 -14 -60 0 ] [ 40 -2 -14 0 ] [ 38 28 -2 0 ] [ 40 35 28 0 ] [ 38 40 35 0 ] [ 35 69 41 0 ] [ 37 72 69 0 ] [ 35 99 72 0 ] [ 33 99 98 0 ] [ -25 100 85 0 ] [ -32 85 77 0 ] [ -32 45 25 0 ] [ -29 24 11 125 ] [ -30 24 11 125 ] [ -37 14 12 125 ] [ -36 14 12 125 ] [ -37 7 5 125 ] [ -36 7 5 125 ] [ -37 0 -2 125 ] [ -36 0 -2 125 ] [ -37 -7 -9 125 ] [ -36 -7 -9 125 ] [ -37 -14 -16 125 ] [ -36 -14 -16 125 ] [ -37 -21 -23 125 ] [ -36 -21 -23 125 ] [ 28 86 76 85 ] [ 23 86 76 85 ] [ 14 86 76 85 ] [ 9 86 76 85 ] [ 2 86 76 85 ] [ -3 86 76 85 ] [ -13 88 74 85 ] [ -18 88 74 85 ] [ 28 65 53 85 ] [ 23 65 53 85 ] [ 28 42 31 85 ] [ 23 42 31 85 ] [ 28 18 0 85 ] [ 23 18 0 85 ] [ 34 -12 -22 85 ] [ 29 -12 -22 85 ] [ 36 -32 -55 85 ] [ 28 -32 -55 85 ] [ 25 -45 -55 85 ] [ 20 -45 -55 85 ] [ -26 -43 -53 85 ] [ -28 -43 -53 85 ] [ 3 -45 -47 85 ] [ 16 -45 -47 85 ] [ -18 -42 -47 85 ] [ 0 -42 -47 85 ] [ -18 -31 -36 85 ] [ 19 -31 -36 85 ] [ -18 -21 -26 85 ] [ 19 -21 -26 85 ] [ 16 -11 -16 85 ] [ -15 -11 -16 85 ] [ -18 0 -5 85 ] [ 12 0 -5 85 ] [ -18 10 5 85 ] [ 12 10 5 85 ] [ -18 20 15 85 ] [ 12 20 15 85 ] [ -18 30 25 85 ] [ 12 30 25 85 ] [ -18 30 25 85 ] [ 7 39 35 85 ] [ 9 39 35 85 ] [ -1 37 35 85 ] [ 0 37 35 85 ] [ 12 56 48 85 ] [ -18 55 48 85 ] ]
  ask patches [ set pcolor white ]
  foreach range ( length vertical-lines ) [ ;Drawing all the vertical lines first.
    i ->
    let myitem item i vertical-lines
    draw-vertical-lines item 0 myitem item 1 myitem item 2 myitem item 3 myitem
  ]
  foreach range ( length horizontal-lines ) [ ;Drawing all the horizontal lines next.
    i ->
    let myitem item i horizontal-lines
    draw-horizontal-lines item 0 myitem item 1 myitem item 2 myitem item 3 myitem
  ]
  draw-entrance ; This functions just sets up the entrance with its respective coordinates and the color.
  draw-exit ; This function setups the exit
  divide-into-sections ; We divide the store into different sections by following the guide [ paper ]
  setup-register ; Then we setup the register section.
  set satisfaction-level-list []
  reset-ticks
end

to draw-vertical-lines [ txcor tycor-1 tycor-2 tcolor ] ; Function to draw vertical lines
  ask patches with [ pxcor = txcor and pycor >= tycor-1 and pycor <= tycor-2 ] [ set pcolor tcolor ]
end

to draw-horizontal-lines [ tycor txcor-1 txcor-2 tcolor ] ;Function to draw horizontal lines
  ask patches with [ pycor = tycor and pxcor <= txcor-1 and pxcor >= txcor-2 ] [ set pcolor tcolor ]
end

to draw-entrance ;Function to draw entrance
  ask patches with [ pycor = -39 and pxcor <= 77 and pxcor >= 45 ] [ set pcolor yellow ]
end

to draw-exit ;Function to draw exit
  draw-vertical-lines -58 -39 -30 red
  draw-horizontal-lines -39 25 -58 red
end

to section-division-command [ txcor-1 txcor-2 tycor-1 tycor-2 ts-name ] ;Function to divide the store into different sections
  ask patches with [ pxcor > txcor-1 and pxcor < txcor-2 and pycor > tycor-1 and pycor < tycor-2 ] [
    set section-name ts-name
  ]
end

to divide-into-sections ;Function to divide the store into different sections by giving the details and coordinates of each section
  let sections [ [ -61 -27 26 43 "Tofu, Drink, Dairy" ] [ -28 25 21 43 "Meat" ] [ 24 70 18 43 "Fish" ] [ 69 101 -32 43 "Vegetables, Fruits" ] [ 44 70 -32 19 "Vegetables, Fruits" ] [ -61 -38 -29 27 "Delicatessen, Bread" ] [ -39 -27 -29 27 "Standard Items, Commodities" ] [ -28 25 -43 -23 "Register" ] [ -61 -27 -43 -28 "Exit" ] [ 44 101 -43 -31 "Entrance" ] [ 24 45 -43 19 "Standard Items, Commodities" ] [ -28 25 -24 22 "Standard Items, Commodities" ] [ -25 12 -38 -28 "Register" ] ]
  let id 0
  ask patches with [ pcolor = 85 ] [
    set item-id id
    set id id + 1 ; Assigning unique id for each blue patch in each section
    set stock random stock-amount
    set expiry-date random expiry-prob
  ]
  foreach range ( length sections ) [
    i ->
    let mysec item i sections
    section-division-command item 0 mysec item 1 mysec item 2 mysec item 3 mysec item 4 mysec
  ]
end

to setup-register ; Function to setup register section by giving the details and coordinates of each register counter
  let registers [ [ -20 -29 "reg-1" ] [ -13 -29 "reg-2" ] [ -6 -29 "reg-3" ] [ 1 -29 "reg-4" ] [ 8 -29 "reg-5" ] ]
  foreach registers [
    i ->
    ask patches with [ pxcor = item 0 i and pycor = item 1 i ] [ set item-id item 2 i ]
  ]
end

to create-customer ; This Function creates customers
  let minutes ticks mod 60 ; Setting up the minute count.
  if runtime-choice = "Complete run" [
    if total-customers <= max-customers-limit and minutes = 0 [ ; generating customers at a particular rate.
      let no-cust 2 + random customer-entrance-rate ; Generating the count of the customer in that minute
      creation-procedure no-cust
    ]
  ]
  if runtime-choice = "Unit testing" [
    if total-customers < 1 and minutes = 0 [ ; generating customers at a particular rate.
      creation-procedure 1
    ]
  ]
  if runtime-choice = "Sampling" [
    if total-customers <= sample-size and minutes = 0 [ ; generating customers at a particular rate.
      let no-cust 2 + random customer-entrance-rate ; Generating the count of the customer in that minute
      creation-procedure no-cust
    ]
  ]
end

to creation-procedure[ no-cust ]
  set total-customers total-customers + no-cust ; Adding the generated customer count to the total count of the customers.
  create-customers no-cust [ ; Finally creating the customers.
    setxy 47 + random 29  -38 + random 8
    set color black
    set heading 0
    initialize-customer-props ; We initialize the properties in a seperate function.
    set total-possesion-money total-possesion-money + possesion-money
  ]
end

to initialize-customer-props
  set size 2
  set spent-time 0
  if behavioral-model-choice = "Shopping List & Money Model" [
    set time-limit 999999 ; Unlimited staying time
    set possesion-money min-possesion-money + random max-possesion-money ; min, max-possesion-money is a slider global variable
  ]
  if behavioral-model-choice = "Shopping List & Time Model" [
    set time-limit 111 + random random-time-limit ; random-time-limit is a slider global variable
    set possesion-money 999999 ; Unlimited-possesion-money
  ]
  if behavioral-model-choice = "Shopping List, Money & Time Model" [
    set time-limit 111 + random random-time-limit ; random-time-limit is a slider global variable
    set possesion-money min-possesion-money + random max-possesion-money ; min, max-possesion-money is a slider global variable
  ]
  set section-budget-list create-section-budget-list ; We generate the section-budget-list using this function
  set section-item-list create-section-item-list ; We generate the section-item-list using this function
  set money-spent 0
  set money-remaining possesion-money
  select-next-section ; We choose the next section by running this function
  select-next-item next-section ; We select the next item by running this function
  set shopped-item-list [] ; Initializing the shopping cart
  set skipped-item-list [] ; Initializing the skipped items cart
  set expired-item-list []
  set out-stock-list [] ;
  set head-direction "null" ; Initializing the direction of the customer as null
end

to-report create-section-budget-list ; Function to create the section-wise budget list
  let myitems [ "Tofu, Drink, Dairy" "Meat" "Fish" "Vegetables, Fruits" "Delicatessen, Bread" "Standard Items, Commodities" ] ; Storing all the section names in the list
  let no-items 1 + random 6 ; Generating n number of random sections to assign the budget
  let item-names n-of no-items myitems
  let item-maps []
  foreach range ( no-items ) [
    i ->
    let myitem item i item-names
    let amount min-section-budget + random max-section-budget ; Assigning the amount here
    set item-maps lput ( list myitem int ( amount ) ) item-maps
  ]
  report item-maps
end

to-report create-section-item-list ; Function to create the items for each section
  let final-items []
  let sec-budg-list section-budget-list
  foreach range ( length sec-budg-list ) [
    i ->
    let item-list []
    let temp item i sec-budg-list
    let sec-name item 0 temp
    let sec-budg item 1 temp
    ask patches with [ section-name = sec-name and pcolor = 85] [
      set item-list lput item-id item-list ; Stroing all the available item-id's in a particular section in a list
    ]
    let rand min-items + random max-items ; Selecting the minimum and maximum number of items per section randomly using the sliders.
    let sec-items-list n-of rand item-list
    let counter 0
    let final-items-list []
    let budget sec-budg
    let count-rand rand
    while [ count-rand != 0 ] [
      ifelse count-rand = 1 [
        let final-item-price int budget
        set final-items-list lput ( list item counter sec-items-list final-item-price ) final-items-list
        set count-rand count-rand - 1
      ] [
        let final-item-price 2 + random int ( budget / count-rand ) ; Assigning the budget of each item randomly.
        set budget budget - final-item-price
        set count-rand count-rand - 1
        set final-items-list lput ( list item counter sec-items-list final-item-price ) final-items-list
      ]
      set counter counter + 1
    ]
    set final-items lput final-items-list final-items
  ]
  report final-items
end

to start-simulation ; Function to start the simulation
  create-customer ; We create the customers here with random entrance rate
  start-shopping ; This function triggers the movement of customers inside the store
  if count customers = 0 [
    stop
  ]
  tick
end

to start-shopping
  ask customers [
    ifelse pycor <= -32 and pxcor > 46 [
      go-inside-through-entrance ; Customer first enters the store through this function
    ] [
      start-moving-inside-shop ; Then he starts moving inside the shop with this function
      if section-budget-list != "completed" [ ; If there are any sections left with respect to the possesion money, then he purchases the item
        purchase-item
        set spent-time spent-time + 1
      ]
      execute-model
    ]
  ]
end

to execute-model
  if behavioral-model-choice = "Shopping List & Money Model" [
    check-possesion-money
    check-shopping-list
  ]
  if behavioral-model-choice = "Shopping List & Time Model" [
    ;print "I am here"
    check-spent-time
    check-shopping-list
  ]
  if behavioral-model-choice = "Shopping List, Money & Time Model" [
    check-spent-time
    check-possesion-money
    check-shopping-list
  ]
end

to check-spent-time ; This functions checks whether the staying time is completed ot not.
  if spent-time = time-limit and section-budget-list != "completed" [
    move-to-register ; If completed, then the customer will move to the register
  ]
end

to check-possesion-money
  if possesion-money = 0 and section-budget-list != "completed"  [
    move-to-register ; If completed, then the customer will move to the register
  ]
end

to check-shopping-list
  if next-section = 99999 and section-budget-list != "completed" [
    move-to-register ; If completed, then the customer will move to the register
  ]
end

to move-to-register ; This function will assign the register details to each customer randomly.
  print "-1"
  let register [ "reg-1" "reg-2" "reg-3" "reg-4" "reg-5" ]
  set next-item item random 5 register
  set section-budget-list "completed"
  set section-item-list ( list ( list ( list next-item 0 ) ) )
  set next-section 0
  print "0"
  set total-staying-time total-staying-time + spent-time
  set total-money-spent total-money-spent + money-spent
  set total-customers-finished-shopping total-customers-finished-shopping + 1
  let no-shopped-list length shopped-item-list  ; sekhar
  let no-skipped-list length skipped-item-list  ; sekhar
  print "1"
  set customer-satisfaction-mean calculate-satisfaction-level no-shopped-list no-skipped-list ; sends values to calcuate satisfacton level sekhar
end

to go-inside-through-entrance ; This function is used when the customer enter the store.
    fd 1
end

to start-moving-inside-shop ; This is the core function to th entire simulation. This function is used to move the customer inside the shop.
  if pxcor = -20 or pxcor = -13 or pxcor = -6 or pxcor = 1 or  pxcor = 8 and pycor <= -29 and pycor >= -37 [ ; This condition checks whether the customer has arrived to the register or not.
    set heading 180 ; If arrived, we set his heading to the exit.
  ]
  let id next-item
  let items-list item next-section section-item-list
  if pcolor = white and not empty? items-list [ ; We check here whether the cart is empty or not.
    face one-of patches with [item-id = id] ; The customer faces the item which he wants to purchase next.
    ifelse [pcolor] of patch-ahead 1 != white [ ; Checking if there is any wall near the customer.
      if head-direction = "null" [ ; Assigning the appropriate direction to the customer.
        ifelse ycor < [pycor] of one-of patches with [item-id = id ] [
          set head-direction "c-up"
        ][
          set head-direction "v-dw"
        ]
      ]
      let angle 0
      while [wall? angle head-direction] [ ; This while loop calculates the angle by which the customer to rotate so that he can overcome the wall or any obstacles. [ wall? function is very important here, and we will discuss about it at the end of this code ]
        ifelse align = 1 [
          ifelse prev-head = -1 [
            set angle angle + 1
          ] [
            set angle angle - 1
          ]
        ] [
          ifelse prev-head = -1 [
            set angle angle - 1
          ] [
            set angle angle + 1
          ]
        ]
      ]
      if angle = 180 [
        set prev-head 180
      ]
      ifelse head-direction = "v-dw" [ ; Depending on the head direction, we rotate it to right to left.
        rt angle
      ] [
        lt angle
      ]

      fd 1 ; Moving a step forward.
    ] [
      if pxcor = -20 or pxcor = -13 or pxcor = -6 or pxcor = 1 or  pxcor = 8 and pycor <= -29 and pycor >= -37 [ ; This condition checks whether the customer has arrived to the register or not.
        set heading 180
        if ycor < -36 [
          set total-items-purchased total-items-purchased + length shopped-item-list
          die
        ]
      ]
      set head-direction "null" ; If there is not wall, then this else will be executed
      set prev-head -1
      ifelse align = 1 [
        set align -1
      ] [
        set align 1
      ]
      rt 0
      fd 1
    ]
  ]
end

to purchase-item ; This function is used to purchase the item when the customer approaches it.
  if not empty? item next-section section-item-list [
    let id next-item
    if any? patches in-radius 1 with [item-id = id] [
      remove-item-from-list ; Removes the item from the list
      set head-direction "null" ; Resets its direction
    ]
  ]
end

to remove-item-from-list ; As stated above, this function will remove the item from the list in two cases.
  let removed-item item next-item-index item next-section section-item-list
  let section-list item next-section section-item-list
  let updated-list remove removed-item section-list
  set section-item-list replace-item next-section section-item-list updated-list

  let purchased-item-price item 1 removed-item
  let item-stock 0
  ask patches with [ item-id = item 0 removed-item ] [ set item-stock stock ]
  let item-expiry-date 99999 ; BHARGAV RAM
  ask patches with [ item-id = item 0 removed-item ] [ ;BHARGAV RAM
    set item-expiry-date expiry-date               ;BHARGAV RAM
  ]
  print item-stock
  print item-expiry-date
  ifelse item-stock = 0 or item-expiry-date =  0 or purchased-item-price > money-remaining [ ; Case 1: If the customer' possesion money is less than the item's price, then the item will be removed from the items list and will be added in the skipped cart
    if item-stock = 0 [ set out-stock-list lput removed-item out-stock-list ]
    set skipped-item-list lput removed-item skipped-item-list
    let budget item next-section section-budget-list
    let remaining-section-budget item 1 budget - item 1 removed-item
    let updated-section-budget ( list item 0 budget remaining-section-budget )
    set section-budget-list replace-item next-section section-budget-list updated-section-budget
    if item-expiry-date = 0 [ ;BHARGAV RAM
        set expired-item-list lput removed-item expired-item-list  ;BHARGAV RAM
       ]
  ] [
    print "I came here"
    set shopped-item-list lput removed-item shopped-item-list ; Case 2: If the customer' possesion money is equal or greater than the item's price, then the item will be removed from the items list and will be added in the shopping cart
    let budget item next-section section-budget-list
    set money-spent money-spent + item 1 removed-item
    set money-remaining money-remaining - item 1 removed-item
    let remaining-section-budget item 1 budget - item 1 removed-item
    let updated-section-budget ( list item 0 budget remaining-section-budget )
    set section-budget-list replace-item next-section section-budget-list updated-section-budget
    ask patches with [ item-id = item 0 removed-item ] [ set stock stock - 1 ]
  ]
  ifelse length item next-section section-item-list = 0 [ ; After the item is purchased, we now select the next item neartest to the customer and next section as well [ if the previous section shopping is completed ]
    select-next-section ; Function that will select the next section
    select-next-item next-section ; Function that will select the next item
  ] [
    select-next-item next-section
  ]
end

to select-next-section ; This function selects the next section
  let prev-sec-dist 99999
  let next-sec-dist 99999
  let index 0
  let sn ""
  foreach section-budget-list [
    sec-name ->
    if item 1 sec-name != 0 and sec-to-cust-dist sec-name < prev-sec-dist [
      set next-sec-dist index
      set sn sec-name
      set prev-sec-dist sec-to-cust-dist sec-name
    ]
    set index index + 1
  ]
  set next-section next-sec-dist
  set next-section-name sn
end

to select-next-item [ section-index ] ;This Function selects the next item
  if next-section = 99999 [
    stop
  ]
  let prev-item-dist 99999
  let next-item-dist 99999
  let items-list item section-index section-item-list
  let index 0
  let item-index 0
  foreach items-list [
    items ->
    if item-to-cust-dist items < prev-item-dist [
      set next-item-dist item 0 items
      set item-index index
      set prev-item-dist item-to-cust-dist items
    ]
    set index index + 1
  ]
  set next-item next-item-dist
  set next-item-index item-index
end

to-report sec-to-cust-dist [ sec-name ] ; This function finds the distance between a section and a customer
  let dist 99999
  let this-sec-name item 0 sec-name
  ask one-of patches with [pcolor != white and section-name = this-sec-name ] [set dist distance myself]
  report dist
end

to-report item-to-cust-dist [ items ] ; This function finds the distance between a item and a customer
  let dist 99999
  let id item 0 items
  ask one-of patches with [pcolor != white and item-id = id] [set dist distance myself]
  report dist
end

to-report wall? [angle direct] ; The wall function reports whether there is a wall near the customer or not
  ifelse direct = "v-dw" [
    report white != [pcolor] of patch-right-and-ahead angle 1
  ] [
    report white != [pcolor] of patch-left-and-ahead angle 1
  ]
end

to-report calculate-satisfaction-level[ no-shopped-list no-skipped-list ]  ; sekhar
  let customer-mean no-shopped-list * 10 / (no-shopped-list + no-skipped-list) ; sekhar
  set satisfaction-level-list lput  customer-mean satisfaction-level-list ; sekhar
  report mean satisfaction-level-list  ; sekhar
end
@#$#@#$#@
GRAPHICS-WINDOW
11
10
985
529
-1
-1
6.0
1
10
1
1
1
0
0
0
1
-60
100
-42
42
1
1
1
ticks
30.0

BUTTON
12
536
77
570
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
189
537
307
570
Start Simulation
start-simulation
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
80
537
186
570
Create Agent
create-customer
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
309
537
372
570
step
start-simulation
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1011
340
1183
373
max-customers-limit
max-customers-limit
0
2000
13.0
1
1
NIL
HORIZONTAL

SLIDER
1187
339
1362
372
customer-entrance-rate
customer-entrance-rate
1
10
3.0
1
1
NIL
HORIZONTAL

MONITOR
1010
180
1111
225
Total customers
total-customers
17
1
11

SLIDER
1012
375
1184
408
random-time-limit
random-time-limit
0
3000
1548.0
1
1
NIL
HORIZONTAL

SLIDER
1011
410
1216
443
min-possesion-money
min-possesion-money
0
10000
489.0
1
1
NIL
HORIZONTAL

SLIDER
1011
445
1193
478
min-section-budget
min-section-budget
0
10000
419.0
1
1
NIL
HORIZONTAL

SLIDER
1196
445
1368
478
max-section-budget
max-section-budget
0
10000
1592.0
1
1
NIL
HORIZONTAL

SLIDER
1219
410
1392
443
max-possesion-money
max-possesion-money
0
10000
886.0
1
1
NIL
HORIZONTAL

SLIDER
1010
481
1182
514
min-items
min-items
0
100
1.0
1
1
NIL
HORIZONTAL

SLIDER
1186
481
1358
514
max-items
max-items
0
100
12.0
1
1
NIL
HORIZONTAL

CHOOSER
1153
68
1395
113
behavioral-model-choice
behavioral-model-choice
"Shopping List & Money Model" "Shopping List & Time Model" "Shopping List, Money & Time Model"
2

MONITOR
1126
181
1260
226
Total purchased items
total-items-purchased
17
1
11

MONITOR
1274
181
1433
226
Average possesion money
int (total-possesion-money / total-customers)
17
1
11

MONITOR
1009
239
1140
284
Average staying time
int( total-staying-time / total-customers-finished-shopping )
17
1
11

MONITOR
1153
239
1288
284
Average money spent
int( total-money-spent / total-customers-finished-shopping )
17
1
11

CHOOSER
1007
68
1145
113
Runtime-choice
Runtime-choice
"Unit testing" "Sampling" "Complete run"
1

SLIDER
1365
340
1537
373
sample-size
sample-size
0
100
31.0
1
1
NIL
HORIZONTAL

MONITOR
1306
240
1411
285
satisfaction level
mean satisfaction-level-list
17
1
11

SLIDER
1187
375
1359
408
expiry-prob
expiry-prob
0
100
6.0
1
1
NIL
HORIZONTAL

SLIDER
1364
375
1536
408
stock-amount
stock-amount
0
100
50.0
1
1
NIL
HORIZONTAL

TEXTBOX
1008
33
1158
51
Choices: 
13
0.0
1

TEXTBOX
1010
149
1160
167
Moniters:
13
0.0
1

TEXTBOX
1013
308
1163
326
Sliders:
13
0.0
1

PLOT
1575
62
1957
305
Satisfaction level plots
total customers
satisfaction level
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"pen-1" 1.0 0 -5825686 true "" "if satisfaction-level-list != [] [\n   plot mean satisfaction-level-list\n]"

TEXTBOX
1575
30
1725
48
Plots:
13
0.0
1

PLOT
1575
331
1959
569
Average money spent
total customers
average money spent
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Money-spent" 1.0 0 -13840069 true "" "if total-customers-finished-shopping != 0 [\n    plot int( total-money-spent / total-customers-finished-shopping )\n]"

PLOT
1982
63
2356
304
Average staying time
total customers
Average staying time
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"avg-stying-time" 1.0 0 -2674135 true "" "if total-customers-finished-shopping != 0 [\n   plot int( total-staying-time / total-customers-finished-shopping )\n]"

PLOT
1981
332
2361
570
Average no. of items purchased
Average purchased items
total customers
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"avg-purchased-itms" 1.0 0 -955883 true "" "if total-customers-finished-shopping != 0 [\n   plot int( total-items-purchased / total-customers-finished-shopping )\n]"

@#$#@#$#@
## WHAT IS IT?
This model is mainly focused on ABISS, which is also called in store simulator in short. In this model, we designed the in-store simulation of a store located in japan which is a supermarket. This model explains about the customer behavioural statistics and predicts which factors affect the sales promotion taking several points into consideration.

## HOW IT WORKS
Customers are considered as agents in this model. They have some specific rules which are used for simulation purposes for example, the customers cannot go inside a wall. The whole behavior of the model is as follows.

* The customers enters into the store at a pre-selectable entrance speed.
* After entering, they choose a section which is near to them and start shopping in that section.
* They go to that section and selects a product that is in their shopping list
* They select the product which is nearer to them and check if the item is in stock or not, If not he will skip the item
* If the item is in stock they validate it for the expiry date.
* If the expiry date is still on period, they add the item to their cart, else they add the item to their skipped items list.
* After completing their shopping they move to the register section to checkout the purchased items.
* After successfully completing the shopping list, they proceed to checkout process.
* After the shopping is done they leave the store by providing some customer feedback. *(Please note that in this model, It is known that every customer is required to provide honest customer feedback.)*

## HOW TO USE IT

First click the setup button which will create the interface with all the necessary things like products, registers, boundaries, entrances, exits with its respective properties given to them. After clicking the setup, we need to start the simulation. Before starting it, we need to select and adjust some sliders in the interface.

### Run time choice
Run time choice has three options:
1. **Unit testing** which is used to test the model by initialising all the properties for a single customer and run the simulation.
2. **Sampling** which is used frequently at the time of statistical testing. We select the sample size from the slider and run the simulation.
3. **Complete run** which is used to simulate the whole run

### Behavioural model choice
Behavioural model choice has three options:
1. **Shopping List & Money Model** is the first test case. In this, we ground the staying time factor of the customer and run the simulation.
2. **Shopping List & Time Model** is the second test case. In this, we ground the possesion money factor of the customer and run the simulation.
3. **Shopping List, Money & Time Model** is the last test case. In this, we basically don't ground any of the factor and run the simulation.

### Moniters
1. **Total-customers** moniters the total number of customers visited the store in the day.
2. **Total-purchased-items** moniters the total number of items purchased by the customers in the day.
3. **Average-possesion-money** moniters the average money possesed by each customer who visited the store in the day.
4. **Average-staying-time** moniters the average staying time of each customer who visited the store in the day.
5. **Average-money-spent** moniters the average money spent by each customer who visited the store in the day.
6. **Satisfaction-level** records the feedback of each customers who visited the shop.

### General sliders.
1. **max-customer-limit** is used to set the maximum number of customers limit in a **complete run**.
2. **customer-entrance-rate** is used to set the rate at which customers enter the store
3. **random-time-limit** is used to set the time limit randomly to each customers.
4. **sample-size** is used in the **Sampling** where it represents the size of the sample.
5. **min-possesion-money & max-possesion** are used to set the minimum and maximum possesion money each customer has.
6. **min-section-budget & max-section-budget** are used to set the minimum and maximum section budget of each customer.
7. **min-items & max-items** are used to set the minimum and maximum items each customer wants to purchase in each section.
8. **stock-amount** is used to set the maximum amount of stock available in the store.

After adjusting all the necessary sliders to your own will, we can start the simulation.
Make sure to check the moniters for the outputs and other details.


## THINGS TO NOTICE

The plot of the customers satisfaction level is to be noticed where the sales promotion plays a crucial role in identifying the problem. Adjust the stock slider, or the expiry date slider to see the trend in the plots. The total number of shopped items also will change based on the stock quantity and the expiry date factor.

When you change the testcase, you will see different trends in the plots and the moniters. For the second case, the number of products purchased will be less compared to the first test case.

In this way we need to observe the results by analysing the plots and the moniters.

## THINGS TO TRY

1. Change the testcase of the model and run the simulation multiple times.
2. Use the behavioral space tool to analyse the results of each test case.
3. Adjust the sliders at your own will and analyse the plots.

## EXTENDING THE MODEL

* This model can be further extended by adding a queuing system at the register section.
* Introducing the agent to agent interaction is also an interesting way to extend this model. 
* We can even introduce some scenarios where the customer forgets to buy some products and reminds of it before the checkout process, so that he will once again buy those products.
* Recent pandemic can also be introduced and we can add the social distancing in the model and analyse the sales promotion in it.
## NETLOGO FEATURES

The only feature that this model uses is the behaviorial space , to apply the statistical testing for the results of the experiment.

*No other netlogo features are used in this*.

## CREDITS AND REFERENCES

* **Reference**: https://www.semanticscholar.org/paper/How-Do-Customers-Buy-Them-at-a-Supermarket-Behavior-Kitazawa-Sato/d109070e7d853a8a9133e5378b504a69bcb337bf


* **Credits**: https://github.com/terman37/NetLogo-Agent_Based_Modeling-SuperMarket
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="shoppinglist-money-model-1" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>start-simulation</go>
    <exitCondition>ticks = 1000</exitCondition>
    <metric>total-possesion-money</metric>
    <metric>total-customers</metric>
    <enumeratedValueSet variable="max-possesion-money">
      <value value="886"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="behavioral-model-choice">
      <value value="&quot;Shopping List &amp; Money Model&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-time-limit">
      <value value="1548"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-items">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-section-budget">
      <value value="419"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Runtime-choice">
      <value value="&quot;Complete run&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-customers-limit">
      <value value="13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sample-size">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="customer-entrance-rate">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-items">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-possesion-money">
      <value value="489"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-section-budget">
      <value value="1592"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="shoppinglist-timelimit-model-2" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>start-simulation</go>
    <exitCondition>ticks = 1000</exitCondition>
    <metric>total-staying-time</metric>
    <metric>total-customers</metric>
    <enumeratedValueSet variable="max-possesion-money">
      <value value="886"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="behavioral-model-choice">
      <value value="&quot;Shopping List &amp; Time Model&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-time-limit">
      <value value="1548"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-items">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-section-budget">
      <value value="419"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Runtime-choice">
      <value value="&quot;Complete run&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-customers-limit">
      <value value="13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sample-size">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="customer-entrance-rate">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-items">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-possesion-money">
      <value value="489"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-section-budget">
      <value value="1592"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="shoppinglist-money-timelimit-model-3" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>start-simulation</go>
    <exitCondition>ticks = 1000</exitCondition>
    <metric>total-possesion-money</metric>
    <metric>total-staying-time</metric>
    <metric>total-customers</metric>
    <enumeratedValueSet variable="max-possesion-money">
      <value value="886"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="behavioral-model-choice">
      <value value="&quot;Shopping List, Money &amp; Time Model&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-time-limit">
      <value value="1548"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-items">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-section-budget">
      <value value="419"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Runtime-choice">
      <value value="&quot;Complete run&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-customers-limit">
      <value value="13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sample-size">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="customer-entrance-rate">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-items">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-possesion-money">
      <value value="489"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-section-budget">
      <value value="1592"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
