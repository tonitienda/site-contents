# Back to running - Phase 0

## Preconditions

- Mid 40's
- 4-5 years without running regularly
- Longest run 18Kms in 2020. Suffering.

## Plan

### Goals of this phase

- Build the habit.
- Training the nervous system to stay calm when running.
- Minor fitness improvements.

### Non Goals

- Improve performance
- Get stronger
- Loose weight

### Risks

- Lose motivation and stop showing up regularly
- Rush things to get short term improvements

### Execution Plan

- Walk with short portion of jogging
- Keep HR under 125 rpm (as much as possible)
- Show up 5 times per week (also best effort)
- Rest if needed. It would be counter productive to force now.

## Status

### Duration

7 weeks so far. Might take 9 weeks but not sure. I assess week by week.

### Experienced changes so far

- HR is less spiky and more stable
- Initial pace at < 125rpm was ~9:30 min/km. After some weeks (4 or 5) it got closer to 8:30min/km
- Legs muscles more plump.
  - No muscle mass or huge improvements yet. Only glycogen that also brings water and blood vessels dilated. So basically my legs have more water. But it stills feels good.

### Gear

#### Clothing

I use normal and warm clothing, nothing fancy.

#### Shoes

I use Merrel Vapor Glove 6. I have used Vapor Gloves for a long time now, for walking but also for running some years ago.
I tried another kind-of-minimal shoe, but I did not like the feeling so I keep using my Vapor Gloves.
As the jogging distance increases I might think about changing them. But in the past I could run 18Kms with my old Vapor Glove 4, so there is nothing decided.

### Nutrition

Because of my diet, I regularly take protein powder and creatine. Not because of running.

I did not change anything conciously as part of this phase.
From weeks 6-7 I started feeling more hungry. My body was asking for more actual FOOD and craving less junk food. I am listening to it but not making any plans.

### Execution

- I am doing sessions of ~30 minutes (lately became 33 minutes).
- I jogged for 5 minutes and now around 7 minutes.
- After some irregular sessions I started to fix the route and therefore the distance.
- In the later weeks I started fixing the route and the number of minutes (~33) so the total distance could increase over time.

## Next Phase

### Plan

Change one of two variables:

- Either lengthening the total time up to ~38 minutes and keeping the same jogging time in 7 minutes or,
- lengthening the jogging time to ~10 minutes and keeping the same total time in 33 minutes

### When

- Route and pace stabilize even further
- Walking/Running becomes familiar and not an event. Just normal.

## Metrics

We can see how the first sessions were irregular with a session where I only walked.
Slowly the sessions became por regular and predictable and I could keep a steady and nice HR.

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
