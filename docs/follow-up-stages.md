# Follow-Up Stages and Status Values

## Status values

- New
- Replied
- Closed
- No Response

WF2 only processes leads where Status = New.

When the agent replies manually, they change Status to Replied. After day 7, WF2 changes Status to No Response.

## Follow-up stages

FollowUpStage values:

- 0: no follow-up sent yet
- 1: day 1 follow-up sent
- 2: day 3 follow-up sent
- 3: day 7 follow-up sent

## Due logic

A follow-up is due when:

- Stage 0 and lead is at least 1 day old: send day 1, set stage 1
- Stage 1 and lead is at least 3 days old: send day 3, set stage 2
- Stage 2 and lead is at least 7 days old: send day 7, set stage 3 and Status = No Response

## Date format

All dates are stored as plain text:

yyyy-MM-dd HH:mm:ss
