<!-- Based on 6 November 2026 report. Historic observations are not current verification. -->

# 12. Future Enhancement: AI-Assisted SOC
## 12.1 Future-phase objective and honest scope
The planned AI phase aims to support a junior SOC analyst by translating raw Wazuh alerts into concise explanations,
identifying missing evidence, suggesting next investigation steps and optionally assigning triage priority. Airia was
named in an early implementation guide, but its API, execution agent, integration helper, token handling and Grafana
enrichment have not been verified as deployed in this home lab.

## 12.2 Proposed data flow
    Step   Future workflow   Security condition
    1   Wazuh creates a real alert and stores it in the Indexer.   Preserve original event ID/time/source.
   Minimize usernames, paths and other
    2   A read-only integration collects a bounded alert payload.
   sensitive fields.
   The integration enriches evidence with rule information and supporting   Avoid invented MITRE mappings or missing
    3
   event context.   indicators.
   An AI assistant outputs a human-readable summary, uncertainty and   Treat log text as untrusted input; prevent
    4
   suggested investigative checks.   prompt injection.
   No unsupervised containment, deletion or
    5   An analyst reviews, corrects and classifies the output.
   public disclosure.
   Approved assessment is displayed in a separate dashboard panel and   Clearly distinguish raw detections from AI
    6
   audited.   interpretation.


## 12.3 Proposed evaluation metrics
- Factual consistency with the source event and rule metadata.
- False-positive handling: the assistant must acknowledge benign possibilities when evidence is incomplete.
- Correct use of “unknown” or “insufficient evidence” instead of hallucinating an attack chain.
- Prompt-injection resilience when file paths, process arguments and alert descriptions include adversarial text.
- Human-review agreement rate, triage time, inference latency and per-alert cost.
    FUTURE PROJECT ONLY Do not describe AI alerts, AI scores or Airia-generated incident summaries as measured
    project results until the connector, test dataset and analyst evaluation are actually implemented.
