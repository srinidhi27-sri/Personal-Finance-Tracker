# FinWise — Project Report

## Abstract
FinWise is an INR-first personal finance and spending analytics web application designed to help users record income and expenses, compare category spending, set budgets, track savings goals and remember upcoming bills. It pairs a friendly dashboard and rule-based insights with practical demonstrations of Advanced Data Structures. React and TypeScript provide the client application; an optional Supabase/PostgreSQL backend provides authentication and user-scoped transaction persistence. The accompanying migration defines profiles, categories, transactions, budgets, savings goals and recurring bills, with validation, indexes and Row Level Security.

## Problem statement
Personal spending data is often fragmented across notes, messages and bank notifications. Users may not see category-level patterns, notice approaching bill dates or connect everyday spending to a savings target. The project demonstrates a unified tracker and shows how data structures support common operations efficiently.

## Objectives
1. Provide CRUD for transaction records with searching, sorting, filters and CSV export.
2. Calculate balance, income, expenses, savings rate and category/month summaries from the current records.
3. Track monthly budgets, savings goals and bill reminders.
4. Implement and test core ADS algorithms in separate TypeScript modules.
5. Use database constraints, foreign keys, indexes and RLS to support safer cloud storage.
6. Provide readable architecture, algorithm complexity notes and viva preparation.

## Existing vs proposed system
**Existing:** manual notes/spreadsheets can require repeated calculations and do not naturally demonstrate algorithm choices.

**Proposed:** one interface combines record management, charts, deterministic insights, reminders and a dedicated ADS laboratory. Cloud transactions are protected by database-level ownership policies when Supabase is configured.

## Requirements
### Functional
- Demo mode and optional email/password signup/login/logout.
- Create, view, edit, delete, search, filter, sort and export transactions.
- Display income, expenses, net balance, savings rate and category/month charts.
- Configure budgets and goals; create bill reminders and mark them paid.
- Explore algorithm examples and complexity explanations.

### Non-functional
- Responsive mobile/tablet/desktop layouts.
- Validate positive amounts and required fields.
- Protect authenticated user records using RLS.
- Keep service-role credentials out of browser code.
- Keep algorithms modular and unit-testable.
- Respect reduced-motion preferences and visible keyboard focus.

## Architecture
1. **Presentation:** React components, responsive CSS and Recharts.
2. **Domain utilities:** pure financial calculation functions and typed record models.
3. **ADS modules:** hash map, merge sort, binary search, min-heap, trie, graph, sliding window, undo stack and dynamic programming.
4. **Persistence:** localStorage for browser demo mode; optional Supabase client for auth and transaction CRUD. PostgreSQL migration defines all primary finance tables and RLS policies.

## Database design
- `profiles`: one profile per auth user; primary key references `auth.users(id)`.
- `categories`: optional owner (`NULL` means global starter category), name, type, display color and icon.
- `transactions`: owner FK, title, positive numeric amount, type, category, date, notes and timestamps.
- `budgets`: owner FK, category, positive amount, first day of month; unique owner/category/month.
- `savings_goals`: owner FK, name, positive target, non-negative saved amount and deadline.
- `recurring_bills`: owner FK, name, positive amount, due date, paid state and recurrence enum.

See `../supabase/migrations/202610200001_initial_schema.sql` for executable schema, indexes, triggers and RLS policies.

## ADS choices and complexity
| Structure / algorithm | Feature | Complexity | Notes |
|---|---|---|---|
| Hash map | Transaction ID index | Expected O(1) lookup; O(n) build | Hash collisions can degrade performance; JavaScript Map behavior is engine-defined. |
| Merge sort | Stable sorting | O(n log n) time, O(n) auxiliary space | Implementation is stable and does not mutate input. |
| Binary search | Sorted key search | O(log n) time, O(1) space | Requires ascending input ordered by the same key. |
| Min-heap | Due-date priority queue | O(1) peek; O(log n) push/pop | Smallest comparison key has highest priority. |
| Trie | Prefix autocomplete | O(p + matches) after prefix traversal | Prefix traversal O(p); enumerating results depends on subtree size. |
| Adjacency-list graph + BFS | Category relationship demo | O(V + E) traversal | Demo links are illustrative, not causal financial inference. |
| Sliding window | Rolling daily expenses | O(n + d) | n transactions and d dates in the window. |
| Stack | Undo operation history | O(1) push/pop | LIFO; UI undo scope is current browser session. |
| Dynamic programming / 0-1 knapsack | Budget allocation demo | O(n × cap) time and space | cap is rounded to whole currency units; priority is a demonstration score. |

## Algorithm pseudocode
### Merge sort
1. If list length is at most one, return a copy.
2. Split at midpoint.
3. Recursively sort both halves.
4. Merge in comparator order; on ties, take from the left half first to preserve stability.

### Binary search
1. Set `low = 0`, `high = n - 1`.
2. While `low <= high`, inspect midpoint.
3. Return midpoint if key equals target.
4. If midpoint key is lower, advance low; otherwise decrease high.
5. Return `-1` if absent.

### Min-heap
Insert appends to the array and sifts upward until the parent is no larger. Pop replaces root with the last element and sifts down to the smaller child until heap order is restored.

### Trie
For each lowercased character, follow or create a child node. Mark the final node terminal. Prefix search walks to the prefix node, then depth-first traverses its subtree to collect complete matches.

### Sliding window
Create a zero-initialized sum for each date in the requested window. Scan transactions once, add expense amounts to matching date keys, then return dates in order.

### 0/1 knapsack recurrence
Let `dp[i][c]` be the best priority score using the first i options with capacity c. If option i costs more than c, copy `dp[i-1][c]`; otherwise take the maximum of skipping it or adding its priority to `dp[i-1][c-cost_i]`.

## Testing
Automated unit tests are in `src/algorithms/algorithms.test.ts`. They cover stable sorting, binary-search found/not-found/empty cases, ID lookup, heap ordering, trie prefix search, stack LIFO, graph BFS, sliding-window zero dates and expense-only aggregation, and budget capacity. Run `npm test` and `npm run build`.

## Results and limitations
The source includes interactive pages and local demo workflows. Cloud authentication and transaction CRUD activate when valid Supabase variables are present. Budget, goal and bill schemas and RLS policies are defined, but their UI CRUD still uses browser storage in this version. External cloud setup, RLS verification, deployment and responsive checks on real devices remain operator tasks and must not be reported as completed without running them.

## Future enhancements
- Connect budget, goal and bill CRUD to Supabase and migrate demo data intentionally.
- Add email/push bill reminders and secure export preferences.
- Add CSV import with duplicate detection and stronger validation.
- Add integration/E2E tests and a measured performance benchmark page.
- Add multi-currency conversion only with a reliable exchange-rate source.

## Conclusion
FinWise provides a coherent finance-tracking demonstration and practical ADS implementations. It is designed to be extended into a fully cloud-synchronized product after backend credentials are configured, remaining CRUD services are connected, and deployment/security tests are completed.
