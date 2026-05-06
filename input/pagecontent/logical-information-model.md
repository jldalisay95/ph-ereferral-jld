# v0.1 Referral Logical Information Model

## Purpose

This page describes the information that should be present in a v0.1 PH eReferral package before implementers think about FHIR resources or REST interactions. It explains the main information groups, the reason each group matters, and the PeReF profiles that currently carry the information.

The logical model is intentionally one level above the FHIR implementation. It answers "what information is needed for a safe referral handover?" The FHIR profiles and REST interactions answer "how is that information exchanged?"

## Model at a Glance

<svg xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="lim-title lim-desc" width="100%" viewBox="0 0 1100 520" preserveAspectRatio="xMidYMin meet">
  <title id="lim-title">PH eReferral logical information model</title>
  <desc id="lim-desc">Diagram showing patient identity, referral request, clinical reason, clinical context, prior care, sending context, receiving destination, workflow tracking, and audit as groups in the referral package.</desc>
  <defs>
    <style>
      .lim-box { fill: #f8fbff; stroke: #2f5f8f; stroke-width: 2; rx: 8; }
      .lim-core { fill: #edf7f0; stroke: #28724a; stroke-width: 2; rx: 8; }
      .lim-track { fill: #fff7e8; stroke: #9a6400; stroke-width: 2; rx: 8; }
      .lim-text { font-family: Arial, sans-serif; font-size: 20px; fill: #1b1f24; }
      .lim-small { font-family: Arial, sans-serif; font-size: 15px; fill: #1b1f24; }
      .lim-title { font-family: Arial, sans-serif; font-size: 24px; font-weight: 700; fill: #1b1f24; }
      .lim-line { stroke: #53616f; stroke-width: 2; marker-end: url(#arrow); }
    </style>
    <marker id="arrow" markerWidth="10" markerHeight="10" refX="8" refY="3" orient="auto" markerUnits="strokeWidth">
      <path d="M0,0 L0,6 L9,3 z" fill="#53616f"/>
    </marker>
  </defs>
  <text x="550" y="36" text-anchor="middle" class="lim-title">Referral package information groups</text>

  <rect x="405" y="72" width="290" height="112" class="lim-core"/>
  <text x="550" y="112" text-anchor="middle" class="lim-text">Referral request</text>
  <text x="550" y="140" text-anchor="middle" class="lim-small">Requested service, urgency, date</text>
  <text x="550" y="164" text-anchor="middle" class="lim-small">and requested destination</text>

  <rect x="80" y="92" width="250" height="88" class="lim-box"/>
  <text x="205" y="128" text-anchor="middle" class="lim-text">Patient identity</text>
  <text x="205" y="154" text-anchor="middle" class="lim-small">Who is being referred</text>

  <rect x="770" y="92" width="250" height="88" class="lim-box"/>
  <text x="895" y="128" text-anchor="middle" class="lim-text">Sending context</text>
  <text x="895" y="154" text-anchor="middle" class="lim-small">Who sent the referral</text>

  <rect x="80" y="238" width="250" height="104" class="lim-box"/>
  <text x="205" y="274" text-anchor="middle" class="lim-text">Clinical reason</text>
  <text x="205" y="300" text-anchor="middle" class="lim-small">Why referral is needed</text>
  <text x="205" y="324" text-anchor="middle" class="lim-small">and how urgent it is</text>

  <rect x="405" y="232" width="290" height="116" class="lim-box"/>
  <text x="550" y="268" text-anchor="middle" class="lim-text">Clinical context</text>
  <text x="550" y="294" text-anchor="middle" class="lim-small">Current condition, observations,</text>
  <text x="550" y="318" text-anchor="middle" class="lim-small">diagnostics, and prior care</text>

  <rect x="770" y="238" width="250" height="104" class="lim-box"/>
  <text x="895" y="274" text-anchor="middle" class="lim-text">Receiving context</text>
  <text x="895" y="300" text-anchor="middle" class="lim-small">Who should receive, triage,</text>
  <text x="895" y="324" text-anchor="middle" class="lim-small">or act on the referral</text>

  <rect x="245" y="400" width="270" height="82" class="lim-track"/>
  <text x="380" y="434" text-anchor="middle" class="lim-text">Workflow tracking</text>
  <text x="380" y="460" text-anchor="middle" class="lim-small">Current state and next action</text>

  <rect x="585" y="400" width="270" height="82" class="lim-track"/>
  <text x="720" y="434" text-anchor="middle" class="lim-text">Audit and provenance</text>
  <text x="720" y="460" text-anchor="middle" class="lim-small">Who submitted or changed data</text>

  <line x1="330" y1="136" x2="405" y2="128" class="lim-line"/>
  <line x1="770" y1="136" x2="695" y2="128" class="lim-line"/>
  <line x1="330" y1="290" x2="405" y2="290" class="lim-line"/>
  <line x1="695" y1="290" x2="770" y2="290" class="lim-line"/>
  <line x1="550" y1="184" x2="550" y2="232" class="lim-line"/>
  <line x1="470" y1="348" x2="408" y2="400" class="lim-line"/>
  <line x1="630" y1="348" x2="692" y2="400" class="lim-line"/>
</svg>

## Guiding Principle

A referral should contain enough information for the receiving facility to identify the patient, understand why the referral is needed, judge urgency, review the clinical context, know what has already been done, know who sent the referral, know who is expected to receive or act on it, respond or redirect safely, and support audit and accountability.

## Logical Information Groups

| Logical group | What it answers | Why it matters | Current PeReF mapping |
|---------------|-----------------|----------------|-----------------------|
| Patient identity | Who is being referred? | Prevents misidentification and supports patient matching, contact, and handover. | [ERefPatient](StructureDefinition-ereferral-patient.html); `ServiceRequest.subject`; `Task.for`. |
| Sending context | Who created or sent the referral? | Supports accountability, callback, role, and originating facility context. | [PH eReferral PractitionerRole](StructureDefinition-ereferral-practitioner-role.html); practitioner; organization; `ServiceRequest.requester`; `Task.requester`. |
| Receiving context | Who is expected to receive, triage, or perform the requested service? | Supports routing, triage, receiving-facility preparation, and assignment of responsibility. | Organization; [PH eReferral PractitionerRole](StructureDefinition-ereferral-practitioner-role.html); `ServiceRequest.performer`; `Task.owner`. |
| Referral request | What service, consultation, procedure, or action is being requested? | Defines the operational purpose of the referral and the urgency of action. | [EReferral ServiceRequest](StructureDefinition-ereferral-service-request.html); `ServiceRequest.code`; `category`; `priority`; `authoredOn`; `occurrence[x]`. |
| Clinical reason | Why is the referral needed? | Helps the receiving side triage, accept, redirect, or prepare for the patient. | `ServiceRequest.reasonCode`; `ServiceRequest.reasonReference`; Condition; Observation. |
| Clinical context and prior care | What is the patient's current condition, and what has already been done? | Supports safe handover, continuity of care, and avoidance of duplicate or unsafe treatment. | `ServiceRequest.supportingInfo`; Observation; Condition; Procedure; [EReferral MedicationAdministration](StructureDefinition-ereferral-medication-administration.html); [ERefImmunization](StructureDefinition-ereferral-immunization.html). |
| Workflow and response tracking | Where is the referral in the process, and what has the receiving side reported? | Tracks responsibility, response, redirection, and closure without changing the clinical referral request itself. | [EReferral Task](StructureDefinition-ereferral-task.html); `Task.focus`; `Task.status`; `Task.businessStatus`; `Task.statusReason`; `Task.output`. |
| Audit and provenance | Who submitted, signed, or changed referral information? | Supports traceability, trust, review, and medico-legal accountability. | [EReferral Provenance](StructureDefinition-ereferral-provenance.html); `ServiceRequest.relevantHistory`; `Provenance.target`; `Provenance.recorded`; `Provenance.agent`; `Provenance.signature`. |

## Data Dictionary Alignment

The data dictionary remains the source of individual data elements. This page groups those elements into referral-package concepts so reviewers and implementers can discuss the dataset without starting from FHIR paths.

Current FSH comments already identify these draft row clusters:

| Data dictionary area | Draft row references visible in the repository | Logical group |
|----------------------|------------------------------------------------|---------------|
| Referring practitioner and role | REF-1, REF-2 | Sending context |
| Initiating facility | REF-5 to REF-8 | Sending context |
| Care navigator and receiving facility | REF-9 to REF-11 | Receiving context; workflow tracking |
| Referral date, category, priority, supporting information, and reason | REF-13 to REF-16 | Referral request; clinical reason; clinical context |
| Patient demographics and contact details | REF-21 to REF-30 | Patient identity |
| Treatment given | REF-39 | Clinical context and prior care |
| Signature and recorded activity | REF-3, REF-4 | Audit and provenance |

These row references should be verified against the approved data dictionary before release. Missing or changed rows should be updated from the source data dictionary, not inferred from this page.

## FHIR Mapping Summary

| Logical group | Main profile or resource | Main FHIR path |
|---------------|--------------------------|----------------|
| Patient identity | [ERefPatient](StructureDefinition-ereferral-patient.html) | `ServiceRequest.subject`; `Task.for`; `Encounter.subject`. |
| Sending context | [PH eReferral PractitionerRole](StructureDefinition-ereferral-practitioner-role.html), Practitioner, Organization | `ServiceRequest.requester`; `Task.requester`. |
| Receiving context | Organization, [PH eReferral PractitionerRole](StructureDefinition-ereferral-practitioner-role.html) | `ServiceRequest.performer`; `Task.owner`. |
| Referral request | [EReferral ServiceRequest](StructureDefinition-ereferral-service-request.html) | `ServiceRequest.status`; `intent`; `code`; `category`; `priority`; `authoredOn`; `occurrence[x]`; `replaces`. |
| Clinical reason | Condition, Observation | `ServiceRequest.reasonCode`; `ServiceRequest.reasonReference`. |
| Clinical context and prior care | Condition, Observation, Procedure, MedicationAdministration, Immunization | `ServiceRequest.supportingInfo`. |
| Workflow and response tracking | [EReferral Task](StructureDefinition-ereferral-task.html) | `Task.focus`; `Task.status`; `Task.businessStatus`; `Task.statusReason`; `Task.output`. |
| Audit and provenance | [EReferral Provenance](StructureDefinition-ereferral-provenance.html) | `ServiceRequest.relevantHistory`; `Provenance.target`; `Provenance.agent`; `Provenance.signature`. |

The RESTful exchange pattern and profile relationship diagram are described on [FHIR RESTful Interactions and Profile Relationships](fhir-interactions.html).

## Review Expectations

Reviewers should confirm:

- the logical groups match clinical and operational expectations for v0.1;
- the data dictionary row clusters are accurate;
- the FHIR mappings are consistent with the current PeReF profiles;
- unresolved production topics such as routing, consent, security, attachments, and exchange hosting are handled in the appropriate implementation guidance.
