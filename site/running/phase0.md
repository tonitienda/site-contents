# Back to running – Phase 0: Reconnect

> **Why this exists**
> This is not a success story or a training plan to follow. It’s a log for my future self—something to reread if I stop running again and need a calm, realistic way back. If it helps someone in their 40s (or later) feel that _ordinary people can enjoy running again_, that’s a bonus.

I’m intentionally keeping this short, skimmable, and boring-in-a-good-way. Deep dives (shoes, nutrition, philosophy) if they exist, will live in separate posts and be linked from here.

[Jump to the metrics](#metrics)

---

## Preconditions

- Mid‑40s
- 4–5 years without running consistently
- Last “long” run: **18 km in 2020**, suffered the whole way

---

## Phase 0 – Plan

### Goals

- Rebuild the habit
- Teach the nervous system that running is _not_ an emergency
- Small, secondary fitness improvements

### Non‑goals

- Performance gains
- Strength gains
- Weight loss

### Main risks

- Losing motivation and disappearing quietly
- Rushing progress for short‑term validation

### Execution rules

- Walk + short jogging intervals
- Keep heart rate **≤ 125 bpm** (best effort, not obsession)
- Show up **~5× per week** (imperfect attendance allowed)
- Rest when needed — forcing things now would be counter‑productive
- Feel better and more energized after the walk/run than before.

---

## Current status

### Duration

- **8 weeks so far**

### What changed so far

#### Weeks 1-4

- Heart rate is spiky.
  - Small increase in pace / slope HR goes up quickly.
  - Slowing down does not bring HR down. I need to walk for that.
- Pace at ≤125 bpm: ~**9:30 min/km**

#### Structure

Pace, route, duration, etc. changing day by day and slowly stabilizing.

Started to run [distance-bound](starting-distance-vs-time-bound-sessions.html): same path.

- Walking ~**30 min**
- Jogging ~**5-9 min** (depending on the day)

#### Weeks 4-7

- Heart rate is less spiky and more predictable
- Pace at ≤125 bpm: ~**8:30 min/km**
- Legs feel more "alive"
  - Not real muscle growth yet
  - Mostly glycogen + water + blood flow
  - Still: noticeable and motivating

##### Structure:

Started to do the sessions [time bound](starting-distance-vs-time-bound-sessions.html). Same time getting more distance over time.

- Walking ~**33 min**
- Jogging ~**7 min** (depending on the day)

#### Weeks 8-now

- Good and tired days are noticeable
  - Good days I feel very relaxed and calm
  - I allow bad days to be slow. Even these days HR is smooth and less spike

##### Structure

Mid week 8 I added more walking at the start:

- Walking ~**38 min**
- Jogging ~**7 min** (depending on the day)

---

## Gear

### Clothing

- Normal, weather‑appropriate clothes
- Nothing technical, nothing special

### Shoes

- **Merrell Vapor Glove 6**
  - I’ve used Vapor Gloves for years (walking + past running)
  - Tried another minimal shoe → didn’t like the feel
  - Sticking with these for now
  - Re‑evaluation later if jogging volume increases
  - Historically I ran up to **18 km** in Vapor Glove 4, so no urgency

### Accessories

- Garmin Forerunner 245 (bought in 2020)

---

## Nutrition

- No intentional nutrition changes for this phase

- I already take:
  - Protein powder
  - Creatine
    (not because of running)

- Around weeks **6–7**:
  - Increased hunger
  - More craving for _actual food_
  - Less interest in junk

- I’m listening, but not planning or optimizing yet

---

## Training execution (what this looks like)

- Sessions: **~30 min**, recently **~33 min**
- Jogging time:
  - Started: ~5 min
  - Now: ~7 min

- Early sessions were irregular (even full walking days)
- Later adjustments:
  - Fixed route
  - Fixed total time (~33 min)
  - Let distance increase naturally

---

## Next phases (tentative)

### Phase 0.5: more load

Add some load to the current sessions.

- First Increase total time to **~38 min**, keep jogging at ~7 min

- Later Increase jogging to **~10 min**, keep total time at ~38 min

- Iterate

#### When Phase 0.5 starts

- Route and pace feel stable
- Walk/run sessions feel normal and unremarkable
- Running is no longer an "event" — just something I do

Probably Week 9.

### Phase 1: training starts

Phase 1 will focus on structured variation once the habit feels normal.

Therefore I will start having different types of sessions:

- **Easy**: similar to the ones at the end of Phase 0.5. 3 times per week.
- **Medium**: some more distance at the same effort (or slightly more effort). Once per week.
- **Long**: noticeable longer session af lower effort than easy. Once per week

#### When Phase 1 starts

Not sure yet. But at some point I will want to do longer sessions but not 5x per week. So I will add them as Medium and/or Long sessions and keep the rest stable for some time.

---

## Metrics

Early sessions were inconsistent, including a fully walking day. Over time, sessions became more regular, predictable, and heart rate stabilized.

Even though the metrics are recorded per session, I only look for patterns at the weekly level. Individual sessions don’t matter much.

```nagare
chart
title: Training Metrics
width: 1000
height: 400
xaxis: date
xlabel: Date
legend: top-left
grid: true

scale
  id: time
  label: time
  type: duration

scale
  id: distance
  label: Distance (Kms)
  type: number
  min: 0
  max: 5

scale
  id: blocks
  label: blocks
  type: number
  min: 0
  max: 5



series: total time | jog time | total distance | jog distance | job blocks
color:  #1d39b7 | #3b82f6 | #8c1010 | #ef4444 | #999999
style: line | line | line | line | line
yaxis: time | time | distance | distance | blocks
type: duration | duration | number | number | number
data:
  2025-12-18: 28:55 | 3:51  | 2.95  | 0.42 | 1
  2025-12-19: 27:31 | 7:29  | 2.88  | 0.86 | 2
  2025-12-20: 28:54 | 6:52  | 3.03  | 0.79 | 1
  2025-12-22: 36:56 | 8:10  | 3.70  | 0.89 | 2
  2025-12-24: 33:09 | 8:19  | 3.44  | 0.93 | 2
  2025-12-26: 27:48 | 10:06 | 3.04  | 1.23 | 3
  2025-12-27: 35:50 | 5:37  | 3.84  | 0.68 | 1
  2025-12-29: 38:12 | 10:53 | 3.90  | 1.25 | 3
  2025-12-31: 28:23 | 7:37  | 2.82  | 0.87 | 2
  2026-01-01: 31:13 | 0:00  | 3.02  | 0    | 0
  2026-01-02: 30:15 | 3:31  | 2.99  | 0.42 | 1
  2026-01-03: 32:29 | 5:21  | 3.13  | 0.63 | 1
  2026-01-05: 33:39 | 6:35  | 3.40  | 0.79 | 1
  2026-01-06: 32:43 | 6:55  | 3.24  | 0.82 | 1
  2026-01-07: 30:02 | 7:58  | 3.02  | 0.91 | 1
  2026-01-09: 28:55 | 5:37  | 2.84  | 0.71 | 1
  2026-01-11: 34:16 | 6:38  | 3.41  | 0.80 | 1
  2026-01-12: 34:43 | 7:03  | 3.47  | 0.83 | 1
  2026-01-13: 33:39 | 7:04  | 3.36  | 0.83 | 1
  2026-01-14: 33:02 | 7:17  | 3.37  | 0.86 | 1
  2026-01-16: 33:16 | 5:27  | 3.41  | 0.70 | 1
  2026-01-17: 32:51 | 6:59  | 3.35  | 0.84 | 1
  2026-01-20: 33:05 | 6:48  | 3.34  | 0.81 | 1
  2026-01-21: 33:28 | 6:07  | 3.35  | 0.72 | 1
  2026-01-23: 32:47 | 7:04  | 3.40  | 0.85 | 1
  2026-01-25: 33:17 | 6:39  | 3.44  | 0.82 | 1
  2026-01-26: 33:43 | 7:44  | 3.40  | 0.91 | 1
  2026-01-27: 32:45 | 7:06  | 3.43  | 0.88 | 1
  2026-01-28: 33:03 | 6:47  | 3.47  | 0.82 | 1
  2026-01-29: 33:29 | 7:07  | 3.50  | 0.83 | 1
  2026-01-30: 33:14 | 6:58  | 3.51  | 0.86 | 1
  2026-01-31: 33:08 | 7:06  | 3.45  | 0.87 | 1
  2026-02-02: 34:01 | 7:56  | 3.44  | 0.92 | 1
  2026-02-03: 33:18 | 7:09  | 3.48  | 0.89 | 1
  2026-02-04: 33:01 | 7:00  | 3.42  | 0.83 | 1
  2026-02-06: 38:32 | 7:09  | 4.11  | 0.91 | 1
  2026-02-08: 38:15 | 7:23  | 4.04  | 0.92 | 1
  2026-02-09: 38:11 | 7:02  | 4.04  | 0.86 | 1
  2026-02-10: 38:11 | 7:09  | 3.98  | 0.88 | 1
  2026-02-11: 38:31 | 7:21  | 4.14  | 0.93 | 1
  2026-02-13: 38:14 | 7:28  | 3.95  | 0.92 | 1
  2026-02-17: 38:28 | 8:24  | 4.12  | 1.11 | 2
```

Notes on the chart:

- First weeks were irregular. Trying to build the habit and no structure
- At some point around Week 4 the route and structure stabilized.
- At some point around Week 6 or 7 I fixed the structure to 33mins in total, 7 of them jogging.
- Mid Week 8 I extended the walking time at the beginning and started doing 38 mins in total, still 7 of them jogging.
- Week 10 I started doing some extra jogging blocks when I felt good. No purpose, just enjoying.
