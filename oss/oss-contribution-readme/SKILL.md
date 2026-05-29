---
name: oss-contribution-readme
description: Create or update a polished README that showcases a contributor's open-source work with an OSS contribution matrix, linked project names, official logos, PR or patch counts, open and merged status, optional featured-project details, and LinkedIn-ready intro copy. Use when the user wants a GitHub profile or standalone repo README for OSS contributions, a contribution table with logos, verified PR counts, tracker patch submissions, or a reusable open-source portfolio page.
---

# OSS Contribution README

Use this skill to create a concise, public-facing README that presents a
contributor's OSS history accurately and visually. Treat the README as a
portfolio artifact: verify numbers, use durable links, keep claims grounded,
and make the table screenshot-friendly.

## Workflow

1. **Identify the target and scope.**
   - Confirm or infer the output path, usually `README.md` in a profile or
     showcase repo.
   - Capture the contributor's display name, GitHub username, preferred intro
     wording, and any non-GitHub trackers or projects to include.
   - If the user mixes GitHub PRs with tracker patches, use "Contributions" or
     clearly define "PRs Created" as PRs plus patch submissions.

2. **Collect contribution data.**
   - For GitHub repos, use `gh` or the GitHub app to count contributor PRs:
     all created, currently open, and merged.
   - Prefer direct contributor links for count cells:
     `https://github.com/OWNER/REPO/pulls/USERNAME`.
   - For non-GitHub trackers, use the provided search or ticket URLs and count
     visible submitted patches/tickets. Link the count to the tracker query.
   - Verify tenure claims from the earliest public PR, patch, ticket, or other
     reliable public contribution date. Use "more than a decade" only when the
     verified span is at least 10 years as of the current date.
   - Do not inflate merged counts: if a PR is closed but not merged, keep it out
     of the merged column unless the upstream project accepted the patch through
     another public record.

3. **Choose logos and links.**
   - Link the project name to the official project or repository.
   - Prefer official logo assets from the project repo, docs, foundation logo
     service, or official site. Use organization avatars only when no stable
     official asset is easy to find.
   - For Apache projects, prefer `https://apache.org/logos/res/...` assets when
     available.
   - For white or low-contrast logos, choose a dark variant, icon-only asset, or
     official avatar that remains visible on GitHub's white background.
   - Use compact HTML in table cells:
     `<a href="PROJECT_URL"><img src="LOGO_URL" alt="Project logo" height="18"></a> <a href="PROJECT_URL">Project</a>`.
   - If logo and project text wrap awkwardly, switch that section to an HTML
     table and mark the project cell with `nowrap="nowrap"` and a small `width`.

4. **Write the README.**
   - Start with a short human intro. Good shape:

     ```markdown
     # Open Source Contributions

     I have been contributing to open source for more than a decade. Every
     contribution is a chance to learn something new and collaborate with
     amazing communities.

     Name's GitHub handle: [username](https://github.com/username)
     ```

   - Use a main contribution matrix for comparable projects:

     ```markdown
     | Project | PRs Created | Open PRs | Merged PRs |
     |---------|-------------|----------|------------|
     | <a href="https://github.com/apache/hadoop"><img src="LOGO" alt="Apache Hadoop logo" height="18"></a> <a href="https://github.com/apache/hadoop">Apache Hadoop</a> | [13](https://github.com/apache/hadoop/pulls/username) | 10 | 3 |
     | **Total PRs** | **13** | **10** | **3** |
     ```

   - Sort by the user's preference. If unspecified, sort by project name for a
     professional portfolio; sort by `PRs Created` descending only when the user
     wants impact ranking.
   - Add totals for numeric columns. If rows mix GitHub PRs and tracker patches,
     ensure the total label matches the chosen terminology.

5. **Add featured or additional contributions when useful.**
   - Use a separate table for projects needing richer context such as creator
     roles, ecosystem listings, tech stack, stars/forks, problem solved, or
     non-standard contribution types.
   - Preferred columns: `Project`, `Ecosystem`, `Role`, `Problem Solved`,
     `Tech Stack`, `Metrics`.
   - Use an HTML table when column count is high or the logo/name cell must stay
     on one line:

     ```html
     <table>
       <thead>
         <tr>
           <th>Project</th>
           <th>Ecosystem</th>
           <th>Role</th>
           <th>Problem Solved</th>
           <th>Tech Stack</th>
           <th>Metrics</th>
         </tr>
       </thead>
       <tbody>
         <tr>
           <td nowrap="nowrap" width="180"><a href="PROJECT_URL"><img src="LOGO_URL" alt="Project logo" height="18"></a>&nbsp;<a href="PROJECT_URL">project-name</a></td>
           <td><a href="ECOSYSTEM_URL"><img src="ECOSYSTEM_LOGO" alt="Ecosystem logo" height="18"></a>&nbsp;<a href="ECOSYSTEM_URL">Ecosystem</a></td>
           <td>Creator, architect, maintainer</td>
           <td>One sentence about the user-facing or operator-facing problem solved.</td>
           <td>Go, Elastic Beats, Elasticsearch, NVIDIA SMI/NVML, Python</td>
           <td>56 stars, 18 forks</td>
         </tr>
       </tbody>
     </table>
     ```

6. **Keep public wording clean.**
   - Do not include private tool names, generated-by notes, or agent provenance.
   - Avoid over-explaining column names in the README. A short sentence is fine
     only when mixed contribution types could confuse readers.
   - Prefer "contribution" over "PR" in prose when the table includes issue
     tracker patches, JIRA tickets, mailing-list patches, or other non-GitHub
     submissions.
   - Keep LinkedIn-ready text warm and plain; remove filler and hype.

7. **Validate before finishing.**
   - Run `git diff --check -- README.md`.
   - Inspect the rendered Markdown locally or on GitHub when possible,
     especially logo visibility, wrapping, totals, and link targets.
   - Recalculate totals after any row edit.
   - Commit and push only when the user asks or the current workflow clearly
     expects repository updates.
