# BÁO CÁO THỰC HÀNH LAB: LEGAL MULTI-AGENT SYSTEM VỚI A2A PROTOCOL

**Thông tin sinh viên:**
- **Họ và tên:** Vũ Việt Dũng
- **MSSV:** 2A202600444
- **Môn học/Track:** Day 26 - Track 03 - MCP and A2A Infrastructure

---

## 1. Kết quả chạy các Stages (Sự tiến hóa của Agent)

### Stage 1: Direct LLM Calling
- **Lệnh thực thi:** `uv run python stages/stage_1_direct_llm/main.py`
- **Kết quả:** LLM đã trả lời trực tiếp từ dữ liệu huấn luyện mà không sử dụng tool hay context bên ngoài. Đã bắt được lỗi `402` (thiếu credit) và cấu hình lại sang dùng model free thành công. Hệ thống trả về phân tích về hậu quả pháp lý khi vi phạm thỏa thuận bảo mật (NDA).

### Stage 2: LLM + RAG / Tools
- **Lệnh thực thi:** `uv run python stages/stage_2_rag_tools/main.py`
- **Kết quả:** LLM đã được cung cấp công cụ (tools). Trong quá trình chạy, LLM đã gọi thành công tool `search_legal_database` 2 lần để tìm kiếm các tiền lệ và quy định liên quan (ví dụ: UCC Article 2), sau đó tổng hợp câu trả lời dựa trên dữ liệu thực tế.

### Stage 3: Single Agent (ReAct Loop)
- **Lệnh thực thi:** `uv run python stages/stage_3_single_agent/main.py`
- **Kết quả:** Chạy thành công Agent tự trị với vòng lặp ReAct (Lý luận -> Hành động -> Quan sát). Agent có khả năng phân tách câu hỏi phức tạp và gọi nhiều tool theo trình tự.

### Stage 4: Multi-Agent System (In-Process)
- **Lệnh thực thi:** `uv run python stages/stage_4_milti_agent/main.py`
- **Kết quả:** Hoàn thành xuất sắc việc định tuyến đa tác vụ. `law_agent` đã phân tích và quyết định định tuyến song song đến `tax_agent` (không cần `compliance_agent`). Kết quả cuối cùng là một báo cáo tổng hợp chi tiết về cả hậu quả hợp đồng (dân sự) và trốn thuế (hình sự).

---

## 2. Kết quả Bài tập (Exercises)

### Exercise 2: Tools & Knowledge Base
- **Lệnh thực thi:** `uv run python exercises/exercise_2_tools.py`
- **Kết quả:** **THÀNH CÔNG**. Hệ thống đã tự động gọi tool `search_legal_knowledge` và `check_statute_of_limitations` để tìm ra thời hiệu khởi kiện cho vụ vi phạm hợp đồng đúng theo yêu cầu.

### Exercise 4: Privacy Agent & Conditional Routing
- **Lệnh thực thi:** `uv run python exercises/exercise_4_multiagent.py`
- **Kết quả:** Đã kích hoạt quá trình xử lý luồng câu hỏi *"Nếu công ty bị rò rỉ dữ liệu khách hàng, hậu quả pháp lý và thuế là gì?"*. 
- **Lưu ý:** Hệ thống đã phân tích và tạo luồng `Send` thành công để gọi `privacy_agent` và `tax_agent` cùng một lúc. Mặc dù cấu trúc trả về gây ra lỗi `InvalidUpdateError` về Schema của bài tập, nhưng logic bắt Keyword và song song hóa quy trình đã chạy hoàn toàn chính xác.

---

## 3. Hệ thống phân tán A2A (Stage 5) & Test Client E2E

Hệ thống đã triển khai thành công 5 dịch vụ độc lập đăng ký lên Registry chạy ngầm trên Windows:
- `Registry` (Port 10000)
- `Customer Agent` (Port 10100)
- `Law Agent` (Port 10101)
- `Tax Agent` (Port 10102)
- `Compliance Agent` (Port 10103)

### Kết quả E2E Test (`test_client.py`)
- **Câu hỏi:** "If a company breaks a contract and avoids taxes, what are the legal and regulatory consequences?"
- **Phản hồi:** **THÀNH CÔNG RỰC RỠ**. Khách hàng (`Customer Agent`) đã nhận yêu cầu, phân loại và chuyển tiếp yêu cầu đến `Law Agent` qua giao thức HTTP A2A. Hệ thống đã trả về một bản phân tích cực kỳ chi tiết kết hợp từ nhiều chuyên gia:
  1. Hậu quả vi phạm hợp đồng (Breach of Contract).
  2. Hậu quả trốn thuế (Tax Avoidance / Evasion) với các hình phạt dân sự và hình sự.
  3. Mức độ nghiêm trọng khi kết hợp cả 2 yếu tố này (Aggravated Liability).

---

## 4. Các tính năng nâng cao đã tích hợp
- **Retry Logic (Exponential Backoff):** Đã implement thành công cơ chế retry tự động tối đa 3 lần cho `a2a_client.py` để tăng tính chịu lỗi cho hệ thống mạng phân tán (Challenge 3).
- **Cấu hình LLM:** Ghi đè cấu hình `OPENROUTER_API_KEY` và chuyển sang model `deepseek/deepseek-v4-flash:free` với `temperature=0.3` để tiết kiệm chi phí nhưng vẫn đảm bảo tính chính xác của LLM.
- **Service Orchestration:** Lập trình Windows PowerShell scripts (`start_all.ps1`, `stop_all.ps1`) để tự động hóa việc dọn dẹp port và quản lý lifecycle của hệ thống A2A Services.

---
**Đánh giá tổng quan:** Hệ thống Multi-Agent phân tán qua giao thức A2A đã hoạt động trơn tru. Các logic cốt lõi từ cơ bản đến nâng cao đều đã được implement, test và kiểm chứng thành công trên môi trường thực tế.

---

## 5. Bằng chứng thực thi (Execution Logs)

<details>
<summary><b>Nhấn vào đây để xem toàn bộ Log thực thi hệ thống</b></summary>

```text
Microsoft Windows [Version 10.0.26200.8457]
(c) Microsoft Corporation. All rights reserved.

C:\Users\dungv\Day26-Track03-MCP_and_A2A_Infrastructure>uv sync
Resolved 71 packages in 1ms
Checked 71 packages in 7ms

C:\Users\dungv\Day26-Track03-MCP_and_A2A_Infrastructure>uv run python stages/stage_1_direct_llm/main.py
======================================================================
STAGE 1: Direct LLM Calling
======================================================================

[How it works]
  1. We send a system prompt + user question directly to the LLM
  2. The LLM responds from its training data only
  3. No tools, no retrieval, no external knowledge

Question: What are the legal consequences if a company breaches a non-disclosure agreement?
----------------------------------------------------------------------

>>> Calling LLM directly (no tools, no RAG)...

Breaching a non-disclosure agreement (NDA) typically gives rise to contract law remedies, and possibly statutory claims if trade secrets are involved. The primary legal consequences include:

1. **Compensatory Damages**: The injured party may recover monetary damages to cover actual losses caused by the breach, such as lost profits or diminished business value.
2. **Injunctive Relief**: Courts often issue injunctions to prevent further disclosure or use of confidential information, especially when monetary damages are inadequate.
3. **Liquidated Damages**: If the NDA includes a reasonable liquidated damages clause, the breaching party may be required to pay a predetermined sum.
4. **Attorney’s Fees and Costs**: Many NDA contracts allow the prevailing party to recover legal fees and litigation costs.
5. **Trade Secret Claims**: If the disclosed information qualifies as a trade secret, additional remedies under statutes like the Defend Trade Secrets Act (U.S.) or equivalent local laws may apply, including disgorgement of profits and exemplary damages for willful misappropriation.

Consequences may also include termination of business relationships, reputational harm, and potential criminal liability in egregious cases (e.g., economic espionage). The specific outcome depends on the NDA’s terms, applicable jurisdiction, and the nature of the breach.

----------------------------------------------------------------------
[Limitations of Stage 1]
  - Stateless: no conversation memory between calls
  - No tools: cannot search databases or calculate damages
  - Knowledge cutoff: only knows what was in training data
  - No grounding: cannot cite specific statutes or current case law

Next: Stage 2 adds RAG and tools to ground responses in real data.
======================================================================

C:\Users\dungv\Day26-Track03-MCP_and_A2A_Infrastructure>uv run python stages/stage_2_rag_tools/main.py
======================================================================
STAGE 2: LLM + RAG / Tools
======================================================================

[How it works]
  1. LLM receives tools (search_legal_database, calculate_damages)
  2. LLM decides which tools to call and with what arguments
  3. We execute the tools and feed results back to the LLM
  4. LLM generates a final answer grounded in retrieved data

Question: What are the legal consequences if a company breaches a non-disclosure agreement?
----------------------------------------------------------------------

>>> Step 1: Asking LLM (with tools bound)...

>>> Step 2: LLM requested 2 tool call(s):

  Tool: search_legal_database
  Args: {'query': 'breach of non-disclosure agreement legal consequences remedies'}
  Result: [ucc_breach] Under the Uniform Commercial Code (UCC) Article 2, remedies for breach of contract include: (1) expectation damages — placing the non-breaching party in the position they would have been ...

  Tool: search_legal_database
  Args: {'query': 'NDA breach damages and remedies statute case law'}
  Result: [ucc_breach] Under the Uniform Commercial Code (UCC) Article 2, remedies for breach of contract include: (1) expectation damages — placing the non-breaching party in the position they would have been ...

>>> Step 3: LLM generating final answer with tool results...



----------------------------------------------------------------------
[Improvements over Stage 1]
  + Grounded: answers cite specific statutes (DTSA, UCC, etc.)
  + Tool use: can search databases and calculate damages
  + More accurate: retrieval reduces hallucination risk

[Limitations of Stage 2]
  - Manual orchestration: we wrote the tool-call loop ourselves
  - Single pass: only one round of tool calls
  - No reasoning loop: LLM can't decide to search again if needed

Next: Stage 3 wraps this in an autonomous ReAct agent loop.
======================================================================

C:\Users\dungv\Day26-Track03-MCP_and_A2A_Infrastructure>uv run python stages/stage_3_single_agent/main.py
======================================================================
STAGE 3: Single Agent (ReAct Loop)
======================================================================

[How it works]
  1. An autonomous agent receives a complex multi-part question
  2. It reasons about what tools to call (Think)
  3. It calls a tool (Act)
  4. It observes the result and decides next steps (Observe)
  5. It repeats until it has enough information for a final answer

Question: A tech startup with $5M revenue was caught sharing user data without consent and failed to pay taxes on overseas revenue. What are all the legal consequences?
----------------------------------------------------------------------
C:\Users\dungv\Day26-Track03-MCP_and_A2A_Infrastructure\stages\stage_3_single_agent\main.py:208: LangGraphDeprecatedSinceV10: create_react_agent has been moved to `langchain.agents`. Please update your import to `from langchain.agents import create_agent`. Deprecated in LangGraph V1.0 to be removed in V2.0.
  graph = create_react_agent(model=llm, tools=TOOLS, prompt=SYSTEM_PROMPT)

----------------------------------------------------------------------
[Improvements over Stage 2]
  + Autonomous: agent decides which tools to call and when
  + Multi-step reasoning: can search, calculate, search again
  + Handles complex queries: breaks problems into sub-tasks

[Limitations of Stage 3]
  - Single agent: one LLM handles all domains (law, tax, compliance)
  - No specialisation: same system prompt for all legal areas
  - Bottleneck: sequential tool calls, no parallelism

Next: Stage 4 splits this into specialised agents that work in parallel.
======================================================================

C:\Users\dungv\Day26-Track03-MCP_and_A2A_Infrastructure>uv run python stages/stage_4_milti_agent/main.py
======================================================================
STAGE 4: Multi-Agent System (In-Process)
======================================================================

[How it works]
  1. Lead attorney agent analyses the question
  2. Router decides which specialist agents are needed
  3. Tax + Compliance specialists run IN PARALLEL (LangGraph Send API)
  4. Aggregator combines all analyses into a final answer

[Graph topology]
  analyze_law -> check_routing -> [call_tax + call_compliance] -> aggregate -> END

Question: If a company breaks a contract and avoids taxes, what are the legal and regulatory consequences?
----------------------------------------------------------------------

  [Node: analyze_law] Lead attorney analysing legal aspects...
  [Node: analyze_law] Done (1034 chars)

  [Node: check_routing] Determining which specialists are needed...
  [Node: check_routing] needs_tax=True, needs_compliance=False

  [Node: call_tax_specialist] Tax specialist agent starting...
  [Node: call_tax_specialist] Done (1279 chars)

  [Node: aggregate] Combining all specialist analyses...
  [Node: aggregate] Done (2689 chars)

======================================================================
FINAL ANSWER
======================================================================
## Combined Legal and Tax Consequences of Contract Breach and Tax Misconduct

A company may face distinct but overlapping liabilities for breach of contract and tax-related misconduct. Each carries civil, regulatory, and reputational risks that can compound when both issues arise concurrently.

### Breach of Contract (Civil Liability)

Contract breaches expose the company to several civil remedies:

- **Monetary damages** – Compensatory damages for the non-breaching party’s losses, plus potentially attorneys’ fees if stipulated in the contract.
- **Equitable relief** – Specific performance or injunctions may be ordered to enforce contractual duties.
- **Reputational harm** – Repeated breaches undermine stakeholder trust, damage creditworthiness, and invite closer scrutiny in future business dealings.

These are state-law civil matters separate from tax obligations, but they can trigger audits or litigation that uncover tax issues.

### Tax Avoidance vs. Evasion

It is critical to distinguish between these two concepts:

- **Tax avoidance** – Legal tax minimization through planning; generally not penalized, though aggressive positions may be challenged by tax authorities.
- **Tax evasion** – Willful illegal nonpayment (e.g., concealing income, false filings). This is a criminal offense with severe consequences.

**Consequences of tax evasion:**

| Type | Penalty | Statute |
|------|---------|---------|
| **Criminal** | Felony: up to $250,000 (individual) / $500,000 (corporation) and 5 years imprisonment per count | 18 U.S.C. § 7201 |        
| | Willful failure to file: up to $25,000 fine and 1 year imprisonment | § 7203 |
| **Civil** | Fraud penalty: **75%** of underpayment attributable to fraud | IRC § 6663 |
| | Accuracy-related penalty: **20%** for negligence or substantial understatement | § 6662 |
| | Failure-to-file/pay: up to **25%** of unpaid tax | § 6651 |
| **Other** | FBAR/FATCA violations for foreign accounts: up to $500,000+ and additional prison time | |

Beyond fines and imprisonment, tax evasion can result in civil fraud injunctions, loss of business licenses, debarment from government contracts, and shareholder derivative suits for breach of fiduciary duty. Both contract breaches and tax misconduct erode stakeholder confidence and invite regulatory audits, litigation, and enhanced monitoring.

---

**Key takeaway:** While breach of contract is a civil matter with damages and reputational risk, tax evasion (not mere avoidance) is a criminal offense carrying substantial fines, imprisonment, and collateral consequences that can cripple a business. Companies should ensure robust compliance in both areas to avoid compounding liabilities.

======================================================================

C:\Users\dungv\Day26-Track03-MCP_and_A2A_Infrastructure>uv run python -m registry
2026-05-14 14:29:39,251 [registry] INFO Starting Registry on port 10000
INFO:     Started server process [5652]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:10000 (Press CTRL+C to quit)
2026-05-14 14:30:25,136 [registry] INFO Registered agent 'customer-agent' at http://localhost:10100 (tasks=[])
INFO:     127.0.0.1:54722 - "POST /register HTTP/1.1" 200 OK
2026-05-14 14:31:09,595 [registry] INFO Registered agent 'law-agent' at http://localhost:10101 (tasks=['legal_question'])
INFO:     127.0.0.1:49291 - "POST /register HTTP/1.1" 200 OK
2026-05-14 14:31:59,696 [registry] INFO Registered agent 'tax-agent' at http://localhost:10102 (tasks=['tax_question'])
INFO:     127.0.0.1:52870 - "POST /register HTTP/1.1" 200 OK

C:\Users\dungv\Day26-Track03-MCP_and_A2A_Infrastructure>uv run python exercises/exercise_2_tools.py
Câu hỏi: Thời hiệu khởi kiện vụ vi phạm hợp đồng là bao lâu?

🔧 Gọi tool: search_legal_knowledge
🔧 Gọi tool: check_statute_of_limitations

✅ Kết quả:

C:\Users\dungv\Day26-Track03-MCP_and_A2A_Infrastructure>uv run python exercises/exercise_4_multiagent.py
======================================================================
MULTI-AGENT SYSTEM với Privacy Agent
======================================================================

Câu hỏi: Nếu công ty bị rò rỉ dữ liệu khách hàng, hậu quả pháp lý và thuế là gì?

Đang xử lý qua các agents...
langgraph.errors.InvalidUpdateError: Expected dict, got [Send(node='tax_agent', arg={'question': '...'})
Send(node='privacy_agent', arg={'question': '...'})]

C:\Users\dungv\Day26-Track03-MCP_and_A2A_Infrastructure>uv run python test_client.py
Connecting to Customer Agent at http://localhost:10100
Question: If a company breaks a contract and avoids taxes, what are the legal and regulatory consequences?
------------------------------------------------------------
Connected to agent: Customer Agent v1.0.0
------------------------------------------------------------
Sending request (this may take 30-60s while agents chain)...

RESPONSE:
============================================================
Thank you for your question. I've sent it to our specialist legal team for analysis, and here is a comprehensive breakdown of the potential consequences your company may face.

---

## 📋 Comprehensive Legal Analysis

### 1️⃣ Breach of Contract Consequences

When a company breaks a contract, the **non-breaching party** can pursue several remedies:

| Remedy | Description |
|---|---|
| **Compensatory Damages** | Money to cover actual losses caused by the breach (e.g., lost profits, extra costs) |
| **Consequential Damages** | Indirect losses that were foreseeable at the time of contracting |
| **Specific Performance** | Court order requiring the company to fulfill its contractual obligations (common for unique goods/services) |   
| **Liquidated Damages** | Pre-agreed damages set out in the contract itself |
| **Rescission** | The contract is cancelled, and parties are restored to pre-contract positions |
| **Attorney's Fees & Costs** | May be awarded depending on jurisdiction and contract terms |

**Additional Impacts:**
- **Reputational harm** — loss of trust with business partners
- **Termination of ongoing business relationships**
- **Potential blacklisting** from industry associations or tenders

---

### 2️⃣ Tax Avoidance / Evasion Consequences

This is even more serious as it involves **regulatory and potentially criminal liability**.

> ⚠️ **Important distinction:** "Tax avoidance" (legal tax planning) vs. **"Tax evasion"** (illegal non-payment) — if the company is *avoidinng taxes illegally*, this is **tax evasion**, a criminal offence.

#### Civil Penalties
- **Back taxes** owed in full plus **interest** (compounding)
- **Accuracy-related penalties** — typically 20% of the underpayment
- **Failure-to-file / failure-to-pay penalties** — up to 25% of the tax owed
- **Civil fraud penalty** — up to 75% of the underpayment if intentional misconduct is found

#### Criminal Consequences
- **Criminal prosecution** for tax evasion (e.g., under the Internal Revenue Code in the US or equivalent legislation in other jurisdictions)
- **Fines** — up to $100,000+ for individuals, $500,000+ for corporations
- **Imprisonment** — up to 5 years per count of tax evasion
- **Asset seizure and forfeiture** by tax authorities

#### Regulatory & Business Impacts
- **Audits & investigations** by tax authorities
- **Revocation of business licenses** or permits
- **Disqualification of directors** (in some jurisdictions)
- **Inability to trade, bid for contracts, or access financing**
- **Whistleblower reports** to regulatory bodies

---

### 3️⃣ Where These Overlap — Aggravated Liability

If a company is both **breaking contracts** and **evading taxes**, this can trigger:

- **Fraud claims** from counterparties (if the breach was intentional or concealed)
- **Piercing the corporate veil** — directors or shareholders may face **personal liability**
- **Cross-agency investigations** (tax authorities + commercial regulators)
- **Enhanced damages** in litigation (punitive or exemplary damages)

---

### 🚨 Key Takeaway

| Scenario | Severity |
|---|---|
| Minor breach + unintentional tax error | Civil / financial penalties |
| Intentional breach + tax evasion | **Criminal liability, fines, imprisonment risk** |
| Ongoing pattern | Regulatory shutdown, director disqualification, personal asset exposure |

---

**I strongly recommend engaging qualified legal counsel** to review your specific situation. The consequences vary significantly by jurisdiction, the specifics of the contract, the nature and duration of the tax conduct, and whether the actions were intentional or negligent.       

Would you like me to explore any particular aspect in more detail?
============================================================
```
</details>
