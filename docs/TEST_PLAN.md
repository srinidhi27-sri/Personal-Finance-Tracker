# FinWise QA Test Plan

| ID | Scenario | Expected result | Test type |
|---|---|---|---|
| ADS-01 | Sort numbers ascending incl. duplicates | `[1,1,4,5]`; original array unchanged | Automated unit |
| ADS-02 | Binary search target / absent / empty | Correct index or `-1` | Automated unit |
| ADS-03 | Find transaction ID | Matching object or `null` | Automated unit |
| ADS-04 | Min-heap push/pop | Ascending pop order; empty pop returns `null` | Automated unit |
| ADS-05 | Trie prefix | Case-insensitive matching words | Automated unit |
| ADS-06 | Undo stack | LIFO order and empty returns `null` | Automated unit |
| ADS-07 | Graph BFS | Visits connected vertices once | Automated unit |
| ADS-08 | Sliding window | Includes zero-spend days; excludes income | Automated unit |
| ADS-09 | Budget DP | Selection stays within cap and maximizes score | Automated unit |
| FIN-01 | Submit empty transaction | Validation prevents save | Manual/UI |
| FIN-02 | Submit negative/zero amount | Validation prevents save | Manual/UI |
| FIN-03 | Edit/delete transaction | Display updates; dashboard recomputes | Manual/UI |
| FIN-04 | Filter and sort transactions | Only matching records; order matches selected key | Manual/UI |
| FIN-05 | Export CSV | CSV downloads with headers and escaped text | Manual/UI |
| FIN-06 | Add budget | Category spend and utilization update | Manual/UI |
| FIN-07 | Update goal savings | Progress is clamped to 0–100% | Manual/UI |
| FIN-08 | Mark bill paid | Reminder status changes | Manual/UI |
| SEC-01 | User A attempts User B row access | PostgreSQL RLS denies access | Must run in configured Supabase project |
| SEC-02 | Search source for service-role key | No service-role secret in source/history | Manual/repository scan |
| BUILD-01 | `npm run build` | TypeScript and Vite build pass | Automated build |
| BUILD-02 | `npm test` | Algorithm unit tests pass | Automated unit |
| UX-01 | Mobile/tablet/desktop layouts | No clipping; all controls reachable | Manual responsive QA |

Do not mark manual or Supabase-only tests passed without running them against the relevant environment.
