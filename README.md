# AI Security Playbook

**Detect, contain and respond to threats from, to and via AI models and agents.**

A ready-to-run baseline for an AI threat detection and response function. It is written for SOC analysts, detection engineers, incident responders and the people who design AI systems, and it turns AI security into normal security operations work: named log sources, mapped detections, runnable Splunk, Sentinel and shell queries, a severity matrix, and runbooks with exit criteria.

It is model-agnostic. It works for Claude, GPT, Gemini, Grok, Llama, Mistral, DeepSeek and Qwen, whether you call a vendor API, use Azure AI Foundry, AWS Bedrock or Google Vertex AI, or host the model yourself.

> **Ground truth:** no guardrail reliably stops a determined prompt injection. The UK NCSC says it may never be fully mitigated, and adaptive attacks have bypassed published defenses at success rates above 90 percent. This playbook assumes the classifier will miss and limits the damage with least agency, per-agent identity, human approval, egress control and full audit logs.

## Why now

2026 moved AI attacks from research to operations: hidden prompt injection in phishing aimed at inbox assistants, an intrusion run end to end by an autonomous agent at Hugging Face, one injection pattern hijacking three vendors' coding agents in CI ("Comment and Control"), an AI-assisted theft of 150 GB of Mexican government data, memory poisoning through "Summarize with AI" links, and tens of thousands of exposed OpenClaw agents. The executive summary in [`PLAYBOOK.md`](PLAYBOOK.md) has the sources.

## What's inside

| Path | Contents |
| --- | --- |
| [`PLAYBOOK.md`](PLAYBOOK.md) | The full playbook (v2.1) |
| [`queries/splunk/`](queries/splunk) | Hunt and detection queries in SPL |
| [`queries/sentinel/`](queries/sentinel) | Hunt and detection queries in KQL |
| [`queries/github/`](queries/github) | Shell hunt for coding agents exposed to untrusted CI events |
| [`archive/playbook-v1.md`](archive/playbook-v1.md) | The original v1 playbook, kept for reference |

### Playbook structure

| Section | Topic | Highlights |
| --- | --- | --- |
| Executive summary | Why the function is needed now | 2026 incident record, the structural problem, what the playbook delivers |
| Standing up the function | Year-one plan | Mandate, four-phase plan with exit tests, operating model, success measures |
| Part 1 | Operating principles | Ten rules, including "break the lethal trifecta" and "agents are identities" |
| Part 2 | Threat model | From / to / via, lethal trifecta, Agents Rule of Two, Five Eyes risk categories, 2024-2026 reference incidents, crosswalk of OWASP LLM Top 10 2026, OWASP Agentic Top 10 2026, OWASP MCP Top 10 and MITRE ATLAS |
| Part 3 | Telemetry standard | Seven required log sources with fields and retention, agent-specific logging, AIBOM, OpenTelemetry GenAI status |
| Part 4 | Detection catalog | 21 detections (D1-D21) with signal, base severity, expected false positives and first action |
| Part 5 | Threat hunting | 9 hypotheses (H1-H9), 9 working queries (Q1-Q9), hunt write-up template |
| Part 6 | Protection | Injection-resistant design patterns, 10-layer control stack, MCP and supply chain, CI/CD and data-pipeline hardening, agent identity, tool map, 2024-2026 market consolidation, governance |
| Part 7 | Incident response | Severity matrix, roles, first 15 minutes, containment ladder, notification triggers, 13 runbooks (RB1-RB13) with exit criteria |
| Part 8 | Testing and metrics | Red-team cadence, adaptive testing, 8 tabletop scenarios, detection quality targets, program KPIs |
| Part 9 | Analyst development | 30/60/90 day path with deliverables and senior exercises |
| Part 10 | Reference | Checklists, glossary, sources, change log |

## Quick start

- **Got an alert?** Go to Part 7, set the severity, and run the matching runbook.
- **Building detections?** Get the Part 3 log sources into your SIEM first, then work through Part 4. Start with D2, D6, D8, D9 and D16, plus D19 if you run coding agents in CI.
- **Running a hunt?** Pick a hypothesis from Part 5 and use the matching file in `queries/`.
- **Shipping an agent?** Run the Rule of Two review in Part 2 and the pre-launch checklist in Part 10.
- **Proposing the function?** Start with the executive summary and "Standing up the function".
- **Training a junior analyst?** Follow Part 9 in order.

## Query index

| ID | Query | Platform | Maps to |
| --- | --- | --- | --- |
| Q1 | [Off-profile and unapproved tool calls](queries/splunk/q1_off_profile_tool_calls.spl) | Splunk | D9, H2, RB7 |
| Q2 | [Injection in content followed by a tool call](queries/splunk/q2_injection_then_tool_call.spl) | Splunk | D2, H1, RB2 |
| Q3 | [Exfiltration through links in output](queries/splunk/q3_url_markdown_exfiltration.spl) | Splunk | D8, H3, RB2 |
| Q4 | [Invisible Unicode in prompts or retrieved text](queries/sentinel/q4_invisible_unicode.kql) | Sentinel | D3, H4, RB2 |
| Q5 | [LLMjacking: new principal or region calling Bedrock](queries/sentinel/q5_llmjacking_bedrock_new_principal.kql) | Sentinel | D16, H5, RB9 |
| Q6 | [Secrets in output, caught versus missed](queries/sentinel/q6_secrets_in_output_guardrail_miss.kql) | Sentinel | D6, H6, RB4 |
| Q7 | [Extraction and cost outliers](queries/splunk/q7_extraction_cost_outliers.spl) | Splunk | D18, H7, RB10 |
| Q8 | [Platform AI alerts in one view](queries/sentinel/q8_defender_ai_alerts.kql) | Sentinel | Defender for Cloud AI threat protection |
| Q9 | [Coding agents exposed to untrusted CI events](queries/github/q9_ci_agents_untrusted_triggers.sh) | Shell | D19, D20, RB13 |

Q1-Q4, Q6 and Q7 assume the Part 3 telemetry schema: Splunk sourcetypes `ai:prompt`, `ai:response`, `ai:retrieval`, `ai:tool_call`, `ai:guardrail`, `ai:usage`, and Sentinel custom tables with the same names plus `_CL`. Q5 runs on the standard `AWSCloudTrail` table, Q8 on `SecurityAlert`, and Q9 on a repository checkout. **Rename to match your environment and test before production use.**

## Framework coverage

- [OWASP Top 10 for LLM Applications 2026](https://genai.owasp.org) (IDs changed from 2025; the crosswalk shows both)
- [OWASP Top 10 for Agentic Applications 2026](https://genai.owasp.org)
- [OWASP MCP Top 10](https://owasp.org/www-project-mcp-top-10/) (beta)
- [MITRE ATLAS](https://atlas.mitre.org): technique IDs moved during 2026, so verify before reporting
- Five Eyes "Careful Adoption of Agentic AI Services" (May 2026), NIST Cyber AI Profile (IR 8596, draft) and COSAiS, NIST AI RMF and AI 100-2, ISO/IEC 42001, EU AI Act as amended by the Digital Omnibus on AI

## Keeping it current

This is a living document. Update it after every Sev 1 or Sev 2 incident and every red-team exercise:

1. Edit `PLAYBOOK.md` and, if a query changed, the matching file in `queries/`.
2. Add a row to the change log in Part 10.
3. Open a pull request that says what changed and why.

Incidents, vendor status, regulatory dates and framework IDs are accurate as of **November 6, 2026**. Recheck them before you depend on them.

## Disclaimer

This playbook is provided as is, for defensive security use. Adapt it to your environment, your legal obligations and your organization's IR policy. It is not legal advice.
