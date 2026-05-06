# FHIR RESTful Interactions and Profile Relationships

## Purpose

This page gives an example RESTful interaction pattern for exchanging a PH eReferral package. It is implementation guidance for v0.1 testing and review. It does not replace a server CapabilityStatement, security specification, or production exchange agreement.

The logical information model describes the information that belongs in the referral package. This page describes one way that information can move through FHIR RESTful interactions.

## Example RESTful Interaction Flow

<svg xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="flow-title flow-desc" width="100%" viewBox="0 0 1180 650" preserveAspectRatio="xMidYMin meet">
  <title id="flow-title">Example eReferral RESTful interaction flow</title>
  <desc id="flow-desc">Sequence-style diagram showing a referring system creating referral resources, a FHIR server storing them, and a receiving system searching, reading, updating, and closing referral workflow resources.</desc>
  <defs>
    <style>
      .flow-head { fill: #eef4fb; stroke: #2f5f8f; stroke-width: 2; rx: 8; }
      .flow-server { fill: #edf7f0; stroke: #28724a; stroke-width: 2; rx: 8; }
      .flow-line { stroke: #8894a0; stroke-width: 2; }
      .flow-arrow { stroke: #2f4050; stroke-width: 2.4; marker-end: url(#flow-arrow); fill: none; }
      .flow-text { font-family: Arial, sans-serif; font-size: 18px; fill: #1b1f24; }
      .flow-small { font-family: Arial, sans-serif; font-size: 14px; fill: #1b1f24; }
      .flow-note { font-family: Arial, sans-serif; font-size: 13px; fill: #44515f; }
    </style>
    <marker id="flow-arrow" markerWidth="10" markerHeight="10" refX="8" refY="3" orient="auto" markerUnits="strokeWidth">
      <path d="M0,0 L0,6 L9,3 z" fill="#2f4050"/>
    </marker>
  </defs>

  <rect x="55" y="34" width="260" height="58" class="flow-head"/>
  <text x="185" y="70" text-anchor="middle" class="flow-text">Referring system</text>
  <rect x="460" y="34" width="260" height="58" class="flow-server"/>
  <text x="590" y="70" text-anchor="middle" class="flow-text">FHIR server</text>
  <rect x="865" y="34" width="260" height="58" class="flow-head"/>
  <text x="995" y="70" text-anchor="middle" class="flow-text">Receiving system</text>

  <line x1="185" y1="100" x2="185" y2="610" class="flow-line"/>
  <line x1="590" y1="100" x2="590" y2="610" class="flow-line"/>
  <line x1="995" y1="100" x2="995" y2="610" class="flow-line"/>

  <line x1="190" y1="145" x2="585" y2="145" class="flow-arrow"/>
  <text x="205" y="132" class="flow-small">1. POST/PUT patient, facilities, practitioners, clinical evidence</text>

  <line x1="190" y1="210" x2="585" y2="210" class="flow-arrow"/>
  <text x="205" y="197" class="flow-small">2. POST ServiceRequest using ERefServiceRequest</text>

  <line x1="190" y1="275" x2="585" y2="275" class="flow-arrow"/>
  <text x="205" y="262" class="flow-small">3. POST Task with focus = ServiceRequest and status = requested</text>

  <line x1="990" y1="340" x2="598" y2="340" class="flow-arrow"/>
  <text x="608" y="327" class="flow-small">4. SEARCH/READ referral Task or ServiceRequest</text>

  <line x1="990" y1="405" x2="598" y2="405" class="flow-arrow"/>
  <text x="608" y="392" class="flow-small">5. PUT/PATCH Task response state and businessStatus</text>

  <line x1="990" y1="470" x2="598" y2="470" class="flow-arrow"/>
  <text x="608" y="457" class="flow-small">6. POST Provenance, Encounter, or onward ServiceRequest as needed</text>

  <line x1="990" y1="535" x2="598" y2="535" class="flow-arrow"/>
  <text x="608" y="522" class="flow-small">7. PUT/PATCH Task status = completed when referral is closed</text>

  <text x="590" y="622" text-anchor="middle" class="flow-note">Exact supported searches, transactions, update style, and security controls are server capability decisions.</text>
</svg>

## RESTful Interactions

| Interaction | Example REST operation | Main artifacts | Notes |
|-------------|------------------------|----------------|-------|
| Create or update shared reference data | `POST /Patient`, `PUT /Patient/{id}`, `POST /Organization`, `POST /PractitionerRole` | [ERefPatient](StructureDefinition-ereferral-patient.html), Organization, Practitioner, [PH eReferral PractitionerRole](StructureDefinition-ereferral-practitioner-role.html) | Use existing records when available. Create or update only when the server and exchange agreement allow it. |
| Create the referral request | `POST /ServiceRequest` | [EReferral ServiceRequest](StructureDefinition-ereferral-service-request.html) | Carries patient, requester, receiving performer, requested service, urgency, reason, and supporting clinical references. |
| Create workflow tracking | `POST /Task` | [EReferral Task](StructureDefinition-ereferral-task.html) | `Task.focus` points to the ServiceRequest. Initial v0.1 exchange normally starts with a requested Task. |
| Read or search for referrals | `GET /Task?focus=ServiceRequest/{id}`, `GET /ServiceRequest?performer=Organization/{id}&status=active` | Task, ServiceRequest | These are example searches. Actual supported search parameters should be checked in the server CapabilityStatement. |
| Record receiving response | `PUT /Task/{id}` or `PATCH /Task/{id}` | [EReferral Task](StructureDefinition-ereferral-task.html) | Updates `Task.status`, `Task.businessStatus`, `Task.statusReason`, and/or `Task.output` depending on the response. |
| Record onward referral | `POST /ServiceRequest`; `PUT/PATCH /Task/{id}` | ServiceRequest, Task | An onward ServiceRequest can use `ServiceRequest.replaces` to link back to the previous referral request. |
| Record audit event or signature | `POST /Provenance` | [EReferral Provenance](StructureDefinition-ereferral-provenance.html) | Provenance can target the ServiceRequest and record signer, author, update, or other auditable activity. |
| Record encounter or closure context | `POST /Encounter`; `PUT/PATCH /Task/{id}` | [ERefEncounter](StructureDefinition-ereferral-encounter.html), Task | Encounter can point back to the referral using `Encounter.basedOn`. Task completion records closure of the workflow tracking item. |
| Submit as one package when supported | `POST /` with a transaction Bundle | Bundle containing the referral package resources | Transaction Bundles are useful for keeping references consistent, but server support and security rules must be confirmed. |

## eReferral Profile Relationship Diagram

<svg xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="rel-title rel-desc" width="100%" viewBox="0 0 1180 720" preserveAspectRatio="xMidYMin meet">
  <title id="rel-title">PeReF profile relationship diagram</title>
  <desc id="rel-desc">Diagram showing ERefServiceRequest as the central referral request, with Patient, PractitionerRole, Organization, Task, Provenance, Encounter, and supporting clinical resources related by FHIR references.</desc>
  <defs>
    <style>
      .rel-core { fill: #edf7f0; stroke: #28724a; stroke-width: 2; rx: 8; }
      .rel-box { fill: #f8fbff; stroke: #2f5f8f; stroke-width: 2; rx: 8; }
      .rel-track { fill: #fff7e8; stroke: #9a6400; stroke-width: 2; rx: 8; }
      .rel-text { font-family: Arial, sans-serif; font-size: 18px; fill: #1b1f24; }
      .rel-small { font-family: Arial, sans-serif; font-size: 13px; fill: #1b1f24; }
      .rel-label { font-family: Arial, sans-serif; font-size: 13px; fill: #44515f; }
      .rel-line { stroke: #53616f; stroke-width: 2; marker-end: url(#rel-arrow); fill: none; }
    </style>
    <marker id="rel-arrow" markerWidth="10" markerHeight="10" refX="8" refY="3" orient="auto" markerUnits="strokeWidth">
      <path d="M0,0 L0,6 L9,3 z" fill="#53616f"/>
    </marker>
  </defs>

  <rect x="425" y="290" width="330" height="100" class="rel-core"/>
  <text x="590" y="326" text-anchor="middle" class="rel-text">ERefServiceRequest</text>
  <text x="590" y="352" text-anchor="middle" class="rel-small">central referral request</text>
  <text x="590" y="374" text-anchor="middle" class="rel-small">requester, performer, reason, supportingInfo</text>

  <rect x="70" y="80" width="260" height="78" class="rel-box"/>
  <text x="200" y="112" text-anchor="middle" class="rel-text">ERefPatient</text>
  <text x="200" y="138" text-anchor="middle" class="rel-small">subject of referral</text>

  <rect x="460" y="70" width="260" height="92" class="rel-box"/>
  <text x="590" y="102" text-anchor="middle" class="rel-text">PractitionerRole</text>
  <text x="590" y="128" text-anchor="middle" class="rel-small">referring practitioner</text>
  <text x="590" y="148" text-anchor="middle" class="rel-small">and facility context</text>

  <rect x="850" y="80" width="260" height="78" class="rel-box"/>
  <text x="980" y="112" text-anchor="middle" class="rel-text">Organization</text>
  <text x="980" y="138" text-anchor="middle" class="rel-small">receiving facility</text>

  <rect x="70" y="292" width="260" height="96" class="rel-box"/>
  <text x="200" y="324" text-anchor="middle" class="rel-text">Condition / Observation</text>
  <text x="200" y="350" text-anchor="middle" class="rel-small">clinical reason</text>
  <text x="200" y="370" text-anchor="middle" class="rel-small">and evidence</text>

  <rect x="70" y="520" width="260" height="104" class="rel-box"/>
  <text x="200" y="552" text-anchor="middle" class="rel-text">Supporting clinical info</text>
  <text x="200" y="578" text-anchor="middle" class="rel-small">Observation, Condition, Procedure,</text>
  <text x="200" y="598" text-anchor="middle" class="rel-small">MedicationAdministration, Immunization</text>

  <rect x="460" y="520" width="260" height="92" class="rel-track"/>
  <text x="590" y="552" text-anchor="middle" class="rel-text">ERefTask</text>
  <text x="590" y="578" text-anchor="middle" class="rel-small">workflow and receiving response</text>

  <rect x="850" y="292" width="260" height="96" class="rel-track"/>
  <text x="980" y="324" text-anchor="middle" class="rel-text">ERefProvenance</text>
  <text x="980" y="350" text-anchor="middle" class="rel-small">audit, signature, activity</text>
  <text x="980" y="370" text-anchor="middle" class="rel-small">history</text>

  <rect x="850" y="520" width="260" height="92" class="rel-box"/>
  <text x="980" y="552" text-anchor="middle" class="rel-text">ERefEncounter</text>
  <text x="980" y="578" text-anchor="middle" class="rel-small">receiving encounter context</text>

  <line x1="330" y1="122" x2="425" y2="310" class="rel-line"/>
  <text x="340" y="196" class="rel-label">subject</text>
  <line x1="590" y1="162" x2="590" y2="290" class="rel-line"/>
  <text x="604" y="230" class="rel-label">requester</text>
  <line x1="850" y1="124" x2="755" y2="310" class="rel-line"/>
  <text x="780" y="196" class="rel-label">performer</text>
  <line x1="330" y1="340" x2="425" y2="340" class="rel-line"/>
  <text x="338" y="326" class="rel-label">reasonReference</text>
  <line x1="330" y1="572" x2="475" y2="390" class="rel-line"/>
  <text x="336" y="488" class="rel-label">supportingInfo</text>
  <line x1="590" y1="520" x2="590" y2="390" class="rel-line"/>
  <text x="604" y="462" class="rel-label">focus</text>
  <line x1="850" y1="340" x2="755" y2="340" class="rel-line"/>
  <text x="770" y="326" class="rel-label">relevantHistory</text>
  <line x1="940" y1="520" x2="725" y2="390" class="rel-line"/>
  <text x="802" y="470" class="rel-label">basedOn</text>
</svg>

## Relationship Summary

| Relationship | FHIR path | Meaning |
|--------------|-----------|---------|
| Patient to referral request | `ServiceRequest.subject` | The patient being referred. |
| Referring practitioner/facility to request | `ServiceRequest.requester` | The sending side responsible for the referral request. |
| Receiving facility or role to request | `ServiceRequest.performer` | The intended receiver or performer of the requested service. |
| Clinical reason to request | `ServiceRequest.reasonCode`; `ServiceRequest.reasonReference` | The reason the receiving side should evaluate the referral. |
| Supporting clinical information to request | `ServiceRequest.supportingInfo` | Clinical observations, conditions, procedures, treatment, medications, or immunizations needed for handover. |
| Workflow tracking to request | `Task.focus` | The Task tracking the state and receiving response for the ServiceRequest. |
| Audit record to request | `ServiceRequest.relevantHistory`; `Provenance.target` | The provenance record for signatures, submissions, and updates. |
| Encounter to request | `Encounter.basedOn` | The encounter associated with acting on or closing the referral. |

## Implementation Notes

- A REST exchange can use individual resource interactions or a transaction Bundle, depending on the server capability and exchange agreement.
- `PUT` and `PATCH` are both shown for updates because implementations may choose full-resource replacement or partial update. The server CapabilityStatement should state what is supported.
- `ServiceRequest` carries the clinical request. `Task` carries workflow tracking, receiving response, assignment, and closure state.
- Search examples on this page are illustrative. Implementers should confirm supported search parameters, includes, reverse includes, paging, and versioning behavior.
- Production deployments still need security, consent, routing, attachment, and audit policy guidance beyond this v0.1 example flow.
