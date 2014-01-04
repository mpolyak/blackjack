Blackjack
=========

#####Blackjack game simulator for determining optimal playing and betting strategy.
This simulation can be setup to run a number of playing and betting strategies for a specified number of games and hands.It will output results to stdout in a table format.

Version
-------

0.1.0

Technologies
------------

[CoffeScript] - CoffeeScript is a little language that compiles into JavaScript.

[Ascii Table] - Easy table output for node debugging, but you could probably do more with it, since its just a string.

Installation
------------
From the command line run the following commands:
```
git clone https://github.com/mpolyak/blackjack.git blackjack
cd blackjack
npm install
cake sbuild
```
Edit **coffee/main.coffee** and set **tables** variable to point to the game tables you wish to simulate, for example:

```
tables = STRATEGY_EDGE_TABLES
```
After configurating the desired simulation, run the script:

```
node coffee/main
```
Simulation
==========
There are certain assumption built in to the simulation in regards to the rules used for playing Blackjack.

* Dealer will hit on a hard 16 and below, or on a soft 17.
* Aces may be re-split up to four times.
* Double-down on 2 cards only with set hands unique to each playing strategy.
* Surrender is not allowed.
* Dealer peeks for Blackjack.
* Blackjack payout is 6/5.
* Bet amount is set to $1.

Playing Strategies
------------------
The following are the playing strategies available for simulation:
* **Dealer** - Play as if you are the dealer.
* **Never Bust** - Stand on a hard 12 or above.
* **[Basic]** - Blackjack Basic Strategy
* **[Wizard]** - Wizard's Simple Strategy
* **[Simple]** - A varaition of the Wizard strategy.

Betting Strategies
------------------
There are three betting strategies available for simulation:
* **Constant** - Player will bet a constant amount on each hand.
* **Increment** - Player will increment bet size by the original bet amount after every win and will reset to original bet size on a loss.
* **Double** - Player will double the bet amount after every 2nd win and will reset to the original bet amount on a loss.

Strategy Edges
--------------
Simulating available playing strategies for a game of **1,000,000** hands.

| # | Games |  Hands  |  Strategy  | Wins % | Loss % | Draw % | Max Cons Wins | Max Cons Loss | Avg Cons Wins | Avg Cons Loss | Edge % |
|:-:|:-----:|:-------:|:----------:|:------:|:------:|:------:|:-------------:|:-------------:|:-------------:|:-------------:|:------:|
| 1 |     1 | 1000000 | Dealer     |  39.09 |   51.6 |   9.32 |            18 |            21 |             3 |             3 | -24.25 |
| 2 |     1 | 1000000 | Never Bust |  41.26 |  52.78 |   5.96 |            14 |            24 |             3 |             3 | -21.83 |
| 3 |     1 | 1000000 | Basic      |  44.64 |  47.42 |   7.94 |            27 |            18 |             3 |             3 |  -5.88 |
| **4** |     1 | 1000000 | **Wizard**     |  45.02 |  47.09 |   7.89 |            18 |            23 |             3 |             3 |  **-4.39** |
| 5 |     1 | 1000000 | Simple     |  44.91 |  47.02 |   8.07 |            18 |            20 |             3 |             3 |  -4.49 |

We will select the **[Wizard]** playing strategy since it has an effective edge and is simple to play.

Optimial Number Of Hands
-------------------------
Having selected the **[Wizard]** strategy, the next step is to determine how many hands per game is the optimal number. For that we will simulate **100,000** games with a hand count ranging from **1 to 20**.

Since resulting values will be averaged accross the games, the table will be presenting values in the following format: **MIN/AVG/MAX**

| #  | Games  | Hands | Strategy |      Wins %      |      Loss %      |    Draw %    | Max Cons Wins | Max Cons Loss | Avg Cons Wins | Avg Cons Loss |      Edge %      |
|:--:|:------:|:-----:|:--------:|:----------------:|:----------------:|:------------:|:-------------:|:-------------:|:-------------:|:-------------:|:----------------:|
|  1 | 100000 |     1 | Wizard   | 0/44.69/100      | 0/47.19/100      | 0/8.12/100   | 0/0/4         | 0/0/3         | 0/0/3         | 0/0/3         | -100/-2.57/200   |
|  2 | 100000 |     2 | Wizard   | 0/44.96/100      | 0/47.13/100      | 0/7.91/100   | 0/1/5         | 0/1/5         | 0/0/4         | 0/0/4         | -100/-1.77/300   |
|  3 | 100000 |     3 | Wizard   | 0/44.82/100      | 0/47.29/100      | 0/7.89/100   | 0/1/7         | 0/1/5         | 0/1/5         | 0/1/4         | -100/12.38/500   |
|  4 | 100000 |     4 | Wizard   | 0/44.85/100      | 0/47.15/100      | 0/8/100      | 0/2/7         | 0/2/7         | 0/1/5         | 0/1/5         | -100/25.33/600   |
|  5 | 100000 |     5 | Wizard   | 0/44.97/100      | 0/46.97/100      | 0/8.06/100   | 0/2/8         | 0/2/7         | 0/1/5         | 0/1/5         | -100/33.36/600   |
|  **6** | 100000 |     6 | **Wizard**   | 0/44.95/100      | 0/47.02/100      | 0/8.03/83.33 | 0/2/8         | 0/2/8         | 0/1/5         | 0/2/5         | -100/**35.5**/700    |
|  7 | 100000 |     7 | Wizard   | 0/44.95/100      | 0/47.12/100      | 0/7.94/71.43 | 0/2/9         | 0/2/9         | 0/2/6         | 0/2/6         | -100/34.41/800   |
|  8 | 100000 |     8 | Wizard   | 0/44.82/100      | 0/47.19/100      | 0/8/75       | 0/2/10        | 0/3/10        | 0/2/6         | 0/2/6         | -100/31.03/900   |
|  9 | 100000 |     9 | Wizard   | 0/45/100         | 0/47.05/100      | 0/7.94/77.78 | 0/3/11        | 0/3/11        | 0/2/7         | 0/2/7         | -100/28.99/1000  |
| 10 | 100000 |    10 | Wizard   | 0/44.98/100      | 0/47.08/100      | 0/7.94/60    | 0/3/12        | 0/3/11        | 0/2/7         | 0/2/7         | -100/25.41/1000  |
| 11 | 100000 |    11 | Wizard   | 0/45.01/100      | 0/46.99/100      | 0/7.99/63.64 | 0/3/13        | 0/3/12        | 0/2/8         | 0/2/7         | -100/22.78/1100  |
| 12 | 100000 |    12 | Wizard   | 0/45.03/100      | 0/47.05/100      | 0/7.91/58.33 | 0/3/13        | 0/3/13        | 0/2/8         | 0/2/8         | -100/19.87/1400  |
| 13 | 100000 |    13 | Wizard   | 0/44.94/100      | 0/47.12/100      | 0/7.94/50    | 0/3/13        | 0/3/14        | 0/2/8         | 0/2/8         | -100/17.14/1400  |
| 14 | 100000 |    14 | Wizard   | 0/44.99/93.33    | 0/47.05/100      | 0/7.96/53.33 | 0/3/13        | 0/3/15        | 0/2/8         | 0/2/9         | -100/15.51/1300  |
| 15 | 100000 |    15 | Wizard   | 0/44.94/93.75    | 0/47.11/100      | 0/7.95/46.67 | 0/3/14        | 0/3/15        | 0/2/8         | 0/2/9         | -100/13.5/1400   |
| 16 | 100000 |    16 | Wizard   | 0/44.93/94.12    | 0/47.09/100      | 0/7.99/44.44 | 0/3/16        | 0/3/17        | 0/2/9         | 0/3/10        | -100/12.02/1500  |
| 17 | 100000 |    17 | Wizard   | 0/44.88/94.74    | 0/47.18/94.12    | 0/7.94/44.44 | 0/3/15        | 0/4/16        | 0/2/9         | 0/3/9         | -100/10.3/1700   |
| 18 | 100000 |    18 | Wizard   | 0/44.97/94.74    | 0/47.05/94.74    | 0/7.98/44.44 | 0/3/18        | 0/4/18        | 0/3/10        | 0/3/10        | -100/9.77/1500   |
| 19 | 100000 |    19 | Wizard   | 5/44.92/90       | 4.76/47.12/94.74 | 0/7.96/47.37 | 1/4/18        | 1/4/18        | 0/3/10        | 0/3/10        | -94.44/8.56/1600 |
| 20 | 100000 |    20 | Wizard   | 4.76/45.02/90.48 | 0/47.04/95       | 0/7.94/45    | 1/4/17        | 0/4/19        | 0/3/10        | 0/3/11        | -94.74/8.12/1600 |

Simulation results indicate that between **5 and 7** hands it the optimal number of hands to play for any single game before expected edge starts to diminish. 

Optimal Betting Strategy
------------------------
Based on the preceding table, the number of **6** hands per game is selected to be used in testing the optimal betting strategy.

This simulation plays **1,000,000** games of **6** hands for the three kinds of betting strategies.

| # |  Games  | Hands |  Betting  |   Min PnL $   |  Max PnL $  |     PnL $     | Capital $ |     ROI %     | Hands to Min PnL | Hands to Max PnL | Min PnL to Flat | Max PnL to Flat | Exp per Hand $  |
|:-:|:-------:|:-----:|:---------:|:-------------:|:-----------:|:-------------:|:---------:|:-------------:|:----------------:|:----------------:|:---------------:|:---------------:|:---------------:|
| 1 | 1000000 |     6 | Constant  | -11/-1.68/0   | 0/1.72/12   | -11/0.05/12   | 1/4.46/12 | 0/77.28/1200  | 0/3/11           | 0/3/11           | 0/1/7           | 0/1/7           | -1.67/0.01/1.7  |
| 2 | 1000000 |     6 | **Increment** | -12.8/-2.54/0 | 0/3.33/48   | -12.8/**0.06**/48 | 1/5.99/19 | 0/**112.25**/4800 | 0/4/11           | 0/**3**/11           | 0/1/6           | 0/1/6           | -1.83/0.01/6.86 |
| 3 | 1000000 |     6 | Double    | -11/-1.82/0   | 0/2.23/29.2 | -11/0.05/29.2 | 1/4.8/15  | 0/84.29/2920  | 0/3/10           | 0/3/11           | 0/0/6           | 0/1/7           | -1.67/0.01/4.4  |

The **Increment** betting strategy seems to provide the best results in terms of average overall expected PnL and ROI. While the **Double** strategy shows a lower capital requirement with a lower expected PnL and ROI. Finally, the **Constant** has the least capital requirements but with an expected breakeven PnL.

Conclusion
==========
* Play utilizing the **[Wizard]** strategy.
* If you are not in the money **7** hands in to the game, it may be time to stop.
* If you are ahead by the **3** hand and you start losing, it may be advisable to quit ahead.
* Use the **Increment** or **Double** betting strategy depending on your risk tolerance.

License
----

MIT

[CoffeScript]:http://coffeescript.org/
[Ascii Table]:https://github.com/sorensen/ascii-table/
[Basic]:http://en.wikipedia.org/wiki/Blackjack#Basic_strategy
[Wizard]:http://wizardofodds.com/games/blackjack/
[Simple]:http://wizardofodds.com/blackjack/images/wizard-simple-exceptions.gif
