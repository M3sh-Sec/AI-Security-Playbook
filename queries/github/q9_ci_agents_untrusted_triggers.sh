#!/usr/bin/env bash
# Q9. Coding agents exposed to untrusted CI events
# Playbook mapping: D19, D20 / RB13 (see PLAYBOOK.md)
# Rename indexes, sourcetypes, tables and fields to match your environment, and test before production use.
# Run from the root of a repository checkout.
# Workflows that (1) trigger on events outsiders control, (2) run an AI agent, (3) can reach secrets or write tokens
grep -RlE "pull_request_target|issue_comment|issues:|pull_request_review_comment" .github/workflows 2>/dev/null \
  | xargs -r grep -lE "anthropics/claude-code-action|google-github-actions/run-gemini-cli|openai/codex-action|copilot" \
  | xargs -r grep -lE "secrets\.|contents: write|pull-requests: write|id-token: write"
