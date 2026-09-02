# Airflow sweep and replenish

Playbook: Contribution queue → Bootstrap project (references only; skill exists)

## Done means

- [ ] Every authored open PR on `apache/airflow` is current on `main`, CI/review
      actionable items addressed or classified, with a sweep action table row.
- [ ] Queue at target (5 healthy open) or each unfilled slot has a concrete
      disqualifier recorded in queue-policy.md.
- [ ] One-line outcome appended to `.skippy/sweep-output.log`.

## Task list

- [x] Read Skippy router, contribution-queue playbook, Airflow project skill,
      queue-policy, bootstrap-report.
- [x] Reconcile departed PRs; snapshot open count vs target 5 (4/5).
- [x] Maintain #71430, #69157, #69150 — cherry-pick rebase onto apache/main, pushed.
- [x] Bounded learning scan → learning-log (cherry-pick vs full rebase; ls-remote lease).
- [x] Replenish: opened [#72402](https://github.com/apache/airflow/pull/72402) for #72337; queue 5/5.
- [x] Update queue-policy.md and log outcome.

## Evidence

| Time | Phase | Result |
| --- | --- | --- |
| 2026-09-01 | Bootstrap | queue-policy + bootstrap-report created; 3/5 open |
| 2026-09-01 | Maintain | 3 open PRs triaged; loop started; rebase next tick |
| 2026-09-01 | Manual-run | rebased #71430 #69157 #69150; opened #72394; queue 4/5 |
| 2026-09-02 | Startup | maintained 4 PRs; opened #72402; queue 5/5 | [Airflow startup sweep](17e86ddf-0769-4bd2-ab4e-c7d16fafe40f) |
