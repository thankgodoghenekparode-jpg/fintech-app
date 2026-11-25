# Motion and Feedback

- Durations: 120 / 200 / 320 ms; easing from tokens. Respect OS reduce-motion (use fades).
- Success moments (transfer completed, goal milestone) use a short, calm animation (under 1 second). No confetti on money outcomes; light celebration only for savings milestones.
- Haptics: light tap on primary actions, success pulse on completion, error pulse on failure.
- Processing: show progress state with the label "Sending..." and never a blank screen; if longer than 8 seconds, show "Still working, you can leave this screen" with a link to history.
- Skeleton loaders instead of spinners for lists and cards.
- Transitions: standard push/pop; bottom sheets slide up; tab changes cross-fade.
