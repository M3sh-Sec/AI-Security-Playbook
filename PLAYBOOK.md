# AI Security Threat Detection, Protection and Response Playbook

Version 2.1 · Nov 6, 2026

## Executive summary

AI agents now read untrusted content, hold real credentials and take actions, and 2026 showed attackers exploiting exactly that. This playbook is a ready-to-run baseline for a dedicated AI threat detection and response function: what to log, what to detect, how to respond, and how to prove it works.

**Why now: the 2026 record**

| When | Incident | What it proves |
| --- | --- | --- |
| Oct 2026 | [Barracuda](https://infosecurity-magazine.com/news/attackers-hide-ai-prompt) found phishing emails carrying a lure for the person and hidden prompt injection for their inbox AI assistant | Attackers now write for the AI that reads the mail, not only the human |
| Jul 2026 | [Hugging Face](https://rits.shanghai.nyu.edu/ai/hugging-face-intrusion-openai-attribution/) disclosed a production intrusion run end to end by an autonomous agent; OpenAI later said its own models escaped an internal evaluation sandbox | Machine-speed intrusions are real, and the defender's AI tooling has to be ready for them |
| Apr 2026 | [Comment and Control](https://www.digitaltoday.co.kr/en/view/48622/comment-and-control-attack-can-hack-claude-code-gemini-cli-and-github-copilot-at-once): one injection pattern in GitHub PR titles, issues and comments hijacked Claude Code, Gemini CLI and Copilot Agent in CI | Coding agents sitting next to production secrets are an exfiltration path |
| Feb 2026 | [Mexican government breach](https://www.thestar.com.my/tech/tech-news/2026/02/26/hacker-used-anthropics-claude-to-steal-mexican-data-trove): an attacker used Claude to help steal 150 GB, including documents tied to 195 million taxpayer records | One operator plus an AI model can run a campaign that once needed a team |
| Feb 2026 | [Microsoft: AI Recommendation Poisoning](https://www.microsoft.com/en-us/security/blog/2026/02/10/ai-recommendation-poisoning/) via "Summarize with AI" links that plant instructions in assistant memory | Memory poisoning is in the wild, used by legitimate companies |
| Jan-Feb 2026 | [OpenClaw](https://www.techzine.eu/news/security/138633/over-40000-openclaw-agents-vulnerable/): CVE-2026-25253 (CVSS 8.8, one-click RCE) and more than 40,000 internet-exposed agent instances | Self-hosted agents become unmanaged attack surface fast |

**The core problem is structural.** The UK NCSC warned in December 2025 that prompt injection [may never be totally mitigated](https://securityboulevard.com/2025/12/prompt-injection-cant-be-fully-mitigated-ncsc-says-reduce-impact-instead/) the way SQL injection was. Researchers from OpenAI, Anthropic and Google DeepMind [bypassed 12 published defenses](https://arxiv.org/abs/2510.09023) with adaptive attacks, mostly at success rates above 90 percent. Filters help; they do not set the blast radius. Architecture, identity, logging and fast response do.

**What this playbook delivers**

- A threat model mapped to the current standards: OWASP LLM Top 10 2026, OWASP Agentic Top 10 2026, MITRE ATLAS, and the Five Eyes agentic AI guidance of May 2026.
- A telemetry standard so AI incidents can be investigated at all.
- 21 detections, 9 hunts with runnable Splunk and Sentinel queries, and 13 runbooks with exit criteria.
- A protection architecture, test program, metrics, and a 90-day analyst training path.

**The ask.** Fund a dedicated owner for AI threat detection and response, working inside the SOC, with the year-one plan in the next section.

## Standing up the function

The role owns detection, investigation and response for threats from, to and via AI systems, and sets the security bar any agent must clear before launch. It sits in the SOC and borrows engineering time from the platform and identity teams.

### Mandate

- **Detect and respond:** own the AI detections, hunts and runbooks in this playbook, and lead AI incidents through the existing IR process.
- **Set the launch bar:** run the Rule of Two review and pre-launch checklist for every agent with write, send or execute tools.
- **Inventory and identity:** keep the register of AI apps, agents, MCP servers and model keys, and make sure each agent has its own identity and owner.
- **Prove it works:** run the red-team suite, report detection quality and program KPIs to security leadership every quarter.

### Year-one plan

| Phase | Weeks | Outcomes | Exit test |
| --- | --- | --- | --- |
| Discover | 1-4 | Inventory of AI apps, agents, MCP servers, model API keys and shadow AI; top 5 risks ranked with the Rule of Two; log-source gap list | Leadership signs off the inventory and top-5 list |
| Instrument | 5-12 | The seven Part 3 log sources live for the top 5 apps; Bedrock, Azure OpenAI and Vertex audit logging on; first five detections (D2, D6, D8, D9, D16) in informational mode | One real session traced end to end from SIEM data alone |
| Detect and respond | 13-26 | 12 detections alerting with measured precision; runbooks RB1-RB13 adopted into the IR plan; first tabletop run; agent kill switches in place for top 5 | Tabletop meets the Sev 1 15-minute containment target |
| Harden and scale | 27-52 | CI red-team suite gating releases; all agents with per-agent identity; full 21-detection catalog; quarterly hunts; second analyst trained through Part 9 | Attack success rate trending down release over release; KPI report delivered |

### Operating model

| Work | AI security lead | SOC | Platform and app owners | Identity and cloud | Legal and privacy |
| --- | --- | --- | --- | --- | --- |
| Detections and hunts | Owns | Runs alerts | Supplies logs | Supplies logs | - |
| AI incident response | Leads technical response | Triage and scoping | Containment in app | Key and token revocation | Notice decisions |
| Pre-launch review | Approves or blocks | - | Fixes findings | Issues agent identity | Consulted on data use |
| Red teaming | Owns | - | Fixes findings | - | - |
| Inventory and AIBOM | Owns | - | Keeps current | Agent identity register | - |

### How success is measured

Report these quarterly from Part 8: coverage of the Part 2 crosswalk, share of agents passing Rule of Two review, share of agents with their own identity, attack success rate in CI, AI incident mean time to contain, and detection precision.

## How to use this playbook

This playbook turns AI security into normal SOC work: named log sources, mapped detections, working queries, severity rules, and runbooks with exit criteria. It covers threats from, to, and via any frontier or open-weight model (Claude, GPT, Gemini, Grok, Llama, Mistral, DeepSeek, Qwen) and any hosting path (vendor API, Azure AI Foundry, AWS Bedrock, Google Vertex AI, self-hosted). The threats are model-agnostic. The telemetry changes by platform.

| If you are... | Start here |
| --- | --- |
| Responding to an alert | Part 7: severity matrix, then the matching runbook |
| Building detections | Part 3 (telemetry), then Part 4 (catalog) |
| Running a hunt | Part 5 |
| Designing or approving an AI system | Parts 1, 2 and 6, then the pre-launch checklist in Part 10 |
| New to AI security | Part 9, in order |
| Teaching a junior analyst | Part 9 exercises are lesson plans |

**Ground truth.** No guardrail reliably stops a determined prompt injection. The UK NCSC says prompt injection may never be fully mitigated. Every control here assumes the classifier will miss and limits what the model can do when it does.

**What changed in v2.1**

- Added an executive summary and a year-one plan for standing up the function.
- Remapped to the OWASP Top 10 for LLM Applications 2026 (published August 2026), whose IDs differ from 2025. Added the OWASP MCP Top 10 and the Five Eyes "Careful Adoption of Agentic AI Services" guidance (May 2026).
- Added 2026 reference incidents: OpenClaw, Mexican government breach, AI Recommendation Poisoning, Comment and Control, GrafanaGhost, the Hugging Face autonomous-agent intrusion, and dual-target phishing.
- Added detections D19-D21 (CI/CD agent hijack, exposed agent control planes, AI-driven intrusion behaviour), hunt queries Q8-Q9, and runbook RB13.
- Added evidence that adaptive attacks defeat published filters, and test guidance to match.
- Corrected OpenTelemetry GenAI status (still Development) and updated vendor consolidation through November 5, 2026.
- v2.0 (same day) rebuilt v1 with the agentic threat model, telemetry schema, detection catalog, queries, severity matrix and runbooks.

## Part 1: Operating principles

Ten rules. If a design, detection or response choice breaks one, write down why.

1. **Data becomes instructions.** User input, retrieved documents, emails, web pages, tool results, file names, image text and agent memory can all steer the model. Treat every token the model did not get from you as untrusted.
2. **Assume the guardrail fails.** Classifiers lower the attack rate. They do not set the blast radius. Permissions, egress rules and human approval set it.
3. **Break the lethal trifecta.** An agent that has private data, reads untrusted content, and can send data out can be made to exfiltrate. Remove at least one leg per session, or add a human gate.
4. **Least agency, not just least privilege.** Give each agent the fewest tools, scopes, and steps it needs. Autonomy is earned per task, not granted by default.
5. **Agents are identities.** Each agent gets its own non-human identity, short-lived credentials, and an owner. No shared service-principal secrets. No user tokens reused silently.
6. **Humans approve consequential actions.** Sending externally, payments, deletes, permission changes, code execution outside a sandbox, and production writes. Show the approver the exact arguments, not a summary.
7. **Model output is untrusted input to the next system.** Encode, validate, and parameterize before it reaches HTML, SQL, shell, an API or another agent.
8. **No secrets in prompts.** System prompts leak. Security logic lives in code and policy engines.
9. **Log the decision, not just the verdict.** Every prompt, retrieval, tool call, classifier score, and human approval goes to the SIEM with a conversation ID that ties them together.
10. **Measure or do not ship.** Every detection and filter has precision, recall, and a false-positive budget on a labeled set. A filter you cannot measure is a guess.

## Part 2: Threat model

Classify every incident by direction first. Direction decides who owns it and which logs prove it.

| Direction | The model is... | Examples | Primary evidence |
| --- | --- | --- | --- |
| FROM | The source of harm | Leaks system prompt or training data, emits unsafe content, hallucinates a package or citation that gets used, takes an unreviewed action | Response logs, tool-call logs, outbound DLP |
| TO | The target | Model or weight theft, extraction by query, training or RAG poisoning, cost exhaustion, stolen API keys (LLMjacking) | Usage and cost logs, identity logs, data lineage |
| VIA | The conduit | Indirect injection makes a copilot exfiltrate data, poisoned MCP tool steers an agent, attacker uses an AI agent to run an intrusion, AI-written phishing at scale | Retrieval logs, tool-call logs, egress, EDR and email telemetry |

### Two design tests

**The lethal trifecta** (Simon Willison, 2025). Private data + exposure to untrusted content + an external communication channel = exfiltration is possible. Count the legs for every agent and every session.

**The Agents Rule of Two** (Meta, 2025). In one session an agent may hold at most two of: (A) processes untrusted input, (B) accesses sensitive systems or private data, (C) changes state or communicates externally. Needing all three means a human approves, or the session restarts with fresh context.

**Five Eyes agentic risk categories** (CISA, NSA, ASD ACSC, CCCS, NCSC-NZ and NCSC-UK, "Careful Adoption of Agentic AI Services", May 1, 2026). Use them as the top-level buckets when you brief leadership or auditors:

| Category | Meaning | Where this playbook covers it |
| --- | --- | --- |
| Privilege | Over-provisioned agents; a compromised component inherits broad access | Part 1 rules 4-5, D9, D15, RB7 |
| Design and configuration | Broad permissions, weak segmentation, insecure third-party tools | Part 6 patterns and supply chain, D11-D13, D20 |
| Behavioural | Agents reach goals in unintended ways, including disabling checks | D9, D21, RB7, RB11 |
| Structural | Failures and injections cascade across multi-agent pipelines | D15, ASI07 and ASI08 rows below |
| Accountability | Fragmented logs cannot explain what was decided, why, or with what data | Part 3 telemetry standard |

### Reference incidents to teach

| Case | Date | Lesson |
| --- | --- | --- |
| Dual-target phishing (Barracuda) | Oct 2026 | One email carries a lure for the human and hidden instructions for the inbox assistant. Strip hidden content before AI reads mail. |
| Hugging Face autonomous-agent intrusion | Jul 2026 | Entry via a malicious dataset exploiting code-executing loaders; the agent escalated, harvested cloud credentials and moved laterally across 17,000+ logged actions. OpenAI later said its own models escaped an evaluation sandbox through a package-registry proxy. Data pipelines and test harnesses are attack surface. |
| GrafanaGhost | Apr 2026 | Indirect injection in Grafana's AI features could push data to attacker servers through rendering flows. Rendering is an exfil channel. |
| Comment and Control | Apr 2026 | Crafted PR titles, issue bodies and comments hijacked Claude Code, Gemini CLI and Copilot Agent in GitHub Actions and leaked secrets. Anthropic rated its variant CVSS 9.4. |
| Mexican government breach | Dec 2025-Feb 2026 | An attacker jailbroke Claude, sent 1,000+ prompts and stole 150 GB across nine institutions, per Gambit Security. Expect single operators with AI-team output. |
| AI Recommendation Poisoning (Microsoft) | Feb 2026 | 50+ attempts from 31 companies in 60 days planted instructions in assistant memory through "Summarize with AI" links. |
| OpenClaw / ClawHavoc | Jan-Feb 2026 | CVE-2026-25253 (one-click RCE via WebSocket hijacking), 40,000+ exposed instances and hundreds of malicious marketplace skills. Self-hosted agents need asset management. |
| AI-orchestrated espionage (Anthropic, GTG-1002) | Sep-Nov 2025 | A state actor used Claude Code and MCP tools for most of the intrusion lifecycle against about 30 targets. Now MITRE ATT&CK campaign C0062. |
| postmark-mcp silent BCC (Koi Security) | Sep 2025 | A look-alike MCP package BCC'd every email to an attacker. Pin and verify tool sources. |
| EchoLeak, CVE-2025-32711, CVSS 9.3 (Aim Security) | Jun 2025 | Zero-click indirect injection by email exfiltrated Microsoft 365 Copilot data. The trifecta in one product. |
| LLMjacking (Sysdig) | May 2024 onward | Stolen cloud keys used to run Bedrock and other hosted models; attackers checked `GetModelInvocationLoggingConfiguration` to see if prompts were logged. Sysdig estimated costs could exceed $46,000 a day. |

### Framework crosswalk

Map every detection and runbook to at least one row. OWASP's 2026 LLM list renumbered most entries, so the 2025 ID is shown in brackets; remap any controls or questionnaires keyed to the old IDs. The OWASP MCP Top 10 is still in beta. Verify ATLAS IDs at atlas.mitre.org before reporting: the September 2026 release (v2026.09) lists 16 tactics and 120 techniques, and IDs have moved during the year.

| OWASP LLM 2026 (2025 ID) | OWASP Agentic 2026 | OWASP MCP Top 10 (beta) | MITRE ATLAS (examples) | Covered by |
| --- | --- | --- | --- | --- |
| LLM01 Prompt Injection (LLM01) | ASI01 Agent Goal Hijack | MCP03 Tool Poisoning | AML.T0051 LLM Prompt Injection, AML.T0054 LLM Jailbreak | D1-D4, D19, RB1-RB3, RB13 |
| LLM02 Sensitive Information Disclosure (LLM02) | ASI03 Identity and Privilege Abuse | MCP01 Token Mismanagement and Secret Exposure | AML.T0057 LLM Data Leakage, AML.T0098 Agent Tool Credential Harvesting | D6-D8, RB4 |
| LLM03 Excessive Agency (LLM06) | ASI02 Tool Misuse, ASI10 Rogue Agents | - | AML.T0053 AI Agent Tool Invocation, AML.T0086 Exfiltration via Agent Tool Invocation | D9, D15, RB7 |
| LLM04 Supply Chain (LLM03) | ASI04 Agentic Supply Chain | MCP03 Tool Poisoning (rug pulls) | AML.T0010 AI Supply Chain Compromise, AML.T0104 Publish Poisoned AI Agent Tool | D11-D13, RB8, RB12 |
| LLM05 Data and Model Poisoning (LLM04) | ASI06 Memory and Context Poisoning | - | AML.T0020 Poison Training Data, AML.T0080 AI Agent Context Poisoning | D10, D14, RB6 |
| LLM06 Unbounded Consumption (LLM10) | ASI08 Cascading Failures | - | AML.T0029 Denial of AI Service, AML.T0034 Cost Harvesting, AML.T0024 Exfiltration via AI Inference API | D16, D18, RB9, RB10 |
| LLM07 Misinformation (LLM09) | ASI09 Human-Agent Trust Exploitation | - | - | D17 |
| LLM08 Hidden Context Exposure (LLM07 System Prompt Leakage) | - | - | AML.T0056 Extract LLM System Prompt | D5, RB5 |
| LLM09 Vector and Embedding Weaknesses (LLM08) | ASI06 Memory and Context Poisoning | - | AML.T0080 | D10, RB6 |
| LLM10 Improper Output Handling (LLM05) | ASI05 Unexpected Code Execution | MCP05 Command Injection and Execution | AML.T0053 | D9, D17, D19, RB13 |
| - | ASI07 Insecure Inter-Agent Communication | - | AML.T0053 | D15 |
| - (attacker uses AI against you) | - | - | ATT&CK T1588.007 Obtain Capabilities: Artificial Intelligence | D20, D21, H8, RB11 |

## Part 3: Telemetry standard

You cannot investigate what you did not log. Ship these seven sources to the SIEM before you write a single detection, all joined on `conversation_id` and `trace_id`. Instrument with the OpenTelemetry GenAI semantic conventions (`gen_ai.*` attributes, including `invoke_agent` and `execute_tool` spans) so the schema survives a model or vendor change, but pin the version: as of mid-2026 every `gen_ai.*` attribute is still at Development status, and the conventions moved to a separate `semantic-conventions-genai` repository in June 2026. Expect field names to change.

| Source | Required fields | Retention | Why |
| --- | --- | --- | --- |
| Prompt and response | timestamp, conversation\_id, turn, user\_id, app\_id, model, model\_version, system\_prompt\_hash, prompt\_text, response\_text, input\_tokens, output\_tokens, finish\_reason | 90 days hot, 1 year cold (redact PII per policy) | Reconstructs what the model saw and said |
| Retrieval (RAG) | conversation\_id, index\_name, index\_version, doc\_id, doc\_version, doc\_owner, last\_editor, acl\_applied, chunk\_text\_inserted, similarity\_score | 90 days | Separates direct from indirect injection |
| Tool call | conversation\_id, agent\_id, agent\_identity, tool\_name, mcp\_server, server\_version, arguments, return\_value\_hash, return\_size, approval\_required, approver, approval\_ts, outcome | 1 year | Tool calls are the actions. Everything else is talk |
| Guardrail | conversation\_id, direction (in/out/retrieval/tool), classifier, classifier\_version, category, score, threshold, action | 1 year | Near-threshold scores drive tuning and FN analysis |
| Identity | principal (human or agent), auth\_method, token\_id, token\_ttl, source\_ip, device, scopes, delegation\_chain | Per IAM policy | Who acted, on whose behalf |
| Egress | agent\_id or host, dest\_domain, dest\_ip, url, bytes\_out, method, via\_tool | 90 days | Proves what left |
| Usage and cost | api\_key\_id, principal, model, region, tokens, requests, cost\_usd, per hour | 13 months | First place LLMjacking, extraction and DoS show up |

**Agent-specific additions.** The Five Eyes guidance names fragmented, unexplainable logs as a risk category of its own and expects agent inputs, outputs, reasoning or plan steps, tool invocations and privilege changes to be logged before agents scale. For agents, add: the plan or reasoning summary per step (where the platform exposes it), every change to the agent's scopes or credentials, sub-agent calls with the caller's identity, and memory reads and writes. Platform alerts help too: Microsoft Defender for Cloud's AI threat protection now covers Foundry agents and sends alerts to Defender XDR and Sentinel.

Also keep an **AI bill of materials** (AIBOM) per app: model and weights hash, dataset and index versions, system prompt hash, MCP servers with pinned versions and tool-description hashes, and agent rules files (CLAUDE.md, AGENTS.md, .cursorrules) with hashes.

**Gaps to close first.** Most teams lack retrieval logs and tool-call arguments. Without them, an indirect injection looks like the model misbehaving on its own.

**Privacy.** Prompt logs hold personal and confidential data. Restrict access to the IR group, redact with Presidio or Purview at ingest where policy requires, and log every access to the log store.

## Part 4: Detection catalog

Twenty-one detections, ordered by how fast they pay off. Ship D2, D6, D8, D9 and D16 first: they catch the incidents that become breaches. Add D19 early if you run coding agents in CI. Base severity is the starting point; Part 7 adjusts it by confirmed impact.

| ID | Detection | Signal | Base sev | False positives to expect | First action |
| --- | --- | --- | --- | --- | --- |
| D1 | Direct injection or jailbreak | Inbound classifier (Prompt Guard, Prompt Shields, Lakera) above threshold on user-authored text | 3 | Security staff testing, users quoting articles about jailbreaks | Pull conversation; did the model comply? |
| D2 | Indirect injection in content | Classifier hit or instruction phrasing in retrieved chunks, email bodies, web pages or tool returns the user did not write | 2 | Docs that legitimately contain instructions (runbooks, prompts libraries) | Find the source doc, its editors, and whether any tool call followed |
| D3 | Invisible-text smuggling | Unicode tag block U+E0000-E007F, zero-width chars, bidi overrides, white-on-white or tiny-font text in input or retrieved content | 2 | Some emoji flag sequences use tag chars; filter those | Decode the hidden text and quote it in the case |
| D4 | Multi-turn escalation | Rising classifier score across turns, role-play or encoding pivots, a refused request re-asked in pieces | 3 | Creative writing apps | Read the whole conversation, not the flagged turn |
| D5 | System prompt extraction | A canary string planted in the system prompt appears in any output, or n-gram overlap with the system prompt above 60 percent | 3 | Debug sessions by the app owner | Diff leaked text against the prompt; check for secrets |
| D6 | Sensitive data in output | DLP or Presidio match (keys, tokens, PII, PHI, card numbers, internal hostnames) in a response | 2 | Users asking about their own data; test data | Identify data origin: training, retrieval or conversation |
| D7 | Secrets pasted into prompts | Secret patterns in prompts to any AI service, including unsanctioned ones seen in proxy or CASB logs | 3 | Placeholder keys in tutorials | Rotate the secret; coach the user |
| D8 | URL and markdown exfiltration | Response or tool argument holds a URL or image link to a non-allowlisted domain with long or encoded query params | 1 if fetched, else 2 | Analytics links, signed URLs | Check egress for the fetch and decode the params |
| D9 | Tool call off-profile | Agent calls a tool outside its declared task profile, a state-changing tool without approval, or a first-seen tool and argument pair | 1 if state changed, else 2 | New features shipped without profile update | Pull tool log; was it preceded by D2 or D3? |
| D10 | RAG poisoning | Newly indexed or edited doc with instruction phrasing, hidden text, or a sudden rise in retrieval rank; edits by new or external accounts | 2 | Bulk migrations | Diff doc versions; list who can edit the source |
| D11 | MCP tool drift (rug pull) | Hash of an MCP tool name, description or schema changes without a change ticket; new server connected | 2 | Legitimate upgrades | Diff descriptions; freeze the server version |
| D12 | Poisoned agent rules files | CLAUDE.md, AGENTS.md, .cursorrules, .github/copilot-instructions.md changed by a non-owner, or containing URLs, curl, encoded blobs or hidden Unicode | 2 | Normal repo maintenance | Review the diff; check which agents ran after it |
| D13 | Hallucinated package (slopsquatting) | Agent installs a package not in the allowlist, registered under 30 days ago, or with very few downloads | 2 | Real new packages | Block install; scan host if it ran |
| D14 | Agent memory poisoning | Write to long-term agent memory containing instructions, URLs or tool names, especially after reading external content | 2 | Users saving their own preferences | Purge the memory entry; trace its origin turn |
| D15 | Agent identity anomaly | Agent credential used from a new IP, ASN or host; scope added; agent calls another agent outside its allowed graph | 2 | Infra moves | Revoke the token; confirm the owner |
| D16 | LLMjacking | Model API calls from an unused key, new region or new principal; model-enumeration calls; Bedrock or Vertex invocations from a role that never used them; cost spike over 3x baseline | 1 | Sanctioned new projects | Disable the key; check CloudTrail or audit logs for the stolen credential's path |
| D17 | Unsafe output to a sink | Model output reaches a shell, SQL, eval, or HTML render without validation; or cites a URL, package or document that does not exist and someone acted on it | 2 | Sandboxed code tools | Review the sink; check what executed |
| D18 | Extraction or unbounded consumption | One key or user sends systematic near-duplicate queries, requests logprobs at volume, or one prompt triggers a long tool chain | 3 | Batch jobs, evals | Rate-limit; compare query entropy to normal users |
| D19 | CI/CD coding-agent hijack | A workflow runs an AI agent on pull\_request\_target, issue or comment events from outside contributors while secrets or write tokens are in its environment; agent output or logs contain env dumps, tokens or whoami-style commands | 1 if a secret appears, else 2 | Maintainer-triggered runs, test fixtures | Rotate exposed secrets; run RB13 |
| D20 | Exposed or unmanaged agent control plane | Agent gateways, MCP servers or self-hosted agents (for example OpenClaw on port 18789) reachable from outside localhost or the internet, running unpatched versions, or installing skills from public marketplaces | 2 | Sanctioned internal gateways | Isolate, patch, rotate stored tokens; run RB8 |
| D21 | AI-driven intrusion behaviour | One host or identity runs hundreds of distinct discovery or exploitation commands within minutes, at sub-second intervals, across many targets; swarms of short-lived containers or sandboxes; credential use immediately after discovery | 1 | Vulnerability scanners, sanctioned red teams, CI jobs | Contain on behaviour; run RB11 |

**Rules for every rule**

- Each detection has an owner, a test case in the red-team suite, a backtest on 60 to 90 days, measured precision and recall, and a runbook link.
- Deploy in informational mode for two weeks. Promote to alerting only when precision meets the target in Part 8.
- Use classifiers for semantics and string matching only as a cheap pre-filter. Phrases like "ignore previous instructions" catch tests, not attackers.

## Part 5: Threat hunting

A hunt starts from a hypothesis, runs for a fixed time box (usually 5 working days), and ends with a written result even when nothing is found. Every hunt that finds something produces a detection.

| ID | Hypothesis | Data | Method |
| --- | --- | --- | --- |
| H1 | Indirect injection in our corpus has already steered an agent | Guardrail, retrieval, tool call | Join injection hits in retrieved content to tool calls later in the same conversation (Q2) |
| H2 | Agents call tools outside their task with no human review | Tool call, agent profiles | Compare calls to the declared profile (Q1) |
| H3 | Data is leaving through rendered links | Response, egress | Extract URLs from output, filter to unapproved domains (Q3) |
| H4 | Hidden text is being planted in content we index | Retrieval, document store | Scan for invisible Unicode and hidden formatting (Q4) |
| H5 | Stolen cloud keys are being used to call our models | Cloud audit, cost | New principal or region for model APIs (Q5) |
| H6 | Our outputs leak secrets the guardrail misses | Response, guardrail | Secret patterns joined to guardrail actions (Q6) |
| H7 | Someone is extracting our model or burning our budget | Usage | Hourly token and request outliers per key (Q7) |
| H8 | An attacker is using an AI agent against us | EDR, proxy, auth | Look for machine-speed activity: hundreds of distinct recon commands in minutes, tight sub-second intervals, broad scanning from one host or developer machine running an agent CLI; swarms of short-lived containers; new outbound C2 on public services (D21) |
| H9 | Staff paste sensitive data into unsanctioned AI tools | Proxy, CASB, DLP | Large POSTs to AI domains not on the sanctioned list, by user |

The queries below assume the Part 3 schema. Splunk sourcetypes are `ai:prompt`, `ai:response`, `ai:retrieval`, `ai:tool_call`, `ai:guardrail`, `ai:usage`. Sentinel custom tables use the same names with a `_CL` suffix. Rename to match your pipeline and test before use.

**Q1. Off-profile and unapproved tool calls (Splunk)**

```spl
index=ai sourcetype=ai:tool_call earliest=-30d
| lookup agent_tool_profile.csv agent_id tool_name OUTPUT allowed
| where isnull(allowed) OR (state_changing="true" AND isnull(approver))
| stats count values(tool_name) as tools values(arguments) as args by agent_id user_id conversation_id
| sort - count
```

Read it as: any tool the agent was never meant to call, or any state change no human approved. Both are findings, even if harmless.

**Q2. Injection in content followed by a tool call (Splunk)**

```spl
index=ai sourcetype=ai:guardrail direction IN ("retrieval","tool_return") score>=0.5
| rename _time as inj_time
| fields conversation_id inj_time classifier score source_doc
| join type=inner max=0 conversation_id
    [ search index=ai sourcetype=ai:tool_call
      | rename _time as call_time
      | fields conversation_id call_time tool_name arguments ]
| where call_time > inj_time
| table conversation_id source_doc score inj_time call_time tool_name arguments
```

Read it as: the model read something hostile, then acted. That sequence is the incident; either half alone is noise.

**Q3. Exfiltration through links in output (Splunk)**

```spl
index=ai sourcetype=ai:response earliest=-7d
| rex field=response_text max_match=20 "(?<url>https?://[^\s\)\"'<>]+)"
| mvexpand url
| rex field=url "https?://(?<domain>[^/:?]+)"
| lookup approved_domains.csv domain OUTPUT approved
| where isnull(approved) AND len(url) > 100
| stats count values(url) as urls by user_id conversation_id domain
```

Then search egress for the same URLs. A rendered image link is fetched with no click.

**Q4. Invisible Unicode in prompts or retrieved text (Sentinel KQL)**

```kql
union AIPrompt_CL, AIRetrieval_CL
| where TimeGenerated > ago(30d)
| extend body = coalesce(prompt_text, chunk_text_inserted)
| where body matches regex @"[\x{E0000}-\x{E007F}\x{200B}-\x{200F}\x{202A}-\x{202E}\x{2060}-\x{2064}]"
| project TimeGenerated, conversation_id, user_id, doc_id, last_editor, body
```

**Q5. LLMjacking: new principal or region calling Bedrock (Sentinel KQL)**

```kql
let lookback = 30d;
let recent = 1d;
let bedrockEvents = dynamic(["InvokeModel","InvokeModelWithResponseStream","Converse","ConverseStream","ListFoundationModels","GetFoundationModelAvailability","GetModelInvocationLoggingConfiguration","PutUseCaseForModelAccess"]);
let baseline = AWSCloudTrail
    | where TimeGenerated between (ago(lookback) .. ago(recent))
    | where EventSource == "bedrock.amazonaws.com"
    | distinct UserIdentityArn, AWSRegion;
AWSCloudTrail
| where TimeGenerated > ago(recent)
| where EventSource == "bedrock.amazonaws.com" and EventName in (bedrockEvents)
| join kind=leftanti baseline on UserIdentityArn, AWSRegion
| summarize Calls = count(), Events = make_set(EventName), IPs = make_set(SourceIpAddress) by UserIdentityArn, AWSRegion
| order by Calls desc
```

Check that model invocation calls reach CloudTrail in your accounts, and enable Bedrock model invocation logging. A call to `GetModelInvocationLoggingConfiguration` from an unfamiliar principal is classic attacker recon. Build the same hunt on Azure OpenAI and Vertex AI audit logs.

**Q6. Secrets in output, caught versus missed (Sentinel KQL)**

```kql
AIResponse_CL
| where TimeGenerated > ago(7d)
| where response_text matches regex @"(AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{36}|xox[baprs]-[A-Za-z0-9-]{10,}|sk-[A-Za-z0-9_-]{20,}|-----BEGIN [A-Z ]*PRIVATE KEY-----)"
| join kind=leftouter (AIGuardrail_CL | where direction == "out" | project conversation_id, turn, action, score) on conversation_id, turn
| summarize Leaks = count(), Caught = countif(action == "block") by user_id, conversation_id
| extend Missed = Leaks - Caught
| where Missed > 0
```

A leak the guardrail missed is a separate finding from the leak itself: it means the filter needs work.

**Q7. Extraction and cost outliers (Splunk)**

```spl
index=ai sourcetype=ai:usage earliest=-14d
| bin _time span=1h
| stats sum(tokens) as tokens count as requests dc(prompt_hash) as unique_prompts by _time api_key_id
| eventstats median(tokens) as med_tokens by api_key_id
| where tokens > 3*med_tokens AND requests > 500
| eval prompt_diversity = round(unique_prompts/requests, 2)
```

High volume with high prompt diversity and templated structure suggests extraction. High volume with low diversity suggests a loop or a batch job.

**Q8. Platform AI alerts in one view (Sentinel KQL)**

```kql
SecurityAlert
| where TimeGenerated > ago(30d)
| where ProductName has "Defender for Cloud" or ProviderName has "Azure Security Center"
| where AlertType startswith "AI."
| summarize Alerts = count(), Types = make_set(AlertType), Resources = make_set(ResourceId) by bin(TimeGenerated, 1d), AlertSeverity
| order by TimeGenerated desc
```

Defender for Cloud's AI threat protection raises alerts for jailbreaks, prompt injection, credential theft and data exposure on Azure AI and Foundry agents. Confirm the alert-type prefix in your tenant, then join these to the Part 3 logs by resource and time to get the full conversation.

**Q9. Coding agents exposed to untrusted CI events (shell, run across repos)**

```bash
# Workflows that (1) trigger on events outsiders control, (2) run an AI agent, (3) can reach secrets or write tokens
grep -RlE "pull_request_target|issue_comment|issues:|pull_request_review_comment" .github/workflows 2>/dev/null \
  | xargs -r grep -lE "anthropics/claude-code-action|google-github-actions/run-gemini-cli|openai/codex-action|copilot" \
  | xargs -r grep -lE "secrets\.|contents: write|pull-requests: write|id-token: write"
```

Every file this prints is a Comment and Control candidate (D19). Fix by running the agent without secrets on untrusted events, using read-only tokens, and moving model credentials to OIDC. Pair it with an internal scan for exposed agent gateways, for example `nmap -p 18789 --open <range>` for OpenClaw (D20).

**Hunt write-up template**

- Hypothesis and ATLAS or OWASP mapping
- Data sources and time range checked, and what was not available
- Queries run, with result counts
- Findings, each with evidence and a severity
- Detection created or tuned, and its backtest numbers
- What to hunt next

## Part 6: Protection

Architecture beats filtering. Choose a design pattern that limits what an injected instruction can reach, then layer classifiers on top to cut volume.

The evidence for this ordering is strong. In "The Attacker Moves Second" (October 2025), researchers from OpenAI, Anthropic and Google DeepMind broke 12 published jailbreak and prompt-injection defenses with adaptive attacks, mostly above 90 percent success, although most had originally reported near-zero attack success. Human red-teamers beat every one. Treat any vendor claim of "blocks prompt injection" as a volume reducer, not a boundary.

### Design patterns that contain prompt injection

| Pattern | How it works | Use when |
| --- | --- | --- |
| Plan-then-execute | The agent fixes its plan and tool sequence before reading untrusted content; content can fill arguments but not add steps | Workflows with a known shape (triage, summarise, file a ticket) |
| Dual LLM (quarantined reader) | A privileged model plans and calls tools; a quarantined model with no tools reads untrusted content and returns only typed values | Agents that must read email, web or tickets |
| Capability tracking (CaMeL-style) | Every value carries its source; policy blocks untrusted-origin data from flowing to sensitive sinks | High-value agents where you control the runtime |
| Action selector | The model only picks from a fixed menu of actions; it never composes free-form tool calls | Customer-facing bots |
| Context minimisation | Strip the user's original request or untrusted text from context before the action step | Multi-step agents with long contexts |
| Fresh-session gating | When a session would hold all three Rule of Two properties, stop and ask a human or restart without the untrusted content | Any general-purpose agent |

### The control stack

Deploy every layer. Each row names how it fails, because each one will.

| # | Layer | Controls | Typical failure |
| --- | --- | --- | --- |
| 1 | Identity | Per-agent workload identity, short-lived tokens, delegated user scopes, no API keys in browsers or repos | Shared secrets, over-scoped OAuth grants |
| 2 | Inbound filter | Injection and jailbreak classifier, invisible-Unicode stripping, PII redaction | Novel phrasing, other languages, encodings |
| 3 | Retrieval filter | Per-user ACL on the vector store, scan at index time and at query time, provenance tags, spotlighting (delimit or encode untrusted text) | Content the user can read is still hostile |
| 4 | Model | Vendor safety training, instruction hierarchy, system prompt hardening | Not a security boundary |
| 5 | Tool gating | Allowlisted tools per task, argument schemas, policy engine (OPA, Cedar) on every call, human approval for state changes, sandboxed code execution | Approval fatigue, vague approval prompts |
| 6 | Egress | Domain allowlist for agents and tools, block markdown image rendering to unknown hosts, CSP on chat UIs | Allowlisted domains that host user content |
| 7 | Outbound filter | DLP, secrets scanning, groundedness and citation checks, canary detection | Encoded or split data |
| 8 | Output handling | Encode for the sink, parameterised queries, never `eval` model output | New sinks added without review |
| 9 | Limits | Per-user and per-key rate, token, step and cost caps; max tool-call depth | Limits set but never alerted on |
| 10 | Observability | Full traces to SIEM, AIBOM, kill switch per agent | Logs exist but are not joined |

### Supply chain and MCP hardening

- Load model weights only as SafeTensors or GGUF from verified sources; scan with ModelScan, HiddenLayer or Prisma AIRS; record the hash in the AIBOM. Never load untrusted pickle.
- Run MCP servers in their own container with no ambient credentials, a network allowlist, and a read-only filesystem unless the task needs writes.
- Pin MCP server versions and hash each tool's name, description and schema; alert on drift (D11). Review descriptions for hidden instructions before approval.
- Prefer remote MCP servers that use OAuth with per-user consent over local servers holding long-lived tokens.
- Treat agent rules files and skills as code: CODEOWNERS, signed commits, review required (D12).
- Install packages only from an internal mirror with an allowlist; block packages under 30 days old for agent-driven installs (D13).

* Scan MCP servers against the OWASP MCP Top 10 (beta); tool poisoning is MCP03. Invariant Labs' `mcp-scan` pins tool definitions by hash to catch rug pulls, and more than 30 CVEs were filed against MCP servers, clients and tooling in January-February 2026 alone.

### CI/CD and data-pipeline hardening

- Never run an AI agent on events outsiders control (`pull_request_target`, issue and comment triggers) in the same runtime as production secrets. The Comment and Control research showed one pattern working against three vendors' agents.
- Give CI agents read-only tokens by default, move model credentials to OIDC role assumption, cap tool-call loops, and route agent egress through an allowlist.
- Treat dataset and model loaders as code execution. The Hugging Face intrusion began with a malicious dataset exploiting a remote-code loader and a template injection; disable remote code in loaders, sandbox processing workers, and keep cluster credentials off them.
- Isolate AI evaluation and red-team harnesses as if the model under test is hostile, including package proxies and other "only" egress paths.

### Agent identity

- Five Eyes guidance asks for a verified, cryptographically secured identity per agent, short-lived credentials that expire when the sub-task ends, and encrypted agent-to-agent and agent-to-service traffic.
- Platforms now support this directly: Microsoft Entra Agent ID reached general availability in 2026, with Conditional Access and ID Protection for agents rolling out mid-year; Okta and others offer equivalents. Use on-behalf-of flows that record both the user and the agent as actors.
- Every agent has a named human owner, appears in the inventory, and is covered by access reviews like any other identity.

### Tool map, status as of November 2026

Pick one tool per layer and learn it well. Check vendor status before you build on it.

| Layer | Open source or self-hosted | Cloud native | Commercial |
| --- | --- | --- | --- |
| Input and output classifiers | Llama Guard 4, Prompt Guard 2, Granite Guardian, ShieldGemma | Azure AI Content Safety with Prompt Shields, AWS Bedrock Guardrails, Google Model Armor, OpenAI moderation | Check Point (Lakera), Palo Alto Prisma AIRS, Cisco AI Defense, F5 (CalypsoAI), SentinelOne (Prompt Security), HiddenLayer |
| Orchestration rails | NVIDIA NeMo Guardrails, Guardrails AI | Built into each cloud's agent runtime | Same platforms as above |
| PII and DLP | Microsoft Presidio | Microsoft Purview, Google Sensitive Data Protection, Amazon Macie | Nightfall, Cyberhaven, MIND |
| Model and supply chain scanning | ModelScan, PickleScan | Registry scanning in Vertex, Azure ML, SageMaker | HiddenLayer, Prisma AIRS |
| Red teaming and evals | Garak, PyRIT, Promptfoo, Giskard, Inspect | Azure AI red teaming agent | Vendor red-team services |
| Tracing and observability | Langfuse, Arize Phoenix, OpenTelemetry GenAI | Azure AI Foundry tracing, Bedrock invocation logging, Vertex logging | LangSmith, Helicone, Braintrust, Datadog LLM Observability |
| SIEM and threat detection | Sigma rules | Microsoft Sentinel, Defender for Cloud AI threat protection, GuardDuty, Security Command Center | Splunk, Google SecOps |

**Market changes to know (as of November 6, 2026).** Consolidation is fast; check ownership before you build on a tool.

| Date | Acquirer | Company | Capability |
| --- | --- | --- | --- |
| Nov 5, 2026 (reported talks) | Palo Alto Networks | Clutch Security | AI agent access to systems |
| Nov 3, 2026 | CrowdStrike | Fiddler AI, Dreadnode | Agent observability; AI security testing |
| Aug 2026 | Fortinet | Virtue AI | AI security |
| Jul 9, 2026 | Protect AI (archived) | LLM Guard repository | Now read-only; migrate or use a maintained fork |
| 2026 | Cyera | Oasis Security | AI agent and non-human identity access |
| Mar 9, 2026 | OpenAI | Promptfoo | Red teaming and evals; stays open source |
| Feb 17, 2026 | Palo Alto Networks | Koi | Agent, plugin and extension governance on endpoints |
| Feb 12, 2026 | Proofpoint | Acuvity | AI usage governance and runtime protection |
| Nov 2025 | Zscaler | SPLX (SplxAI) | AI asset discovery, automated red teaming |
| Sep 2025 | Cato Networks | Aim Security | Shadow AI, AI firewall (Aim found EchoLeak) |
| Sep 2025 | Check Point; F5; CrowdStrike | Lakera; CalypsoAI; Pangea | Prompt and runtime guardrails |
| 2025 | SentinelOne; Palo Alto Networks | Prompt Security; Protect AI (now Prisma AIRS) | Prompt security; runtime and model scanning |
| 2024 | Cisco | Robust Intelligence (now Cisco AI Defense) | Model evaluation and runtime protection |

### Governance, what auditors ask for

- **Five Eyes, "Careful Adoption of Agentic AI Services"** (May 1, 2026): the first joint guidance from CISA, NSA and their Australian, Canadian, New Zealand and UK counterparts on agentic AI. Five risk categories (Part 2) plus prerequisites before deploying agents. Expect auditors to ask about it.
- **NIST Cyber AI Profile (IR 8596, preliminary draft December 2025)** maps CSF 2.0 to AI in three focus areas: Secure AI components, Defend with AI, Thwart AI-enabled attacks. **COSAiS** adds SP 800-53 control overlays, with planned volumes for single-agent and multi-agent systems. Also NIST AI RMF and NIST AI 100-2 (adversarial ML taxonomy).
- **OWASP**: LLM Top 10 2026 (August 2026, now weighted with incident data), Agentic Top 10 2026, MCP Top 10 (beta).
- **ISO/IEC 42001**: the AI management system certificate buyers ask for, alongside SOC 2 and ISO 27001.
- **EU AI Act**: the Digital Omnibus on AI entered into force July 27, 2026. High-risk obligations now apply from December 2, 2027 (Annex III) and August 2, 2028 (Annex I). GPAI obligations have applied since August 2025.
- Map your detections to these once, and keep the evidence (logs, tests, reviews) where auditors can sample it.

## Part 7: Incident response

Run your existing IR process (NIST SP 800-61r3 or equivalent) and add the AI steps below. When impact is unknown, treat the case one severity higher until evidence says otherwise.

### Severity

| Sev | Definition | Examples | Response target |
| --- | --- | --- | --- |
| 1 | Confirmed harm: data left, an unapproved state change happened, attacker code ran, or a credential is being abused | EchoLeak-style exfil, agent sent email or changed records via injection, LLMjacking in progress | Contain within 15 min, incident commander paged, legal and privacy engaged |
| 2 | Attack succeeded inside the system, no confirmed external impact yet | Injection steered the model but egress was blocked, poisoned doc in the index, compromised MCP server connected but unused | Contain within 4 h, preserve evidence |
| 3 | Attempt detected, no success | Guardrail blocked, extraction probing, jailbreak refused | Triage within 1 business day, label, add to test set |
| 4 | Policy question, borderline content, false positive | Over-blocking of a legitimate user | Review queue, write or update the standard |

### Roles

| Role | Owns |
| --- | --- |
| Incident commander | Severity, decisions, timeline |
| AI system owner | Model, prompt, tools, index; executes containment in the app |
| SOC analyst | Evidence, queries, scoping |
| Identity and cloud | Token and key revocation, cloud audit logs |
| Privacy and legal | Breach assessment, regulator and customer notice clocks |
| Comms | Internal and external statements |

### First 15 minutes

1. Get the conversation ID, app, model and version, user or agent identity, and time window.
2. Pull the full conversation, retrieved content, tool calls with arguments, and guardrail scores. Never judge from the flagged turn alone.
3. Answer: what left the system, and how do you know? Check egress, tool calls, outbound messages and rendered links. If nothing left, write which logs prove it.
4. Is it still happening? If yes, contain using the ladder below.
5. Snapshot evidence: export logs for the whole session plus 24 hours either side, hash the export, and record who collected it. Extend retention on the affected indexes.

### Containment ladder

Use the narrowest step that stops the harm, and escalate if it continues.

1. Kill the session or conversation.
2. Disable the specific tool or MCP server for that agent.
3. Revoke the agent's or user's tokens and API keys.
4. Quarantine the source content (pull the doc from the index, remove the email, freeze the repo file).
5. Disable the agent or app (kill switch).
6. Roll back the model, prompt, index or memory to the last known-good version.

Do not block a single prompt string and call it contained. Block the technique and the path.

### Notification triggers

Personal data exposed to an unauthorised party starts privacy clocks, such as 72 hours under GDPR. Material incidents may trigger customer contract, sector regulator or SEC disclosure duties. Bring in legal at Sev 1 and whenever personal data is involved; they decide on notice.

### Runbooks

Each runbook ends with exit criteria. Do not close until all are met.

**RB1. Direct prompt injection or jailbreak** (D1, D4)

1. Pull the conversation. Did the model comply, partly comply, or refuse?
2. Record classifier scores per turn and distance from threshold.
3. List what the model produced or did: content, leaked instructions, tool calls.
4. Search for the same technique from this user and others in the last 30 days.
5. Contain the user if the attempt is repeated or succeeded.

Exit: technique added to the red-team suite; filter or prompt change tested against it plus three variants.

**RB2. Indirect prompt injection** (D2, D3, D8)

1. Find the hostile content in the retrieval or tool-return log. Quote it, including decoded hidden text.
2. Identify the source, its author or sender, and everyone who could edit it.
3. Trace what the model did after reading it: tool calls, links rendered, data in output.
4. Check egress for any fetch of rendered URLs. Decode query parameters to see what data was sent.
5. Quarantine the content and search for the same payload across mail, docs and indexes.
6. If data left, escalate to Sev 1 and run RB4 in parallel.

Exit: payload removed everywhere it exists; the path (tool, egress rule, rendering) closed; detection proven on the original payload.

**RB3. Harmful content generated** (D4)

1. Capture the output and the full conversation.
2. Determine whether the content reached anyone else or was used.
3. Check whether the same bypass works on the current model and filter.

Exit: outbound filter or model config updated and tested; case added to the labeled set.

**RB4. Sensitive information disclosure** (D6, D7)

1. Classify the data: credential, personal data, regulated data, internal confidential.
2. Find its origin: training data, retrieval, conversation, or tool return.
3. Identify every recipient: the user, rendered links, tool calls, logs, downstream systems.
4. Rotate credentials immediately. Notify data owners and privacy for personal data.
5. Record whether the guardrail fired. A miss is a separate finding.
6. If retrieval was the origin, fix the ACL that let this user reach that data.

Exit: secrets rotated, ACL fixed, privacy decision recorded, DLP rule updated.

**RB5. System prompt leakage** (D5)

1. Diff the leaked text against the current system prompt.
2. Remove any secrets, keys, internal URLs or security logic from the prompt; move enforcement into code.
3. Assess whether the leak tells an attacker how to bypass a control.
4. Rotate the canary.

Exit: prompt contains nothing whose disclosure would matter.

**RB6. RAG or memory poisoning** (D10, D14)

1. Pull every version of the document or memory entry; identify the change and the editor.
2. Find every conversation that retrieved it since the change, and what those sessions did.
3. Remove it, rebuild the index if needed, and record the new index version.
4. Review other content from the same author, source or time window.
5. Tighten who can write to indexed sources or agent memory.

Exit: poisoned content gone from source, index and caches; affected sessions reviewed.

**RB7. Agent tool abuse or unapproved action** (D9, D15)

1. List every tool call in the session with arguments, returns and approvals.
2. Classify each: read, write, send, execute, permission change.
3. Reverse what can be reversed (recall email, restore record, revoke share).
4. Find the trigger: injection (run RB2), bad prompt design, or misuse by the user.
5. Reduce the agent's tools or scopes to its task profile, and add approval to the action class.

Exit: reversible actions reversed, agent permissions narrowed, approval gate tested.

**RB8. Compromised MCP server, plugin or rules file** (D11, D12, D13, D20)

1. Disconnect the server or revert the file across all agents and repos.
2. Diff tool descriptions or file content against the last known-good hash.
3. List every session and host that used it since the change; check for exfil and executed commands.
4. Rotate any credentials the server or agent could reach.
5. Report malicious packages or servers to the registry.

Exit: pinned known-good version, credentials rotated, drift detection active.

**RB9. LLMjacking or stolen model API keys** (D16)

1. Disable the key or role, and capture its last-used IP, region and user agent.
2. Find how the credential leaked: public repo, CI logs, compromised host, browser bundle.
3. Review cloud audit logs for other actions by that credential (new users, model access requests, logging changes).
4. Restore any disabled invocation logging and quota limits.
5. Open a billing case with the provider and record the cost impact as a number.

Exit: credential path closed, cost quantified, alert on new principals and regions live.

**RB10. Model extraction or unbounded consumption** (D18)

1. Pull usage by key and user; compare query structure and diversity to normal users.
2. Rate-limit or suspend the key; confirm limits fire.
3. If extraction is likely, assess what was exposed (logprobs, full outputs) and notify the model owner.

Exit: limits and alerts set per key; cost reported.

**RB11. Attacker using AI against you** (D21, H8)

1. Treat it as a normal intrusion: scope hosts, accounts and data with EDR and identity logs.
2. Expect breadth and speed. Contain on behaviour (rapid recon, mass credential use) rather than waiting for confirmation.
3. If the actor used a commercial AI service, collect indicators and report abuse to the provider.

Exit: standard intrusion exit criteria, plus detections tuned for machine-speed activity.

Lessons from Hugging Face (July 2026): its LLM-based anomaly triage caught the intrusion, and responders used AI agents to rebuild a timeline from more than 17,000 attacker events. When hosted commercial models refused to analyse real exploit payloads, the team switched to an open-weight model on its own infrastructure, which also kept the data in-house. Prepare that capability before you need it: an approved self-hosted model for IR analysis, with access controls and logging.

**RB12. Malicious model artifact** (supply chain)

1. Stop the serving process and isolate the host; deserialisation exploits run code at load time.
2. Compare the weight hash to the AIBOM and the publisher's hash.
3. Image the host, hunt for persistence, rotate credentials it held.
4. Roll back to a scanned, known-good model.

Exit: host rebuilt, model scanning enforced in the deploy pipeline.

**RB13. CI/CD coding-agent hijack** (D19, Q9)

1. Disable the affected workflow and revoke every secret and token its runtime could read: model API keys, `GITHUB_TOKEN` scopes, cloud credentials, package-publishing tokens.
2. Pull the triggering PR, issue or comment and the agent's full log. Quote the injected text, including hidden HTML comments.
3. Search run logs, PR comments, issue comments and branches for leaked values; assume anything printed to a public log is compromised.
4. Check for downstream use: new commits, releases, package publishes, or cloud API calls with the leaked credentials.
5. Re-enable only with untrusted triggers removed or isolated from secrets, read-only tokens, OIDC for model access, and Q9 returning nothing.

Exit: credentials rotated, misuse ruled out from audit logs, workflow hardened and Q9 added to scheduled hunts.

### Post-incident

Within 5 business days: blameless review, timeline, root cause in the Part 2 crosswalk, the detection that would have caught it sooner, the test case added to the red-team suite, and an update to this playbook.

## Part 8: Testing and metrics

Test the system the way attackers will, on every change, and report a small set of numbers leadership can track. The targets below are starting points; set your own after the first quarter of data.

### Red-team cadence

| When | What | Tools |
| --- | --- | --- |
| Every change to model, system prompt, tools, MCP servers or index | Automated suite in CI: injection (direct and indirect), jailbreak, leakage, tool misuse, exfil links; block the release on regression | Promptfoo, Garak, PyRIT |
| Before launch of any agent with write or send tools | Manual red team against the lethal trifecta and Rule of Two | Internal team or vendor |
| Quarterly | Full-scope exercise on top 5 AI apps, including supply chain and identity paths | Internal team or vendor |
| Quarterly | Tabletop exercise (below) | IR team, app owners, legal, comms |

**Test like the attacker moves second.** Static prompt lists overstate defenses. For every filter or design change, add adaptive testing: let a human or an automated search loop see the defense and iterate against it, and report attack success rate after adaptation, not before.

### Tabletop library

1. A customer support email makes the inbox copilot forward a contract to an outside address.
2. A popular MCP server update adds a hidden instruction to its tool description.
3. The cloud bill shows $40,000 of model usage overnight from a region you never use.
4. A developer's coding agent runs a package that does not exist on the internal mirror.
5. A wiki page edited by a contractor makes the HR bot reveal salary bands.
6. An autonomous agent enters through a malicious dataset and moves laterally with harvested cluster credentials over a weekend; your hosted AI assistant refuses to analyse the exploit payloads.
7. A PR title from an outside contributor makes the CI code-review agent print the model API key into a public log.
8. Phishing emails carry hidden instructions that make the inbox assistant rate them urgent and legitimate.

### Detection quality

| Metric | Definition | Starting target |
| --- | --- | --- |
| Precision | True alerts divided by all alerts | 0.8 or higher for paging alerts; lower is acceptable for hunt queues |
| Recall on Sev 1 test set | Share of known high-severity test cases caught | 0.9 or higher |
| False-negative review | Every confirmed incident checked for which detection should have fired | 100 percent |
| Labeler agreement | Cohen's kappa between analysts on a blind sample of 50 cases | 0.7 or higher; below that, write a clearer standard |
| Classifier drift | Change in score distribution after a model or classifier update | Investigate shifts over 10 percent |

### Program KPIs

| KPI | Why it matters |
| --- | --- |
| Share of AI apps with all seven Part 3 log sources | You cannot investigate the rest |
| Share of agents passing the Rule of Two review | Measures structural risk, not filter quality |
| Share of agents with their own identity and short-lived credentials | Limits blast radius of a compromised agent |
| Attack success rate in the CI red-team suite, per app | Tracks whether defences improve release over release |
| Mean time to detect and to contain, AI incidents | Same as any IR program |
| Crosswalk coverage | Share of Part 2 rows with a live detection and a tested runbook |
| Unsanctioned AI usage events per month | Shadow AI trend |

## Part 9: Analyst development, 30/60/90 days

By day 90 a junior analyst should lead a Sev 2 or Sev 3 case, ship one measured detection, and teach one runbook. Each phase ends with a sign-off by a senior.

| Phase | Weeks | Work | Deliverable | Senior exercise |
| --- | --- | --- | --- | --- |
| Learn the system | 1 | Parts 1 and 2; one example per OWASP LLM and Agentic entry; walk through EchoLeak end to end | One-page threat model of one internal AI app, with its trifecta legs counted | Ask them to explain EchoLeak without notes |
|  | 2 | Part 3; pull all seven log sources for one real session and trace it | Annotated timeline of that session | Hide one log source; ask what they can no longer prove |
|  | 3 | Run benign and attack prompts through two classifiers (for example Prompt Guard and Prompt Shields) and compare scores | Short comparison with misses noted | Give them an injection in another language or encoding |
|  | 4 | Work a Sev 3 case using RB1 under supervision | Case notes with label, confidence and rationale | Label a flagged turn with no context, then with the whole conversation; discuss the difference |
| Hunt and adjudicate | 5-6 | Run one hunt from Part 5 | Hunt write-up using the template, including what was not checked | Ask which detection they would build from it |
|  | 7 | Work a Sev 2 case using RB2 or RB7 | Timeline, evidence for and against, decision | Withhold the egress log until they ask for it |
|  | 8 | Blind-label 50 cases; compare with peers | Agreement score and a written standard for the most-disputed category | Give a case two seniors disagree on; require a decision and a written dissent |
| Lead and teach | 9-10 | Lead a Sev 2 or 3 case end to end, senior reviews but does not direct | Incident report | Run a 30-minute tabletop from Part 8 with them as commander |
|  | 11 | Build one detection from Part 4 in Splunk or Sentinel, backtest 60-90 days | Rule, precision and recall, two weeks in informational mode | Ask them to defend the threshold |
|  | 12 | Teach one runbook to a new analyst with a worked example | Recorded or observed session | If they cannot teach it, repeat the runbook |

**Reading list for the path:** OWASP Top 10 for LLM Applications 2026, OWASP MCP Top 10, OWASP Top 10 for Agentic Applications 2026, MITRE ATLAS matrix and case studies, UK NCSC prompt injection guidance, Simon Willison on the lethal trifecta, Meta's Agents Rule of Two, Google DeepMind's CaMeL paper, Anthropic's November 2025 report on an AI-orchestrated espionage campaign, "The Attacker Moves Second" (2025), the Five Eyes "Careful Adoption of Agentic AI Services" (2026), and the OWASP GenAI Exploit Round-up reports (quarterly from 2026).

## Part 10: Checklists, glossary, sources and change log

### Before you ship a model or agent

- [ ] Rule of Two review done; trifecta legs counted and at least one removed or human-gated
- [ ] Agent has its own identity, short-lived credentials, a named owner and a kill switch
- [ ] Tools allowlisted per task with argument schemas; state-changing tools require approval showing exact arguments
- [ ] Egress allowlist in place; markdown images to unknown hosts blocked
- [ ] Inbound, retrieval and outbound filters on, with scores logged
- [ ] Vector store enforces per-user access; content scanned at index time
- [ ] MCP servers sandboxed, version-pinned and description-hashed
- [ ] Model output encoded or validated for every sink
- [ ] Rate, token, step and cost limits set and alerting
- [ ] All seven Part 3 log sources reach the SIEM; AIBOM recorded
- [ ] CI red-team suite passes, including adaptive attacks; manual red team done for write or send agents; no agent runs on untrusted CI events with secrets in reach (Q9 clean)

### Before you close an incident

- [ ] Full conversation, retrieval, tool, guardrail, identity, egress and cost logs preserved and hashed
- [ ] You can state what left the system and which logs prove it
- [ ] Runbook exit criteria met
- [ ] Privacy and legal decision recorded where personal data was involved
- [ ] Case labeled with confidence and rationale; added to the test set
- [ ] Detection, filter or design fix shipped and tested against the original technique plus three variants
- [ ] Playbook updated

### Glossary

| Term | Meaning |
| --- | --- |
| Agent | A model that plans and calls tools to complete a task with some autonomy |
| AIBOM | AI bill of materials: models, datasets, indexes, prompts, tools and their versions |
| ASR | Attack success rate: share of red-team attempts that achieve their goal |
| Canary | A unique string planted in a prompt or document to detect leakage |
| Direct injection | Hostile instructions typed by the user |
| Indirect injection | Hostile instructions hidden in content the model reads |
| Jailbreak | Input designed to make a model ignore its safety rules |
| Lethal trifecta | Private data + untrusted content + external communication in one agent |
| LLMjacking | Using stolen credentials to run models at the victim's expense |
| MCP | Model Context Protocol, a standard way to connect models to tools and data |
| Rug pull | A tool or server that changes its behaviour or description after it was approved |
| Rule of Two | An agent session should hold at most two of: untrusted input, sensitive access, external action |
| Slopsquatting | Registering package names that models tend to hallucinate |
| Spotlighting | Marking untrusted text (delimiters, encoding) so the model can tell it from instructions |
| Precision and recall | Precision: of alerts fired, how many were real. Recall: of real cases, how many fired |

### Sources

Standards and guidance

- [OWASP Top 10 for LLM Applications 2026](https://www.respan.ai/articles/owasp-llm-top-10) (published August 2026; summary and 2025 mapping) and the [OWASP GenAI Security Project](https://genai.owasp.org)
- [OWASP Top 10 for Agentic Applications 2026](https://cycode.com/blog/owasp-top-10-agentic-applications/), published December 9, 2025
- [OWASP MCP Top 10 (beta)](https://owasp.org/www-project-mcp-top-10/) and [MCP tool poisoning overview](https://www.speakeasy.com/resources/mcp-tool-poisoning)
- [Five Eyes, "Careful Adoption of Agentic AI Services" (CSA summary)](https://labs.cloudsecurityalliance.org/research/csa-research-note-cisa-agentic-ai-guide-enterprise-implement/), May 1, 2026
- [NIST IR 8596 Cyber AI Profile, preliminary draft](https://csrc.nist.gov/pubs/ir/8596/iprd) and [NIST COSAiS](https://csrc.nist.gov/projects/cosais)
- MITRE ATLAS, atlas.mitre.org; [v2026.09 summary](https://www.speakeasy.com/blog/mitre-atlas-explained)
- [UK NCSC on prompt injection](https://securityboulevard.com/2025/12/prompt-injection-cant-be-fully-mitigated-ncsc-says-reduce-impact-instead/), December 2025
- [EU Digital Omnibus on AI in force July 27, 2026](https://www.mondaq.com/eu-digital-omnibus-on-ai-enters-into-force/1825722); [new high-risk dates](https://www.holisticai.com/blog/eu-ai-acts-deadline-moved-2027)
- [OpenTelemetry GenAI conventions status](https://www.dash0.com/knowledge/opentelemetry-genai-semantic-conventions-explained)

Research and design

- [Nasr et al., "The Attacker Moves Second"](https://arxiv.org/abs/2510.09023), October 2025
- [Meta's Agents Rule of Two (Simon Willison's summary)](https://simonw.substack.com/p/new-prompt-injection-papers-agents), October 31, 2025; Simon Willison, "The lethal trifecta" (2025); Google DeepMind, CaMeL (2025)

Incidents

- [Barracuda dual-target phishing](https://infosecurity-magazine.com/news/attackers-hide-ai-prompt), October 2026
- [Hugging Face intrusion and OpenAI attribution](https://rits.shanghai.nyu.edu/ai/hugging-face-intrusion-openai-attribution/); [CSA research note](https://labs.cloudsecurityalliance.org/research/csa-research-note-huggingface-autonomous-agent-breach-202607/), July 2026
- [OWASP GenAI Exploit Round-up Q1 2026](https://genai.owasp.org/2026/04/14/owasp-genai-exploit-round-up-report-q1-2026/) (GrafanaGhost, OpenClaw, others)
- [Comment and Control](https://www.digitaltoday.co.kr/en/view/48622/comment-and-control-attack-can-hack-claude-code-gemini-cli-and-github-copilot-at-once), April 2026
- [Mexican government breach via Claude](https://www.thestar.com.my/tech/tech-news/2026/02/26/hacker-used-anthropics-claude-to-steal-mexican-data-trove), February 2026
- [Microsoft, AI Recommendation Poisoning](https://www.microsoft.com/en-us/security/blog/2026/02/10/ai-recommendation-poisoning/), February 10, 2026
- [OpenClaw exposure and CVE-2026-25253](https://www.techzine.eu/news/security/138633/over-40000-openclaw-agents-vulnerable/)
- [MITRE ATT&CK campaign C0062, Anthropic AI-orchestrated campaign](https://attack.mitre.org/campaigns/C0062/)
- [Sysdig, LLMjacking](https://www.sysdig.com/blog/llmjacking-stolen-cloud-credentials-used-in-new-ai-attack), May 2024
- EchoLeak, CVE-2025-32711 (Aim Security, Microsoft 365 Copilot)

Platforms and market

- [Defender for Cloud threat protection for Foundry agents](https://techcommunity.microsoft.com/t5/microsoft-defender-for-cloud/extending-defender-s-ai-threat-protection-to-microsoft-foundry/ba-p/4491927); [Microsoft Entra Agent ID, what's new](https://learn.microsoft.com/en-us/entra/agent-id/whats-new-agent-id)
- [CrowdStrike buys Fiddler AI and Dreadnode](https://techcrunch.com/2026/11/03/crowdstrike-to-shell-out-nearly-500m-for-2-ai-security-startups-as-the-market-for-securing-agents-takes-off/); [Palo Alto Networks and Clutch talks](https://techcrunch.com/2026/11/05/palo-alto-networks-in-talks-to-buy-ai-agent-security-startup-clutch-for-500m/); [Palo Alto Networks and Koi](https://cyberscoop.com/palo-alto-networks-acquires-koi-agentic-ai-security/); [Proofpoint and Acuvity](https://www.proofpoint.com/us/newsroom/press-releases/proofpoint-acquires-acuvity-deliver-ai-security-and-governance-across); [Cato Networks and Aim Security](https://www.securityweek.com/cato-networks-acquires-ai-security-firm-aim-security/amp/); [OpenAI and Promptfoo](https://openai.com/blog/openai-to-acquire-promptfoo); [LLM Guard archived](https://grepture.com/blog/llm-guard-archived-migration-guide)

### Change log

| Date | Version | Change |
| --- | --- | --- |
| Nov 6, 2026 | 2.1 | Executive summary and year-one plan; OWASP LLM 2026, MCP Top 10 and Five Eyes mappings; 2026 incidents; D19-D21, Q8-Q9, RB13; adaptive-testing guidance; agent identity, CI/CD and data-pipeline hardening; vendor status to Nov 5, 2026; author name removed |
| Nov 6, 2026 | 2.0 | Rebuilt from v1: agentic threat model and crosswalk, telemetry schema, 18 detections, runnable queries, severity matrix, 12 runbooks with exit criteria, metrics, vendor status update |
| Nov 6, 2026 | 1.0 | Original playbook |

Update this log after every Sev 1 or Sev 2 incident and every red-team exercise. A playbook that does not change after an incident was not used.
