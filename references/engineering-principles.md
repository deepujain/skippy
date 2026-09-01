# Engineering Decision System

This is not a scorecard and it is not a fixed number of maxims. Use the
decision areas that materially change the work at hand. A task plan should name
the principle, the decision it changed, and the evidence that supports it.

The system draws on durable engineering practice: explicit interface design and
complexity management, small feedback-rich delivery loops, built-in quality,
reliability engineering, and deliberately bounded collaboration. It is adapted
for agent-assisted OSS work, where a plausible patch is cheap but trustworthy
evidence and maintainable ownership are not.

## Frame the problem

<a id="make-the-contract-explicit"></a>
- **Make the contract explicit.** State the caller-visible input, output,
  invariant, owner, failure behavior, and preserved behavior before editing.
<a id="treat-evidence-as-a-ladder"></a>
- **Treat evidence as a ladder.** Separate source reading, a mock, a focused
  test, and a real boundary execution. Do not represent a lower rung as a
  higher one.
<a id="start-from-the-user-and-caller"></a>
- **Start from the user and caller.** A design earns its shape by making the
  intended consumer simpler, safer, or more predictable.
<a id="distinguish-facts-inferences-and-decisions"></a>
- **Distinguish facts, inferences, and decisions.** Preserve enough source
  evidence that a reviewer can replay the conclusion without trusting chat.
<a id="name-uncertainty"></a>
- **Name uncertainty.** Unknown ownership, unavailable environments, and
  conflicting evidence are first-class results, not blanks to fill with
  confidence.
<a id="set-an-observable-finish-line"></a>
- **Set an observable finish line.** Replace elapsed-time goals with a
  `Done means` condition someone can run, inspect, or reproduce.

## Design the right change

<a id="change-the-smallest-owning-boundary"></a>
- **Change the smallest owning boundary.** Fix the behavior where it is
  defined rather than compensating downstream.
<a id="make-authority-singular"></a>
- **Make authority singular.** Derive values, policy, and accepted shapes from
  the shipping owner, never from a drifting mirror in tests or docs.
<a id="reduce-complexity-before-adding-it"></a>
- **Reduce complexity before adding it.** Remove duplicate paths, obsolete
  flags, and accidental layers before proposing new abstractions.
<a id="prefer-deep-understandable-boundaries"></a>
- **Prefer deep, understandable boundaries.** Hide incidental mechanism behind
  a small, coherent contract, while keeping errors and operational behavior
  legible to callers.
<a id="preserve-compatibility-deliberately"></a>
- **Preserve compatibility deliberately.** Identify the valid legacy path and
  test it beside newly rejected or corrected behavior.
<a id="make-retries-converge"></a>
- **Make retries converge.** Commands, migrations, cleanup, and recovery must
  tolerate partial completion without falsely claiming success.
<a id="design-failure-as-behavior"></a>
- **Design failure as behavior.** Bound errors, expose diagnostics safely, and
  define recovery rather than leaving a caller to infer runtime state.
<a id="use-reversible-units"></a>
- **Use reversible units.** Prefer steps that can be checked, reviewed, or
  rolled back independently over a large all-or-nothing rewrite.

## Build for operation

<a id="treat-time-and-lifecycle-as-data"></a>
- **Treat time and lifecycle as data.** A timeout, signal request, or close
  call is not terminal evidence. Retain ownership until the terminal condition
  is observed.
<a id="make-security-properties-concrete"></a>
- **Make security properties concrete.** Assert the exact identity, mode,
  capability, precedence, protocol, or cleanup property that defends the
  boundary.
<a id="validate-real-integration-contracts"></a>
- **Validate real integration contracts.** For external CLIs, processes,
  protocols, storage, and configuration, check the real accepted shape whenever
  the issue crosses that boundary.
<a id="build-quality-into-the-path"></a>
- **Build quality into the path.** Use guardrails, narrow tests, static checks,
  and safe defaults to prevent a class of mistake rather than relying on a
  later reminder.
<a id="make-observability-useful"></a>
- **Make observability useful.** Logs, traces, counters, and diagnostics should
  let an operator identify the owner, state, and recovery route without exposing
  secrets.
<a id="budget-performance-and-resource-behavior"></a>
- **Budget performance and resource behavior.** Establish a comparable
  workload, baseline, and target before optimizing; measure retained wins.

## Verify and learn

<a id="reproduce-before-theorizing"></a>
- **Reproduce before theorizing.** Capture the smallest representative failure
  or a clear reason a live reproduction is unavailable.
<a id="prove-the-changed-boundary"></a>
- **Prove the changed boundary.** Pair unit coverage with the closest realistic
  public, CLI, protocol, storage, or lifecycle check proportional to risk.
<a id="verify-both-acceptance-and-rejection"></a>
- **Verify both acceptance and rejection.** A fail-closed repair still needs a
  representative valid path so the new boundary is not overly narrow.
<a id="review-the-diff-as-a-product"></a>
- **Review the diff as a product.** Inspect behavior, security, compatibility,
  cleanup, generated artifacts, and scope after tests have passed.
<a id="leave-a-replayable-receipt"></a>
- **Leave a replayable receipt.** Record key decisions, commands, outputs, and
  limitations in the task artifact, PR, issue, or accepted project surface.
<a id="turn-lessons-into-leverage"></a>
- **Turn lessons into leverage.** Convert recurring review surprises into a
  test, helper, fixture, guardrail, or concise shared instruction.

## Collaborate without losing ownership

<a id="keep-one-accountable-integrator"></a>
- **Keep one accountable integrator.** Delegates contribute bounded evidence;
  the lead owns the final contract, diff, and delivery claim.
<a id="partition-by-stable-boundaries"></a>
- **Partition by stable boundaries.** Fan out only independent questions or
  isolated write scopes. Do not parallelize a linear edit sequence.
<a id="isolate-writers"></a>
- **Isolate writers.** Use separate worktrees, branches, directories, and
  artifacts so parallel work cannot silently overwrite another agent's state.
<a id="minimize-cognitive-load"></a>
- **Minimize cognitive load.** Give each delegate one question, relevant
  context, a deliverable, and a stop condition. Split work when the interface is
  clearer than the combined context.
<a id="use-skeptical-independence"></a>
- **Use skeptical independence.** For consequential work, have a fresh context
  verify assumptions and the observable result rather than echoing the
  implementer's explanation.
<a id="finish-the-delivery-loop"></a>
- **Finish the delivery loop.** A contribution is incomplete until its current
  commit, signature, CI, review state, and external blockers are known and
  truthfully handed off.
