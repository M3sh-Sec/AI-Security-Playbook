# AI Security and Threat Hunting Playbook
## An IR Handbook for Detection of Threats From, To, and Via Frontier Models

Prepared Nov 6, 2026. For a junior analyst, and for the senior who has to teach them.

Frontier models in scope: Claude, GPT, Gemini, Grok, and Llama, plus any model served through Azure AI Foundry, AWS Bedrock, Google Vertex AI, or a self hosted deployment. The playbook is model agnostic. The threats are the same. The telemetry changes. The judgment does not.

## How to use this playbook

Read Part 1 and Part 2 first. They are the mental model. Everything else is a drill built on them.

If you get an alert, go to Part 6, find the scenario that matches, and work it step by step. Do not skip the evidence step. Do not jump to containment before you know what the model saw, what it did, and what left the system.

If you are a junior analyst, work Part 7 in order. It is a 30, 60, and 90 day path. If you are the senior teaching them, use the exercises in Part 7 as your lesson plans.

A note on honesty: no guardrail reliably stops a determined prompt injection attack. The research is clear on that, and the UK NCSC has said the same. Design as if the guardrail will fail. That is why this playbook is built on least privilege, human gating, egress control, and an audit log, not on one filter.

## Part 1: Principles, learn these first

1. Data becomes code. In an AI system, user input, retrieved documents, and tool return values can all be interpreted as instructions. That is the root cause of almost every AI security issue. Treat retrieved content as untrusted input, every time, even when it looks like a document.
2. Assume the guardrail will fail. Build the blast radius as if it does. Tool permissions, egress rules, and human approval on state changing actions are the real controls.
3. Least privilege for agents, not just for users. An agent should have the smallest set of tools, data, and permissions it needs for the task. Excessive agency is OWASP LLM06, and it is what turns a prompt injection into an incident.
4. Human in the loop on state changing actions. A model can draft, summarize, and recommend. A human approves sending email, changing records, running code, or making payments. No exceptions for high consequence actions.
5. Filter both directions. Inbound: what the user sends, including hidden instructions in pasted content, files, and retrieved context. Outbound: what the model returns, including leaked instructions, leaked training data, disallowed content, and tool actions the user never reviewed. Filter at the conversation level, not just one response at a time.
6. Log everything with a label and a rationale. What was flagged, what was blocked, what was allowed, and why. That log is the training data for the next version of the filter, and it is the evidence for the next investigation.
7. Measure the detection, or do not ship it. Precision and recall on a labeled sample, false positive rate, false negative rate on high severity cases, and agreement rate on blind labeling. A filter that cannot be measured is a guess.
8. Do not put secrets in a system prompt. System prompts leak, often with a single question. Security controls must not depend on keeping the prompt secret.

## Part 2: Threat model, from, to, and via

Think in three directions. Every AI incident is one of these, or a combination.

### Threats FROM a model
The model itself is the source. It produces disallowed content, hallucinates a source or a citation, leaks training data or system instructions, or takes an action its user never reviewed. Examples: a model writes exploit code on request, repeats a system prompt verbatim, or calls a tool to send data out.

### Threats TO a model
The model is the target. An attacker tries to steal it, poison it, or exhaust it. Examples: prompt injection to extract the system prompt, model extraction by querying it thousands of times to build a cheaper imitation, data poisoning in a fine tuning or RAG dataset, and unbounded consumption, crafted inputs that burn compute and cost, or cause denial of service.

### Threats VIA a model
The model is the conduit. An attacker uses it to reach something else. Examples: indirect prompt injection in an email or a web page that makes a Copilot leak internal data, an agent that reads a poisoned document and then calls a tool to change a record, or a model that is used to write phishing, malware, or disinformation at scale.

### OWASP Top 10 for LLM Applications, 2025, the map to use

Use this as your checklist. Every detection and every playbook in Part 6 maps to one of these.

- LLM01 Prompt Injection. Input, direct or hidden in content, changes what the model does. Direct: the user types it. Indirect: instructions hide in a web page, an email, a PDF, a code comment, a tool result, or an agent rules file such as CLAUDE.md, AGENTS.md, or .cursorrules. No complete fix exists.
- LLM02 Sensitive Information Disclosure. The model or its integrations leak secrets, personal data, or internal data through output. Includes secrets pasted into prompts and API keys shipped to a browser so a frontend can call an LLM directly.
- LLM03 Supply Chain. Compromised models, packages, plugins, or MCP servers. Model files can carry backdoors and serialization exploits. Ban pickle. Use SafeTensors only.
- LLM04 Data and Model Poisoning. Tampered training, fine tuning, or embedding data. In most teams this shows up in RAG: anyone who can edit a wiki page, upload a document, or post a support ticket that gets indexed can put text in front of your model.
- LLM05 Improper Output Handling. Model output is used unchecked in code, SQL, HTML, or shell. The model is not a trusted source. Validate output before it touches another system.
- LLM06 Excessive Agency. The model has more tools, permissions, or autonomy than it needs. A support bot with write access to a database, or an agent tool that runs arbitrary shell commands, is the classic case.
- LLM07 System Prompt Leakage. Secrets or security logic placed in a system prompt get exposed. Extraction techniques, repetition, formatting tricks, and multi turn probing, recover them reliably.
- LLM08 Vector and Embedding Weaknesses. RAG stores leak across users or get poisoned. Attackers exploit weak access controls on a vector store to retrieve other tenants' embedded content, or invert embeddings to recover source text.
- LLM09 Misinformation. The model produces false information that is acted on as if it were true. Groundedness checks and citation verification are the controls.
- LLM10 Unbounded Consumption. No limits on usage, leading to runaway cost, denial of service, or model extraction. Crafted inputs that consume disproportionate resources are the attack.

Real case to know: EchoLeak, CVE-2025-32711, CVSS 9.3, found by Aim Security in Microsoft 365 Copilot. A crafted email, with no click, made the assistant leak internal data. Microsoft fixed it in June 2025. It is the textbook indirect prompt injection case. Teach it to every junior analyst.

## Part 3: Detection, what to collect, what to hunt for

### Telemetry, the minimum set

If you do not have these logs, you cannot investigate an AI incident. Get them first.

- Prompt and response logs: full prompt, full response, model name and version, timestamp, user and session ID, and the guardrail decision, allowed, flagged, blocked, and why. Keep the conversation ID, so you can trace across turns.
- Tool call logs: every tool the agent called, what arguments it passed, what the tool returned, and whether a human approved it. Tool calls are the action. Everything else is talk.
- Retrieval logs: what documents were retrieved, from which index, with what access control, and what text was actually inserted into the prompt. RAG without retrieval logging is uninvestigable.
- Guardrail logs: which classifier fired, with what score, on which input or output. Llama Guard, Prompt Guard, Lakera Guard, Azure AI Content Safety, or Bedrock Guardrails, whichever you run, log the score, not just the verdict.
- Identity and access logs: who called the model, with what token, from where, and what data they could reach. Entra ID, IAM, and API key logs belong in the same timeline as the prompt logs.
- Model and supply chain logs: model file hash, model version, dataset version, embedding index version, and MCP server list. If you cannot say which model and which data produced an output, you cannot reproduce it.
- Cost and usage logs: tokens per user, per session, per hour. Unbounded consumption shows up here first.

### Detection rules, start with these ten

Each rule has a name, a signal, and a next step. Do not ship a rule without a next step.

1. Indirect injection in retrieved content. Signal: retrieved text contains instruction language, "ignore prior instructions," "disregard," "you are now," or a URL, an email address, or a command, in a document the user did not write. Next step: pull the document, check who could edit it, and check whether the model followed it.
2. System prompt extraction attempt. Signal: repeated prompts asking for the system prompt, instructions, or rules, or asking the model to repeat, summarize, or format its instructions. Next step: check what leaked, and check what was in the system prompt that should never have been there.
3. Jailbreak pattern, multi turn. Signal: the same user, across turns, reframing a disallowed request, using role play, encoding, or splitting it into harmless looking parts. Next step: look at the conversation, not one prompt. The pattern is the signal.
4. Tool abuse. Signal: an agent calls a tool it does not need for the task, or calls a tool with arguments the user never reviewed. Next step: check the tool call log, the arguments, and the return value. Check what left the system.
5. Data exfiltration via the model. Signal: a model output contains secrets, PII, or internal data, or a user asks the model to encode, split, or repeat data across turns. Next step: check the egress, the destination, and the volume. Check whether the data was in the training set, the retrieval set, or the conversation.
6. RAG poisoning. Signal: a newly indexed document contains instruction language, or a document's content changes sharply and the model starts following it. Next step: pull the document version, check who edited it, and check the embedding index version.
7. Model extraction. Signal: a single user or API key queries the model thousands of times, with systematic variations, at a rate far above normal. Next step: check the usage log, the query pattern, and the cost. Rate limit and investigate.
8. Unbounded consumption. Signal: tokens per user or per session spike, or a single prompt triggers a long, expensive chain of tool calls. Next step: check the cost log, the prompt, and whether a limit was in place.
9. Guardrail bypass, repeated. Signal: the same user, the same bypass technique, working repeatedly, across sessions. Next step: add the case to the blind sample set, and write the standard for it.
10. Hallucinated context acted on. Signal: a model output cites a source, a link, or a document that does not exist, and a user or an agent acts on it. Next step: verify the citation, and check whether the output was used unchecked in code, SQL, HTML, or shell.

### Hunting hypotheses, use these to start a hunt

A hunt starts with a hypothesis, not with an alert. Use these, one per hunt.

- H1: An attacker is using indirect injection in our RAG corpus to make the model leak data. Hunt: search retrieved documents for instruction language, and check whether the model followed any of them.
- H2: An agent is calling tools it does not need, and no human is reviewing the calls. Hunt: list tool calls by agent, by tool, and by user, and look for tools that do not match the task.
- H3: A user is extracting the system prompt, one piece at a time, across turns. Hunt: search prompt logs for extraction language, grouped by user and session, across the conversation.
- H4: A poisoned document is in our RAG index, and the model is following it. Hunt: list documents indexed in the last 30 days, check who edited them, and check whether the model cited them.
- H5: A model is leaking training data through repeated probing. Hunt: search response logs for near verbatim repeats, grouped by user, and check the elicitation pattern.
- H6: An attacker is using the model to write phishing or malware at scale. Hunt: search prompt logs for exploit authoring patterns, grouped by user, infrastructure, and targeting.

### Queries, Splunk and Sentinel, walk them out loud

Splunk, Beacon style hunt adapted for AI, tool calls by an agent:
`index=ai_logs sourcetype=agent_tool_calls | stats count, dc(tool_name) as tools, values(tool_name) as tool_list by user, session_id, agent_name | where count > 20 AND tools > 5`
Read it as: one user, one session, many tool calls, many different tools. That is an agent doing more than its task needs.

Sentinel KQL, same hunt, on your AI telemetry table:
On your agent tool call table, summarize count, dcount of ToolName, by User, SessionId, and AgentName, where count is greater than 20 and dcount of ToolName is greater than 5. Then say: "An agent that calls many different tools, many times, in one session, is worth a look. An agent that calls one tool, for one task, is usually normal."

Splunk, prompt injection hunt:
`index=ai_logs sourcetype=prompt_logs "ignore prior instructions" OR "disregard" OR "you are now" | stats count by user, session_id, source`
Read it as: who is trying it, in which session, and did it come from the user or from retrieved content. The source field is the difference between direct and indirect injection.

Sentinel KQL, data leak hunt:
On your model response table, filter where the response contains a secret pattern, a credential, or PII, summarize count by User and SessionId, and join to the guardrail log to see whether the guardrail fired. Then say: "A leak the guardrail missed is a different incident from a leak the guardrail caught. I need to know which one this is."

## Part 4: Mitigation, the guardrail stack

### The stack, in order, from the user to the model and back

Do not rely on one layer. Use all of them, and design as if each one will fail.

1. Identity and access. Entra ID, IAM, or your IdP. Who can call the model, with what token, from where, and what data can they reach. Use short lived tokens, not long lived API keys. Never ship an API key to a browser so a frontend can call an LLM directly.
2. Inbound filter. Prompt classification, jailbreak detection, and PII redaction on the way in. Tools: Llama Guard, Prompt Guard, Lakera Guard, Azure AI Content Safety with Prompt Shield, AWS Bedrock Guardrails, Google Model Armor, or a commercial AI firewall such as Palo Alto Prisma AIRS, Cisco AI Defense, or Check Point Lakera. Self hosted classifier models you can run yourself: Llama Guard, Granite Guardian, and ShieldGemma. Cloud moderation APIs: Bedrock Guardrails, Azure AI Content Safety, Model Armor, and OpenAI's moderation endpoint.
3. Retrieval filter. RAG documents are untrusted input. Scan retrieved text for instruction language before it is inserted into the prompt. Enforce access control on the vector store, per tenant and per user. Log what was retrieved and what was actually inserted.
4. Model, with alignment and safety training. The model itself carries alignment and safety training. That is a layer, not a guarantee. Do not depend on it alone.
5. Outbound filter. Response classification, instruction and data leak checks, groundedness and hallucination checks, and DLP on outputs. Tools: the same classifiers as inbound, plus Microsoft Presidio for PII detection and anonymization, Microsoft Purview DLP, and Nightfall or Cyberhaven for DLP on AI traffic.
6. Tool gating. Human approval on state changing actions. Tool permissions per agent, per task. Egress rules on what a tool can reach. An agent that can read a file should not also be able to send email, unless the task needs both.
7. Output handling. Validate model output before it touches another system. Do not pass model output unchecked into code, SQL, HTML, or shell. That is OWASP LLM05.
8. Logging and observability. Langfuse, LangSmith, Arize Phoenix, Helicone, Braintrust, Datadog, or your SIEM. Central prompt repository, tracing, evaluation, and cost tracking. The flight recorder for your AI.

### Tool map, current technology, as of Nov 2026

Use this table to choose, not to buy everything. Pick one tool per layer, and learn it well.

- Input and output classifiers, self hosted: Llama Guard 4, content harm classification for text and images, prompt or response, self hosted weights. Prompt Guard, prompt injection and jailbreak detection. Granite Guardian, and ShieldGemma, similar classifier models.
- Input and output classifiers, cloud: Azure AI Content Safety, with Prompt Shield for indirect injection, jailbreak detection, and groundedness checks, built into Azure AI Foundry. AWS Bedrock Guardrails, content filters, denied topics, and PII redaction. Google Model Armor, prompt and response screening. OpenAI moderation endpoint, free, for harm categories.
- Orchestration, not detectors: NVIDIA NeMo Guardrails, programmable rails in Colang, input, output, dialog, retrieval, and execution rails, delegates detection to plugins. Guardrails AI, structured output validation. These are plumbing that calls detectors. Their out of the box checks are weaker than a dedicated classifier. Use them to wire the stack together, not as the detector itself.
- Enterprise AI security platforms: Palo Alto Prisma AIRS, formerly Protect AI, runtime guardrails with red teaming and model supply chain scanning. Cisco AI Defense, formerly Robust Intelligence, pre deploy model evaluation and runtime DLP. Check Point Lakera, formerly Lakera, prompt injection detection and red teaming. HiddenLayer, model file and supply chain security, scans model files across 35 plus formats for backdoors and serialization exploits. WitnessAI, Pillar Security, SplxAI, Aim Security, Lasso Security, and Enkrypt AI, AI firewalls and runtime security. Reach for a commercial platform only when you need red teaming, model file scanning, shadow AI discovery, and SIEM integration, not just classifier accuracy.
- Model supply chain: HiddenLayer, Protect AI Guardian, now Palo Alto, and ModelScan or PickleScan, for scanning model files. Ban pickle. Use SafeTensors only. Sandbox and network isolate every MCP server.
- Red teaming and evaluation: Garak, NVIDIA, automated LLM vulnerability scanner. PyRIT, Microsoft, automated red team framework. Promptfoo, now part of OpenAI as of March 2026, prompt evaluation and red teaming. Giskard, and Burp Suite AI Extension. Use these before production, not after an incident.
- PII and DLP: Microsoft Presidio, PII detection and anonymization library. Microsoft Purview, PII and PHI classification, DLP on outputs, lineage, and policy. Nightfall, Cyberhaven, and MIND, DLP for AI traffic.
- SIEM and SOAR: Splunk, Microsoft Sentinel, and Defender for AI, which detects prompt injection including ASCII smuggling, credential theft, and anomalous tool usage. Send prompt, response, tool call, and guardrail logs to your SIEM. Build the detections in Part 3 there.

Note on consolidation, as of 2026: Protect AI is now Palo Alto Prisma AIRS. Lakera is part of Check Point. Robust Intelligence is Cisco AI Defense. Prompt Security is part of SentinelOne. CalypsoAI was bought by F5. LLM Guard, the open source project from Protect AI, was archived in July 2026. Check the vendor before you build on a tool, and do not build your only control on an archived project.

### Mitigation, what to do when a filter is wrong

- False positive: the filter blocks a legitimate user. Do not just allowlist the user. Log the case, send it to human review, and write the standard for it. If false positives happen often, users learn to work around the filter, which makes the system less safe.
- False negative: the filter lets an attack through. Do not just block the one prompt. Check whether the same technique worked before, check the conversation, and check whether the guardrail score was close to the threshold. Add the case to the blind sample set.
- The Principal answer: label the borderline cases, send them to a human, and measure the agreement rate on those cases. That is calibration, applied to LLM filtering.

## Part 5: Protection, architecture and supply chain

### Secure the model, the data, and the agent, in that order

1. Model: know which model, which version, and which weights you are running. Scan model files before you load them. Use SafeTensors only. Do not load a model file from an untrusted source without scanning it. Log the model hash with every output, so you can reproduce it.
2. Data: know which data trained it, which data fine tuned it, and which data is in your RAG index. Validate provenance. Version your datasets and your embedding index. If you cannot say which data version produced an output, you cannot investigate it.
3. RAG: enforce access control on the vector store, per tenant and per user. Scan documents before indexing. Log what was retrieved. Test for cross tenant leakage, by asking for another tenant's data and seeing whether the model returns it.
4. Agent: give the agent the smallest set of tools it needs. Human gate state changing actions. Log every tool call. Test for excessive agency, by asking the agent to do something outside its task and seeing whether it refuses.
5. MCP servers: sandbox and network isolate every MCP server. Treat an MCP server as untrusted code, because it is. Log what it returned, and check whether the model treated it as instructions.
6. Identity: use Entra ID or IAM for humans and for agents. Do not use a shared service principal secret for an agent. Use a per agent identity, with a per agent permission set.
7. Network: private endpoints, VNet integration, and no public exposure for model endpoints. Egress rules on what the model and its tools can reach.
8. Cost: rate limits, token limits, and cost alerts, per user and per session. Unbounded consumption is a denial of service and a model extraction vector.

### Governance, what auditors ask for

NIST AI Risk Management Framework, ISO and IEC 42001, and SOC 2 are the three artifacts enterprise buyers request. They answer different questions. NIST AI RMF is risk management. ISO 42001 is management system. SOC 2 is controls. The EU AI Act is the forcing function in Europe, with high risk obligations pushed to December 2027 and August 2028 under the AI Omnibus that entered into force in July 2026. You do not need to be a lawyer to hunt AI threats, but you need to know which framework your organization claims to follow, and what evidence it expects you to produce.

## Part 6: IR handbook, incident response for AI

Use your normal IR phases, with AI specific steps added. Do not invent a new IR process. Adapt the one you have.

### Severity, use this scale

- Sev 1: a model leaked secrets, PII, or internal data, or an agent took a state changing action the user never reviewed, such as sending data out, changing a record, or running code. Contain first, investigate second.
- Sev 2: a prompt injection or jailbreak worked, but no data left the system and no tool was abused. Contain the user or the session, preserve the logs, and investigate.
- Sev 3: a guardrail fired, a filter blocked a prompt, or a suspicious pattern was detected, with no confirmed impact. Investigate, label, and add to the calibration set.
- Sev 4: a policy question, a borderline case, or a false positive. Send to human review, write the standard, and measure it.

### Triage, the first 15 minutes

1. What model, what version, what user, what session, what time? Get the conversation ID.
2. What was the prompt, what was retrieved, what did the model return, and what tools did it call? Pull the full conversation, not just the flagged turn.
3. What left the system? Check egress, tool calls, and the outbound response. If nothing left, say so, and say how you know.
4. Is it still happening? If yes, contain the session, the user, or the tool, in that order.
5. Preserve the logs. Prompt, response, retrieval, tool call, guardrail, identity, and cost logs, for the full session. Do not let them roll off while you investigate.

### Containment, eradication, and recovery, AI specific

- Containment: disable the user or API key, revoke the session, disable the tool, or disable the agent, in that order. Do not just block the one prompt. Block the pattern.
- Eradication: remove the poisoned document from the RAG index, revoke the compromised MCP server, rotate the leaked secret, and fix the guardrail that missed it. If the model itself is poisoned, do not try to unpoison it in production. Roll back to a known good model and dataset version.
- Recovery: re enable the user, the tool, or the agent, only after the filter is tested. Test it with the same technique that worked, and with three variations. If it still works, do not re enable it.
- Lessons learned: write the detection that would have caught it earlier, add the case to the blind sample set, and update the playbook. If you do not update the playbook, the next analyst will make the same mistake.

### Runbooks, work these step by step

#### Runbook 1: Prompt injection, direct

Signal: a user prompt contains "ignore prior instructions" or similar, and the model follows it.
1. Pull the full conversation. Check whether the model followed the instruction, or refused it.
2. Check the guardrail log. Did it fire? What was the score? Was it close to the threshold?
3. Check what the model did. Did it leak instructions, leak data, or call a tool?
4. Contain the session if it is still active. Label the case, with confidence, and write the rationale.
5. Add the case to the blind sample set. Update the inbound filter with the technique, not just the string.

#### Runbook 2: Prompt injection, indirect, EchoLeak style

Signal: a model leaks internal data after reading an email, a web page, or a document.
1. Pull the retrieved content. Find the hidden instruction. Quote it in your notes.
2. Check who could edit that content. Check the document version and the access control.
3. Check what the model leaked, and to whom. Check egress and the outbound response.
4. Contain the document. Remove it from the RAG index, or fix the access control, and revoke any leaked secret.
5. This is a Sev 1 if data left the system. Treat it as a data breach investigation, not just a prompt issue.

#### Runbook 3: Jailbreak, multi turn

Signal: the same user, across turns, reframing a disallowed request.
1. Pull the full conversation. Look at the pattern, not one prompt. The pattern is the signal.
2. Check whether the bypass worked, and what the model produced.
3. Check whether the same technique worked before, for this user or for others.
4. Label the case, with confidence, and write the rationale. Add it to the blind sample set.
5. Update the outbound filter with the technique, and test it with three variations.

#### Runbook 4: Sensitive information disclosure, data leak

Signal: a model output contains secrets, PII, or internal data.
1. Identify the data. Is it a secret, PII, or internal data? Where did it come from, training, retrieval, or the conversation?
2. Check who received it, and whether it left the system. Check egress.
3. Rotate the secret if it is a credential. Notify the data owner if it is PII or internal data.
4. Check whether the guardrail fired. If it did not, that is a separate finding.
5. This is a Sev 1 if the data left the system. Preserve the logs and start a breach timeline.

#### Runbook 5: System prompt leakage

Signal: a user asks the model to repeat, summarize, or format its instructions.
1. Pull the full conversation. Check what leaked, verbatim.
2. Check what was in the system prompt that should never have been there. Remove secrets, API keys, and internal URLs from the system prompt. Move them to a secure store, and enforce them in code, not in the prompt.
3. Check whether the leaked prompt reveals security logic that an attacker can now bypass.
4. Label the case, and add it to the blind sample set.

#### Runbook 6: RAG poisoning

Signal: a newly indexed document contains instruction language, or the model starts following a new document.
1. Pull the document version. Check who edited it, and when.
2. Check the embedding index version. Check whether the document was indexed with the right access control.
3. Check whether the model followed the instruction, and what it did.
4. Remove the document from the index. Fix the access control. Rebuild the index if needed.
5. Check whether other documents from the same author or the same source are poisoned.

#### Runbook 7: Agent tool abuse, excessive agency

Signal: an agent calls a tool it does not need, or calls a tool with arguments the user never reviewed.
1. Pull the tool call log. List every tool, every argument, and every return value, for the session.
2. Check what the tool did. Did it read a file, change a record, send email, or run code? Did a human approve it?
3. Contain the agent. Disable the tool, or revoke the agent's permission for that tool.
4. Check whether the tool call was the result of a prompt injection. Pull the prompt and the retrieved content that led to it.
5. This is a Sev 1 if a state changing action happened without human approval. Preserve the logs and start a timeline.

#### Runbook 8: Unbounded consumption and model extraction

Signal: tokens per user spike, or a single user queries the model thousands of times.
1. Pull the usage and cost logs. Check the query pattern, grouped by user and API key.
2. Check whether the queries are systematic variations, which suggests extraction, or just heavy use.
3. Rate limit the user or API key. Check whether a limit was in place, and why it did not fire.
4. Check the cost. Report it, with a number, not a guess.

## Part 7: Teaching a junior analyst, 30, 60, and 90 days

### Day 1 to 30: Learn the pipeline

Week 1: Read Part 1 and Part 2. Learn the OWASP LLM Top 10, in order, with one example for each. Learn the EchoLeak case.
Week 2: Learn the telemetry. Pull a prompt log, a response log, a tool call log, and a guardrail log, for one session, and trace the conversation end to end. Write down what you see, in your own words.
Week 3: Learn the filters. Run a prompt through Llama Guard or Azure AI Content Safety, and see what score it gets. Run a jailbreak through it, and see whether it fires. Write down what worked and what did not.
Week 4: Work a Sev 3 case, with a senior watching. Use Runbook 1 or Runbook 3. Write the label and the rationale, and have the senior review it.

Exercise for the senior: give the junior a flagged prompt, with no context, and ask them to label it. Then give them the full conversation, and ask them to label it again. The difference is the lesson. Context changes the call.

### Day 31 to 60: Hunt and adjudicate

Week 5 and 6: Run one hunt from Part 3, H1 through H6, with a senior watching. Write the hypothesis, the query, the result, and the conclusion. If the hunt finds nothing, write that down too. A hunt with no findings is still a finding, if you can say what you checked and what you did not check.
Week 7: Work a Sev 2 case, with a senior watching. Use Runbook 2 or Runbook 7. Write the timeline, the evidence for and against, and the decision.
Week 8: Do a blind labeling exercise. Label 20 cases without seeing another investigator's call. Compare your labels to theirs. Discuss the disagreements, and write the standard for the disputed category.

Exercise for the senior: give the junior a case where two senior investigators disagree. Ask them to decide, and to write the rationale and the dissent. The point is not to be right. The point is to defend a call on partial data, in writing.

### Day 61 to 90: Lead a case, and teach it back

Week 9 and 10: Lead a Sev 2 or Sev 3 case, end to end, with a senior reviewing, not directing. Triage, containment, investigation, and recovery. Write the report.
Week 11: Build a detection. Pick one rule from Part 3, write it in Splunk or Sentinel, backtest it 60 to 90 days, measure precision and recall, and deploy it in informational mode first.
Week 12: Teach it back. The junior teaches a new analyst one runbook, from Part 6, out loud, with a worked example. If they cannot teach it, they do not know it yet.

### Glossary, for a junior analyst

- Frontier model: a state of the art large language model, such as Claude, GPT, Gemini, Grok, or Llama, with broad capabilities and broad risk.
- Prompt injection: crafted input that changes what a model does, direct from the user, or indirect, hidden in content the model reads.
- Jailbreak: a prompt designed to make a model ignore its safety rules, by role play, encoding, or splitting a request across turns.
- Guardrail: a classifier or filter that scores prompts and responses for harm, injection, jailbreak, PII, or disallowed content, and blocks or flags them.
- RAG: Retrieval Augmented Generation. A system that retrieves documents from an index and inserts them into the prompt, so the model can answer with context. RAG documents are untrusted input.
- MCP: Model Context Protocol. A protocol for connecting a model to tools and data sources. Treat every MCP server as untrusted code.
- Excessive agency: a model with more tools, permissions, or autonomy than it needs for the task.
- Calibration: a routine where investigators label the same sample set blind, discuss disagreements, and write a standard, so labels stay consistent.
- Inter rater consistency: the agreement rate between investigators labeling the same cases. If it is low, the classifier learns noise.
- Backtesting: running a new detection against 60 to 90 days of historical data, to measure precision and recall before deploying it.
- Precision: of the cases a detection fired on, how many were real. Recall: of the real cases, how many did the detection catch. A detection with high precision and low recall misses cases. A detection with low precision and high recall floods responders.

### Checklists, print these

#### Before you ship a model or an agent
- Identity and access are set, with short lived tokens, not long lived API keys.
- Inbound and outbound filters are on, with scores logged, not just verdicts.
- Retrieval is logged, with access control per tenant and per user.
- Tool permissions are per agent, per task, with human approval on state changing actions.
- Output is validated before it touches another system.
- Rate limits, token limits, and cost alerts are on.
- Model, dataset, and index versions are logged with every output.
- A human can review a flagged case, and the review is logged.

#### Before you close an AI incident
- You have the full conversation, not just the flagged turn.
- You know what left the system, and how you know.
- You have preserved the prompt, response, retrieval, tool call, guardrail, identity, and cost logs.
- You have labeled the case, with confidence, and written the rationale.
- You have added the case to the blind sample set.
- You have updated the detection, the filter, or the playbook, with a test that proves it works.

## Sources and further reading

- OWASP Top 10 for LLM Applications, 2025, genai.owasp.org. The map used in Part 2.
- NIST AI Risk Management Framework, and NIST AI 100-2, adversarial machine learning taxonomy.
- UK NCSC guidance on prompt injection, December 2025. Prompt injection may never be totally mitigated, design to limit the damage.
- EchoLeak, CVE-2025-32711, Aim Security, Microsoft 365 Copilot, fixed June 2025. The textbook indirect injection case.
- Microsoft Azure AI Foundry, Azure AI Content Safety, Prompt Shield, Defender for AI, and Purview for AI. The Microsoft stack in Part 4.
- AWS Bedrock Guardrails, and Google Model Armor. The cloud guardrail alternatives.
- NVIDIA NeMo Guardrails, Garak, and PyRIT. The open source orchestration, scanning, and red teaming tools.
- Llama Guard, Prompt Guard, Granite Guardian, and ShieldGemma. Self hosted classifier models.
- Lakera Guard, HiddenLayer, Palo Alto Prisma AIRS, Cisco AI Defense, and Check Point Lakera. The enterprise AI security platforms in Part 4.

## Version note

This playbook is a living document. Update it after every Sev 1 and Sev 2 incident, and after every red team exercise. If a detection, a filter, or a runbook in here did not work, fix it in the file, and note what changed and why. A playbook that does not change after an incident is a playbook that was not used.
