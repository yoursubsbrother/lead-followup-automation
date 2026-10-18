# Test Plan (Appendix D)

All cases were executed against the production webhook on the local n8n instance.
Evidence = observed email subjects, Telegram alerts, Google Sheet rows, and n8n Executions.
All data is fictional (Harbor & Pine Realty / Sam Carter).

| ID | Scenario | Expected result | Result |
| --- | --- | --- | --- |
| T1 | Valid Buy lead | Sheet row, Buy email, Telegram alert, InstantReplySent = Yes | Pass - production curl wrote row L-20261018081238; Buy instant email + new-lead alert received; sheet shows InstantReplySent = Yes. |
| T2 | Valid Sell lead | Same, with the Sell email | Pass - Sell email "Thanks for reaching out, T2 Seller" + Sell alert received. Email and alert require a successful Append (WF1 order), so the row exists. |
| T3 | Valid Rent lead | Same, with the Rent email | Pass - row L-20261018081623 in sheet; Rent email + alert received. |
| T4 | Invalid email | No sheet row, no email, Telegram rejection alert | Pass - rejection alert "Invalid lead rejected" received; no not-an-email row in sheet; no instant email. |
| T5 | Missing phone | Row created with empty phone, email sent | Pass - email "Thanks for reaching out, T5 NoPhone" received; alert shows Phone blank, proving Normalize set phone='' and the Append (which precedes Gmail) wrote an empty Phone cell. |
| T6 | Same lead sent twice | Two rows. Decide and document whether to add duplicate detection | Pass - two identical email subjects + two alerts = two full successful runs = two rows with distinct timestamped LeadIDs. Decision below. |
| T7 | WF2 with a lead 1 day old | Day 1 follow-up sent, stage becomes 1 | Pass - first WF2 run kept L-003 (1 day) due=1; day-1 email sent; stage updated 0 to 1. |
| T8 | WF2 with stage 1 and 3 days old | Day 3 follow-up sent, stage becomes 2 | Pass - L-005 (3 days, stage 1) due=2; day-3 email; stage 1 to 2. |
| T9 | WF2 with stage 2 and 7 days old | Day 7 follow-up sent, stage 3, Status No Response | Pass - L-007 (7 days, stage 2) due=3; day-7 email; stage 2 to 3 and Status to No Response. |
| T10 | WF2 with Status Replied or Closed | Nothing sent | Pass - L-008 (Replied) and L-009 (Closed at run time) absent from both kept and discarded lists; the upstream Status=New filter excluded them. |
| T11 | WF2 run twice the same day | Nothing sent the second time | Pass - second manual run: Filter kept 0 items; no emails, no sheet change, no summary Telegram. |
| T12 | Forced failure (wrong sheet id) | Telegram error alert from WF0 | Pass - production curl with an invalid sheet gid failed the Append node; WF0 fired "Workflow failed: WF1 ... Sheet with ID 999999999 not found". Gotcha noted below. |
| T13 | Real form submission | Whole flow runs, Source shows the form | Deferred - Milestone 5 (public lead form) intentionally skipped for this build; the webhook + curl path covers intake. Documented reason per the brief's "passes or has a documented reason". |

## T6 decision: no duplicate detection in v1

The pain point this demo solves is speed-to-reply, and dedupe would add a read-before-write
step with a race condition for little benefit at demo scale. Two identical submissions are
treated as two leads (each gets its own instant reply and its own row). Flagged as a future
enhancement: a pre-Append lookup on Email could set Status = Duplicate and skip the reply.

## T12 gotcha (worth knowing)

n8n error workflows fire only on PRODUCTION executions. A manual Execute or a /webhook-test/
run that crashes will NOT trigger WF0. To test the alert path you must Publish the broken
version and hit the production /webhook/ URL from a terminal. This is by design so that
debugging clicks do not spam the agent.

## Data hygiene note (not a test result)

In the live sheet, L-009 and L-010 Status cells are swapped versus Appendix A
(L-009 should be Closed, L-010 should be New). Functionally inert for WF2, but corrected
before the demo video so the showcase rows read correctly.
