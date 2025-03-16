# Why The 2025 Provisional Rally Scoring Pickleball Rules Are Biased Towards Right Side Serving (And Why This Is Probably Unfair)

One of the other players in our pickleball group recently mentioned the new rally scoring rules.

To be precise: the provisional rally scoring rules for doubles as [introduced](https://usapickleball.org/docs/2025-USA-Pickleball-Rulebook-Change-Document.pdf) in the [2025 USA Pickleball Rulebook](https://usapickleball.org/docs/2025-USA-Pickleball-Rulebook.pdf).

During our weekly play, we tried things out and reread the rules. Our conclusion: there is something odd about the "forced" right side serving after a side-out by means of (sometimes) switching player sides based on odd/even current score. This causes _every_ round of serving to start on the right side, which leads to more right side serves than left side serves.

A couple of days later, I realized that it should be possible to run a pickleball scoring simulator. The winner of every point is decided by a coin-flip-like mechanism, leading to a 50/50 chance for both teams to win every point. Within a couple of seconds, the simulator can play a million points, while keeping track on the number of left-side and right-side serves for all four players.

In this article, the results of these simulations are used to show the differences between three types of doubles scoring:

1. Traditional scoring following the official (non-provisional) 2025 scoring rules
2. Rally scoring following the provisional 2025 rally scoring rules
3. Rally-no-switch scoring, a possible alternative to the current provisional rules

See [./simulator.exs] for full source code and instructions on how to run the script. The script is written in Elixir, only because that is the programming language I currenly use most.

## Simulator results

In the simulator, team `a` plays against team `b`. Both teams have players `1` and `2`. Player `1` of each team starts the game on the right side of the court, reasoning from their own side of the net.

This gives us the following starting position:


```
   -------------
  |  a1  |  a2  |
  |      |      |
  |      |      |
  |-------------|
  |             |
-------------------
  |             |
  |-------------|
  |      |      |
  |      |      |
  |  b2  |  b1  |
   -------------
```


For each player, the simulator counts the number of serves _and_ from which side of the court.

The starting situation is as follows:

|     |a1|a2|b1|b2|
|-----|-:|-:|-:|-:|
|right| 0| 0| 0| 0|
|left | 0| 0| 0| 0|

Player `a1` always starts with the first serve. The count then changes as follows:

|     |a1|a2|b1|b2|
|-----|-:|-:|-:|-:|
|right| 1| 0| 0| 0|
|left | 0| 0| 0| 0|

After that, the next server and their position on the court are determined by:

- who wins the point (serving or receiving team), and
- the scoring rules for the current simulation

For every serve played, the serve count is incremented for the corresponding player and side.

### Traditional scoring

As a benchmark, let's see how traditional scoring performs in terms of left/right serving.

After playing one million serves, the simulator will show serve counts roughly equivalent to this:

|     |a1    |a2    |b1    |b2    |
|-----|-----:|-----:|-----:|-----:|
|right|138948|138994|138883|138589|
|left |111415|111020|111192|110959|

Note that the exact numbers vary between simulations. This is due to the deliberately introduced randomness for individual rally wins.

What can be seen is that for every 5 right-side services, there are 4 left-side services.

While it could be fun to prove this mathematically, this is out of scope of this article.

In short, this makes sense, as every service turn starts on the right side. The second server guarantees that there will always be at least one left-side service. In the long run, however, serving teams will score 50% odd and 50% even numbers of points on their service. Every time an odd number of points is scored, the team will have one right-side service more than they have left-side services, thus leading to a minor right-side serving bias.

### 2025 provisional rally point scoring

Now, let's see how the 2025 rally point scoring rules performs.

After simulating one million serves, a typical result will look like this:

|     |a1    |a2    |b1    |b2    |
|-----|-----:|-----:|-----:|-----:|
|right|166736|166573|166543|166285|
|left | 83522| 83359| 83620| 83362|

Now there are 2 right-side services for every left-side service.

This is quite different to traditional scoring.

Again, this can be explained. As in traditional scoring, every service turn is started on the right side of the court. The odd/even scoring position alignment after a side-out guarantees that both players serve in turn, which is also shown in the simulator results. However, this also causes a major right-side serving bias, as there is no longer a second server that guarantees at least one left-side service on every team's service turn.

In fact, given a situation where all points are won by the receiving team, no player would ever serve from the left side of the court.

In real life, this will seldom be the case, but it illustrates the point of right-side serving bias caused by the 2025 provisional rally scoring rules.

## Why is this a problem?

Before turning to a proposed solution, first we should ask ourselves: is right-side serving bias a problem, and if so, why?

Serving side bias wouldn't be problematic if all pickleball players would be right-handed. (Or all left-handed, for that matter.)

Would this be the case, then all servers would be able to make the same angles, as their hand positions would be the same.

In practice, this is not the case, as about 10% of the population is left-handed.

For a left-handed player, serving from the right side of the court makes if harder to make sharp angles towards the outside of the court. While serving, both feet must be inside the service area, of which the boundary also includes the imaginary sideline extension behind the baseline. Right-handed servers can extend their playing hand outside the court, which left-handed servers cannot do due to their mirrored body position.

This is partly compensated by having the possibility to hit the ball further inside the court on the other side of the service area, but not completely. This can be best made clear by a visual representation:




### Proposal: rally scoring without right-side bias


|     |a1    |a2    |b1    |b2    |
|-----|-----:|-----:|-----:|-----:|
|right|124733|125104|124929|125234|
|left |125003|124833|125497|124667|

