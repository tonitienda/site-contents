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

Notes on the chart:

- First weeks were irregular. Trying to build the habit and no structure
- At some point around Week 4 the route and structure stabilized.
- At some point around Week 6 or 7 I fixed the structure to 33mins in total, 7 of them jogging.
- Mid Week 8 I extended the walking time at the beginning and started doing 38 mins in total, still 7 of them jogging.
- At Week 10 I started allowing some extra jogging blocks when I felt good. No purpose, just enjoying.
- Around Week 12 I started controlling my breath to cap my effort doing 4-step inhale 7-step exhale (in sloped I would change to 6-step exhale)
- During Week 13 and beginning of 14 I overdid a bit. Coming back to a calm pace half way through week 14.

```nagare
chart
title: Training Metrics
width: 1000
height: 420
xaxis: date
xlabel: Date
legend: top-left
grid: true

scale
  id: time
  label: Time
  type: duration

scale
  id: distance
  label: Distance (Kms)
  type: number
  min: 0
  max: 5

scale
  id: blocks
  label: Blocks
  type: number
  min: 0
  max: 5

series: jog time | walk time | total distance | jog blocks
color:  #003366 | #336699 | #339966 | #eeeeee
style: bar | bar | line | marker
stack: session | session | none | none
yaxis: time | time | distance | blocks
type: duration | duration | number | number
data:
  2025-12-18: 3:51  | 25:04 | 2.95 | 1
  2025-12-19: 7:29  | 20:02 | 2.88 | 2
  2025-12-20: 6:52  | 22:02 | 3.03 | 1
  2025-12-22: 8:10  | 28:46 | 3.70 | 2
  2025-12-24: 8:19  | 24:50 | 3.44 | 2
  2025-12-26: 10:06 | 17:42 | 3.04 | 3
  2025-12-27: 5:37  | 30:13 | 3.84 | 1
  2025-12-29: 10:53 | 27:19 | 3.90 | 3
  2025-12-31: 7:37  | 20:46 | 2.82 | 2
  2026-01-01: 0:00  | 31:13 | 3.02 | 0
  2026-01-02: 3:31  | 26:44 | 2.99 | 1
  2026-01-03: 5:21  | 27:08 | 3.13 | 1
  2026-01-05: 6:35  | 27:04 | 3.40 | 1
  2026-01-06: 6:55  | 25:48 | 3.24 | 1
  2026-01-07: 7:58  | 22:04 | 3.02 | 1
  2026-01-09: 5:37  | 23:18 | 2.84 | 1
  2026-01-11: 6:38  | 27:38 | 3.41 | 1
  2026-01-12: 7:03  | 27:40 | 3.47 | 1
  2026-01-13: 7:04  | 26:35 | 3.36 | 1
  2026-01-14: 7:17  | 25:45 | 3.37 | 1
  2026-01-16: 5:27  | 27:49 | 3.41 | 1
  2026-01-17: 6:59  | 25:52 | 3.35 | 1
  2026-01-20: 6:48  | 26:17 | 3.34 | 1
  2026-01-21: 6:07  | 27:21 | 3.35 | 1
  2026-01-23: 7:04  | 25:43 | 3.40 | 1
  2026-01-25: 6:39  | 26:38 | 3.44 | 1
  2026-01-26: 7:44  | 25:59 | 3.40 | 1
  2026-01-27: 7:06  | 25:39 | 3.43 | 1
  2026-01-28: 6:47  | 26:16 | 3.47 | 1
  2026-01-29: 7:07  | 26:22 | 3.50 | 1
  2026-01-30: 6:58  | 26:16 | 3.51 | 1
  2026-01-31: 7:06  | 26:02 | 3.45 | 1
  2026-02-02: 7:56  | 26:05 | 3.44 | 1
  2026-02-03: 7:09  | 26:09 | 3.48 | 1
  2026-02-04: 7:00  | 26:01 | 3.42 | 1
  2026-02-06: 7:09  | 31:23 | 4.11 | 1
  2026-02-08: 7:23  | 30:52 | 4.04 | 1
  2026-02-09: 7:02  | 31:09 | 4.04 | 1
  2026-02-10: 7:09  | 31:02 | 3.98 | 1
  2026-02-11: 7:21  | 31:10 | 4.14 | 1
  2026-02-13: 7:28  | 30:46 | 3.95 | 1
  2026-02-17: 8:24  | 30:04 | 4.12 | 2
  2026-02-18: 7:52  | 31:12 | 4.08 | 1
  2026-02-19: 7:10  | 31:21 | 4.04 | 1
  2026-02-22: 8:04  | 30:19 | 4.01 | 1
  2026-02-24: 8:06  | 30:08 | 4.09 | 1
  2026-02-25: 8:12  | 30:18 | 4.21 | 1
  2026-03-04: 7:34  | 31:26 | 4.10 | 1
  2026-03-08: 12:44 | 26:23 | 4.36 | 2
  2026-03-09: 8:59  | 30:15 | 4.10 | 1
  2026-03-10: 8:53  | 29:13 | 4.04 | 1
  2026-03-12: 8:43  | 30:16 | 4.06 | 1
  2026-03-13: 8:35  | 30:21 | 4.29 | 1
  2026-03-14: 9:07  | 29:32 | 4.13 | 1
  2026-03-17: 13:19 | 25:36 | 4.36 | 2
  2026-03-18: 13:28 | 25:35 | 4.42 | 2
  2026-03-19: 13:42 | 25:01 | 4.25 | 2
  2026-03-23: 13:30 | 26:41 | 4.53 | 2
  2026-03-24: 13:43 | 24:28 | 4.40 | 2
  2026-03-26: 13:30 | 25:04 | 4.50 | 2
  2026-03-27: 13:27 | 24:56 | 4.45 | 2
```

Legacy Diagram:

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
color:  #cc9999 | #aa7777 | #9999cc | #7777aa | #aaaaaa
style: dashed | line | dashed | line | dashed
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
  2026-02-18: 39:04 | 7:52  | 4.08  | 0.96 | 1
  2026-02-19: 38:31 | 7:10  | 4.04  | 0.87 | 1
  2026-02-22: 38:23 | 8:04  | 4.01  | 1.03 | 1
  2026-02-24: 38:14 | 8:06  | 4.09  | 1.02 | 1
  2026-02-25: 38:30 | 8:12  | 4.21  | 1.12 | 1
  2026-03-04: 39:00 | 7:34  | 4.1   | 0.99 | 1
  2026-03-08: 39:07 | 12:44 | 4.36  | 1.69 | 2
  2026-03-09: 39:14 | 8:59  | 4.10  | 1.14 | 1
  2026-03-10: 38:06 | 8:53  | 4.04  | 1.15 | 1
  2026-03-12: 38:59 | 8:43  | 4.06  | 1.14 | 1
  2026-03-13: 38:56 | 8:35  | 4.29  | 1.49 | 1
  2026-03-14: 38:39 | 9:07  | 4.13  | 1.15 | 1
  2026-03-17: 38:55 | 13:19 | 4.36  | 1.79 | 2
  2026-03-18: 39:03 | 13:28 | 4.42  | 1.85 | 2
  2026-03-19: 38:43 | 13:42 | 4.25  | 1.78 | 2
  2026-03-23: 40:11 | 13:30 | 4.53  | 1.86 | 2
  2026-03-24: 38:11 | 13:43 | 4.40  | 1.87 | 2
  2026-03-26: 38:34 | 13:30 | 4.50  | 1.88 | 2
  2026-03-27: 38:23 | 13:27 | 4.45  | 1.93 | 2
```
