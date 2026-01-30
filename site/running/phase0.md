# Back to running – Phase 0: Reconnect

> **Why this exists**
> This is not a success story or a training plan to follow. It’s a log for my future self—something to reread if I stop running again and need a calm, realistic way back. If it helps someone in their 40s (or later) feel that _ordinary people can enjoy running again_, that’s a bonus.

I’m intentionally keeping this short, skimmable, and boring-in-a-good-way. Deep dives (shoes, nutrition, philosophy) will live in separate posts and be linked from here.

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

---

## Current status

### Duration

- **7 weeks so far**
- Likely 8–9 weeks total, reassessed week by week

### What changed so far

- Heart rate is less spiky and more predictable
- Pace at ≤125 bpm:
  - Start: ~**9:30 min/km**
  - After ~4–5 weeks: ~**8:30 min/km**

- Legs feel more "alive"
  - Not real muscle growth yet
  - Mostly glycogen + water + blood flow
  - Still: noticeable and motivating

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

## Next phase (tentative)

### Planned change: _one variable only_

Either:

- Increase total time to **~38 min**, keep jogging at ~7 min
  **or**
- Increase jogging to **~10 min**, keep total time at ~33 min

### When Phase 1 starts

- Route and pace feel stable
- Walk/run sessions feel normal and unremarkable
- Running is no longer an "event" — just something I do

---

## Metrics

Early sessions were inconsistent, including a fully walking day. Over time, sessions became more regular, predictable, and heart rate stabilized.

(I track / act upon weekly trends rather than judging individual sessions.)

```nagare
chart
title: Training Metrics
width: 900
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
  max: 4



series: total time | jog time | total distance | jog distance
color:  #1d39b7 | #3b82f6 | #8c1010 | #ef4444
style: line | line | line | line
yaxis: time | time | distance | distance
type: duration | duration | number | number
data:
  2025-12-18: 28:55 | 3:51  | 2.95  | 0.42
  2025-12-19: 27:31 | 7:29  | 2.88  | 0.86
  2025-12-20: 28:54 | 6:52  | 3.03  | 0.79
  2025-12-22: 36:56 | 8:10  | 3.70  | 0.89
  2025-12-24: 33:09 | 8:19  | 3.44  | 0.93
  2025-12-26: 27:48 | 10:06 | 3.04  | 1.23
  2025-12-27: 35:50 | 5:37  | 3.84  | 0.68
  2025-12-29: 38:12 | 10:53 | 3.90  | 1.25
  2025-12-31: 28:23 | 7:37  | 2.82  | 0.87
  2026-01-01: 31:13 | 0:00  | 3.02  | 0
  2026-01-02: 30:15 | 3:31  | 2.99  | 0.42
  2026-01-03: 32:29 | 5:21  | 3.13  | 0.63
  2026-01-05: 33:39 | 6:35  | 3.40  | 0.79
  2026-01-06: 32:43 | 6:55  | 3.24  | 0.82
  2026-01-07: 30:02 | 7:58  | 3.02  | 0.91
  2026-01-09: 28:55 | 5:37  | 2.84  | 0.71
  2026-01-11: 34:16 | 6:38  | 3.41  | 0.80
  2026-01-12: 34:43 | 7:03  | 3.47  | 0.83
  2026-01-13: 33:39 | 7:04  | 3.36  | 0.83
  2026-01-14: 33:02 | 7:17  | 3.37  | 0.86
  2026-01-16: 33:16 | 5:27  | 3.41  | 0.70
  2026-01-17: 32:51 | 6:59  | 3.35  | 0.84
  2026-01-20: 33:05 | 6:48  | 3.34  | 0.81
  2026-01-21: 33:28 | 6:07  | 3.35  | 0.72
  2026-01-23: 32:47 | 7:04  | 3.40  | 0.85
  2026-01-25: 33:17 | 6:39  | 3.44  | 0.82
  2026-01-26: 33:43 | 7:44  | 3.40  | 0.91
  2026-01-27: 32:45 | 7:06  | 3.43  | 0.88
  2026-01-28: 33:03 | 6:47  | 3.47  | 0.82
  2026-01-29: 33:29 | 7:07  | 3.50  | 0.83
  2026-01-30: 33:14 | 6:58  | 3.51  | 0.86
```
