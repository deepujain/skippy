# Apache Hadoop bootstrap report

Canonical repository: https://github.com/apache/hadoop  
Default branch: `trunk`  
Local clone: `/Users/dejain/nvidia/oss/worktrees/apache/hadoop`  
Fork: `deepujain/hadoop` (push remote `origin`)  
Upstream: `apache/hadoop` (fetch remote `apache`)

Issue tracker: Apache JIRA (HADOOP, HDFS, YARN, MAPREDUCE). PRs on GitHub.

Contributor: Deepak Jain (`deepujain@gmail.com`). Commits use `--author` and JIRA
keys in messages. Push to fork only; never push to `apache`.

Validation: Maven from repo root (`./mvnw test -pl <module> -am -Dtest=...`).
CI: Apache Yetus via GitHub Actions.

Bootstrap refreshed: 2026-09-01 (user PR list:
https://github.com/apache/hadoop/pulls/deepujain).

## 2026-09-01 bootstrap sweep

- Clone: shallow `trunk` at `/Users/dejain/nvidia/oss/worktrees/apache/hadoop` (remotes `apache`, `origin`).
- All 8 open PRs rebased onto `apache/trunk` and force-pushed:
  #8670→75bc9263, #8389→29ca07c6, #8388→da3325d5, #8335→1232d9b1,
  #8334→9f7b2fc8, #8310→1f232f46, #8307→5ab85957, #8306→dc2e4f06.
- Replenishment paused (8 open > target 5). Yetus CI rerunning on all branches.
- Scheduled: `scripts/sweep-continuation-loop.sh hadoop` every 30 minutes.
