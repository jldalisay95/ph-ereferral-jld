# v0.1 Referral Workflow Narrative and State Model

## Purpose and Scope

This page is informative implementation guidance for the v0.1 draft.

This page describes the minimum viable referral workflow for PH eReferral v0.1. It is intended for early implementation, validation, and connectathon-style testing so that implementers can exercise a shared baseline workflow while the broader clinical, operational, and policy decisions continue to mature.

This workflow is not a production policy implementation unless it is formally endorsed by the appropriate clinical, technical, and program owners. It is a testable implementation narrative for the current IG draft.

The minimum path on this page is separated from policy and background material. The workflow tables below are the concrete path expected to be usable for v0.1 authoring and testing; the policy references explain the context and should not, by themselves, be treated as additional v0.1 test steps.

For v0.1, the workflow focuses on:

- creating a referral request from an initiating facility;
- sending the referral request to an intended receiving facility or service;
- tracking that referral through receipt, review, outcome, and closure;
- demonstrating the workflow with the current [EReferral ServiceRequest](StructureDefinition-ereferral-service-request.html), [EReferral Task](StructureDefinition-ereferral-task.html), and example resources.

The following topics are deferred or not fully resolved in this v0.1 workflow narrative:

- non-response and service-level agreement handling;
- full attachment and security handling;
- final facility and network identification rules;
- back-referral as a required end-to-end workflow.

## Policy and Narrative Basis

This workflow is grounded in the same national policy context summarized on the [WHO SMART Guidelines L1 Basis](who-smart-l1.html) page:

- [DOH Administrative Order No. 2020-0019](https://drive.google.com/file/d/1Uri9Iov3YPw3rc3AidV6dXjv8y_W7ydr/view), *Guidelines on the Service Delivery Design of Health Care Provider Networks*, describes the HCPN context in which referral coordination and service delivery operate.
- [DOH Administrative Order No. 2020-0024](https://law.upd.edu.ph/wp-content/uploads/2020/06/DOH-AO-No-2020-0024.pdf), *Primary Care Policy Framework and Sectoral Strategies*, clarifies the primary care role as navigator, coordinator, and continuing point of contact, and emphasizes continuity and coordination of care.
- [DOH Administrative Order No. 2020-0021](https://law.upd.edu.ph/wp-content/uploads/2020/05/DOH-AO-No_2020-0021.pdf), *Guidelines on Integration of the Local Health Systems into Province-wide and City-wide Health Systems (P/CWHS)*, situates HCPNs and PCPNs within integrated local health-system delivery and includes two-way referrals, patient navigation, records access, and digital technologies for health.

These references inform the workflow scope, especially the emphasis on coordinated care, patient navigation, and records exchange. The v0.1 workflow still remains a draft implementation path until formally endorsed.

## Minimum Viable Workflow Diagram

The following diagram reflects the latest minimum viable workflow discussed by the Clinical Design Group for the v0.1 baseline.

![Minimum viable referral workflow](minimum-viable-workflow.png)

The diagram uses the lanes `Initiator`, `Receiving Service`, and `Recipient`. The `Accept` and `Reject` labels shown in the decision point map to the v0.1 receiving-facility response terms resolved in [Issue #47](https://github.com/ph-ereferral-organization/ph-ereferral/issues/47) by [PR #84](https://github.com/ph-ereferral-organization/ph-ereferral/pull/84): `received`, `accepted`, `rejected`, and `referred-onward`. In this IG, `rejected` is limited to cases where the receiving facility cannot take the case and no onward facility is identified in the same response; capacity-full rerouting is represented as `referred-onward`.

## Actors and Systems

The minimum v0.1 workflow involves the following actors and systems.

| Actor or system | Minimum v0.1 role |
| --- | --- |
| Referring facility / initiating facility | Assesses the patient, creates the referral request, and sends it to a receiving facility or service. |
| Referring practitioner | Acts as the requester for the referral and provides the clinical reason and supporting information. |
| Receiving facility / receiving service | Receives and evaluates the referral, then records the receiving-facility outcome or update. |
| Recipient / receiving clinician or team | Performs clinical triage or clinical review after the receiving service has accepted or otherwise routed the referral for review. |
| Care navigator | May be assigned to coordinate the referral when the local workflow includes this role. In FHIR this may be represented through `ServiceRequest.performer` or `Task.owner`, depending on the implementation pattern. |
| Referral management system / FHIR server / exchange layer | Stores, exchanges, and updates the FHIR resources used to represent the referral request and workflow state. |

## Minimum Workflow Steps

| Step | Workflow activity | FHIR traceability |
| --- | --- | --- |
| 1 | Patient arrives and presents with a complaint or problem. | Patient demographics are represented by the patient resource referenced from `ServiceRequest.subject`. |
| 2 | Initiator assesses the patient condition and determines whether referral criteria are satisfied. | Relevant clinical context may be represented with supporting resources such as `Condition` and `Observation`, then referenced from `ServiceRequest.reasonReference` or `ServiceRequest.supportingInfo`. |
| 3 | If referral criteria are not satisfied, the minimum referral workflow ends. | No eReferral ServiceRequest is required for the v0.1 referral test path. |
| 4 | If referral criteria are satisfied, initiator discusses referral and next steps with the patient, including consent where applicable. | Consent capture is not fully profiled in v0.1. Any consent-related detail should be handled by local policy or a future profile decision. |
| 5 | Initiator creates the referral request and attaches clinical summary or notes. | Create an [EReferral ServiceRequest](StructureDefinition-ereferral-service-request.html) with `status`, `intent`, `subject`, `requester`, `performer`, `authoredOn`, `priority`, `reasonCode`, `reasonReference`, `supportingInfo`, and `note` as applicable. |
| 6 | Initiator reviews candidate receiving facilities and sends the referral. | `ServiceRequest.performer` identifies the intended receiving facility, service, practitioner role, or navigator pattern used by the implementation. |
| 7 | Receiving service receives, registers, or logs the referral and performs referral evaluation. | If workflow tracking is used, create or update an [EReferral Task](StructureDefinition-ereferral-task.html) with `Task.focus` referencing the ServiceRequest and `Task.status` representing the current workflow state. |
| 8 | Receiving service records the receiving-facility decision or outcome. | Record the receiving-facility outcome using the v0.1 receiving-response terminology: `received`, `accepted`, `rejected`, or `referred-onward`. Non-response is not represented in the current v0.1 examples. |
| 9 | If the referral can proceed, route for clinical triage or review by the recipient and send updates to the sender. | `Task.owner`, `Task.lastModified`, `Task.note`, and `Task.output` may be used to show assignment, updates, and resulting information. |
| 10 | Next steps after the referral decision are outside the v0.1 minimum path unless explicitly included in a test scenario. | Close the workflow when the referral outcome is known. In the current examples, closure is demonstrated with `Task.status = #completed`, `Task.executionPeriod.end`, and `Task.output`. |

## Request and Workflow Responsibilities

The v0.1 workflow follows the FHIR workflow pattern used by other ServiceRequest-based implementation guides: the request details are kept on `ServiceRequest`, while fulfilment and coordination state are tracked with `Task` when workflow tracking is needed.

| Resource or element | v0.1 responsibility |
| --- | --- |
| `ServiceRequest` | Represents the referral request: patient, requester, intended performer, requested service, priority, reason, and supporting clinical information. |
| `ServiceRequest.status` | Represents the initiating side's overall request lifecycle. In the current v0.1 examples, the referral request is `active` once it has been created and sent. |
| `Task` | Represents workflow tracking for the referral request, especially receipt, review, assignment, response/update, and closure. |
| `Task.focus` | References the `ERefServiceRequest` being tracked. |
| `Task.requester` | Identifies the initiating side that created or requested the workflow action. |
| `Task.owner` | Identifies the receiving facility, receiving practitioner role, care navigator, or organization currently responsible for acting on the referral task. |
| `Task.status` | Represents the current workflow state. Implementers should not assume that changing `Task.status` automatically changes `ServiceRequest.status`; any synchronization rule must be agreed by the implementation. |
| `Task.statusReason` | May carry human-readable or coded context for a status such as rejected, cancelled, on-hold, capacity full, or another non-happy-path state. |
| `Task.businessStatus` | Carries the v0.1 receiving-facility business response when `Task.status` is too broad. Current codes include `received`, `accepted`, `rejected`, and `referred-onward`. |
| `Task.output` | May carry the receiving-side update, result, or closure summary when the referral workflow outcome is known. |

## State Model

The table below describes the minimum state model for v0.1. Implementers should distinguish the request lifecycle on `ServiceRequest.status` from workflow coordination state on `Task.status` when Task is used.

| State | Meaning in v0.1 | Suggested FHIR representation | Expected transition |
| --- | --- | --- | --- |
| Draft / prepared referral | The referral is being prepared and has not yet been sent. | `ServiceRequest.status = #draft`; optionally `Task.status = #draft` if a Task is created before sending. | Moves to active / sent when the referral is ready for exchange. |
| Active or sent referral | The referral request has been created and sent or made available to the receiving side. | `ServiceRequest.status = #active`; current task examples use `Task.status = #requested`. | Moves to received / under review when the receiving side records receipt or starts review. |
| Received / under review | The receiving facility has received the referral and is reviewing whether it can take the case. | Current examples demonstrate `Task.status = #received` with `Task.businessStatus = EReferralWorkflowCS#received` in [Example eReferral Task - Received State](Task-ExampleERefTaskReceived.html). | Moves to accepted, referred onward, rejected, or another agreed outcome state. |
| Accepted / receiving facility can take the case | The receiving facility can take the case under the agreed workflow. | Current examples demonstrate `Task.status = #accepted` with `Task.businessStatus = EReferralWorkflowCS#accepted` in [Example eReferral Task - Accepted State](Task-ExampleERefTaskAccepted.html). | Moves toward transfer, service delivery, and eventual closure. |
| Redirected / referred elsewhere / capacity full | The receiving facility cannot take the case and directs the patient or referring facility to another facility or service. | Current examples demonstrate `Task.status = #rejected`, `Task.businessStatus = EReferralWorkflowCS#referred-onward`, `Task.statusReason = EReferralWorkflowCS#capacity-full`, and an onward referral output in [Example eReferral Task - Referred Onward State](Task-ExampleERefTaskReferredOnward.html). | Moves to the onward referral request or closure according to the agreed workflow. |
| Declined / rejected | A negative receiving-facility outcome where the receiving facility cannot take the case and no onward facility is identified in the same response. | Current examples demonstrate `Task.status = #rejected`, `Task.businessStatus = EReferralWorkflowCS#rejected`, and `Task.statusReason` in [Example eReferral Task - Rejected State](Task-ExampleERefTaskRejected.html). | Moves to closure or a new referral decision by the initiating side according to the agreed policy wording. |
| Closed / completed | The referral workflow outcome is known and no further v0.1 workflow action is expected. | `Task.status = #completed`; optionally align `ServiceRequest.status` with the final request lifecycle state used by the implementation. | Terminal state for the v0.1 workflow. |
| Not arrived / did not proceed | The patient did not proceed to the receiving service after referral. | Not defined as a required v0.1 state. Include only if explicitly added to the agreed scope. | Deferred unless adopted for v0.1 testing. |

## Referral Response Semantics

The receiving-facility response terminology for v0.1 was resolved through [Issue #47](https://github.com/ph-ereferral-organization/ph-ereferral/issues/47) and [PR #84](https://github.com/ph-ereferral-organization/ph-ereferral/pull/84). The current IG uses local workflow codes to represent the following receiving-facility responses:

| Response term | Meaning in v0.1 |
| --- | --- |
| `received` | The receiving facility has acknowledged receipt of the referral and is reviewing whether it can take the case. |
| `accepted` | The receiving facility can take the case and has given a positive transfer or service response. |
| `rejected` | The receiving facility cannot take the case and no onward receiving facility is identified in the same response. |
| `referred-onward` | The receiving facility cannot take the case and directs the patient or referral to another specified facility. |

The `capacity-full` code is used as supporting context, such as `Task.statusReason`, for a referred-onward response when the receiving facility reports that capacity is full. Non-response and service-level agreement handling remain out of scope for v0.1 until timing and escalation rules are formally defined. [Issue #41](https://github.com/ph-ereferral-organization/ph-ereferral/issues/41) remains open for Hypertensive Emergency Referral terminology sync.

## FHIR Artifact Traceability

The primary request resource is [EReferral ServiceRequest](StructureDefinition-ereferral-service-request.html). When workflow tracking is needed, [EReferral Task](StructureDefinition-ereferral-task.html) tracks state transitions and references the ServiceRequest through `Task.focus`.

Current official examples that demonstrate the v0.1 workflow pattern include:

- [Example eReferral Service Request](ServiceRequest-ExampleERefServiceRequest.html)
- [Example eReferral Task - Requested State](Task-ExampleERefTaskRequested.html)
- [Example eReferral Task - Received State](Task-ExampleERefTaskReceived.html)
- [Example eReferral Task - Accepted State](Task-ExampleERefTaskAccepted.html)
- [Example eReferral Task - Rejected State](Task-ExampleERefTaskRejected.html)
- [Example eReferral Task - Referred Onward State](Task-ExampleERefTaskReferredOnward.html)
- [Example eReferral Task - Completed State](Task-ExampleERefTaskCompleted.html)
- [Example Onward eReferral ServiceRequest](ServiceRequest-ExampleERefServiceRequestOnward.html)

The traceability table below is intentionally limited to current v0.1 examples and profiles. It should be updated if a later decision changes response terminology or if a separate referral-feedback artifact is introduced.

| Workflow information | Current example field(s) |
| --- | --- |
| Request status | `ServiceRequest.status`; `Task.status` when workflow tracking is used |
| Request intent | `ServiceRequest.intent`; `Task.intent` |
| Patient | `ServiceRequest.subject`; `Task.for` |
| Requester / referring side | `ServiceRequest.requester`; `Task.requester` |
| Receiving facility, practitioner, or navigator | `ServiceRequest.performer`; `Task.owner` |
| Supporting clinical information and notes | `ServiceRequest.reasonCode`, `ServiceRequest.reasonReference`, `ServiceRequest.supportingInfo`, and `ServiceRequest.note` |
| Response or update | `Task.status`, `Task.businessStatus`, `Task.statusReason`, `Task.note`, `Task.lastModified`, and, where applicable, `Task.output` |
| Closure | `Task.status = #completed`, `Task.executionPeriod.end`, and `Task.output` in the completed Task example |

## Known Limitations

This v0.1 workflow page intentionally documents unresolved areas rather than silently making them normative.

- Back-referral is not modeled as a required end-to-end workflow in this MVP page.
- Attachment and security handling are not fully resolved in the current workflow narrative.
- Facility and network identification rules are not finalized here. See [Issue #4](https://github.com/ph-ereferral-organization/ph-ereferral/issues/4) for the facility identification discussion.
- Transport behavior is not defined by this page; implementations may use a referral management system, FHIR server, or exchange layer pattern agreed for the test event.
- Receiving-facility response terms are defined for v0.1 testing, but production policy endorsement remains outside this informative page.
- Hypertensive Emergency Referral wording is pending terminology sync in [Issue #41](https://github.com/ph-ereferral-organization/ph-ereferral/issues/41).
- Consent, candidate receiving-facility selection rules, and the detailed post-decision recipient workflow are not fully specified in this v0.1 page.
- Non-response and SLA handling are deferred unless explicitly included by a later v0.1 decision.
- Implementers should not infer production policy requirements from this page without formal endorsement.
