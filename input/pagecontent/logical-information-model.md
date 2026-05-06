# v0.1 Referral Logical Information Model

## 1. Purpose

This page describes the logical information model for the v0.1 PH eReferral dataset. It explains what information belongs in a referral package, why each information group matters for safe handover, and how each group relates to PeReF FHIR artifacts.

This is not the workflow model and it is not the physical FHIR model. The logical information model describes the referral information before it is represented as FHIR resources, profiles, elements, and examples.

## 2. Relationship to the workflow and state model

The workflow model explains what happens to the referral over time. The state model explains what status the referral is in and which actor is expected to act next. The logical information model explains what information must be present in the referral package so the receiving facility can understand and act on the referral. The FHIR implementation model explains how that information is represented using PeReF profiles, references, terminology, and examples.

Issue [#80](https://github.com/ph-ereferral-organization/ph-ereferral/issues/80) and PR [#83](https://github.com/ph-ereferral-organization/ph-ereferral/pull/83) track the dedicated workflow narrative and state model. Until that workflow page is available in this branch, use the [v0.1 Connectathon Quick-Start](connectathon-readiness.html), [v0.1 Coverage Map](coverage-map.html), and [v0.1 Decision Log](decision-log.html) for the current local v0.1 workflow and artifact context.

## 3. Guiding principle

A referral should contain enough information for the receiving facility to:

- identify the patient;
- understand why the referral is needed;
- judge urgency;
- review the current clinical context;
- know what has already been done;
- know who sent the referral;
- know who is expected to receive or act on it;
- respond, redirect, or close the referral safely;
- support audit and accountability.

## 4. Logical information groups

| Logical information group | Plain-English meaning | Clinical / operational rationale | Related data dictionary rows or concepts | Related PeReF FHIR artifact / path |
|---------------------------|-----------------------|----------------------------------|------------------------------------------|------------------------------------|
| Patient | Who is being referred. | Identifies the person needing care and supports matching, contact, and safe handover. | REF-21 through REF-30 are referenced in `ERefPatient` comments for patient demographics, identifiers, address, contact, next of kin, and PWD registration. | [ERefPatient](StructureDefinition-ereferral-patient.html); `ServiceRequest.subject`; `Task.for` where workflow tracking references the patient. |
| Referring source | Who is sending the referral. | Provides accountability, callback information, practitioner role, and initiating facility context. | REF-1, REF-2, and REF-5 to REF-8 are referenced in `ERefServiceRequest` and `ERefPractitionerRole` comments. | [PH eReferral PractitionerRole](StructureDefinition-ereferral-practitioner-role.html); `ServiceRequest.requester`; practitioner and organization references. |
| Receiving destination | Who is expected to receive or perform the requested service. | Supports routing, triage, preparation, and receiving-side responsibility. | REF-9, REF-10, and REF-11 are referenced in `ERefServiceRequest`, `ERefTask`, and `ERefPractitionerRole` comments for care navigator and receiving facility concepts. | `ServiceRequest.performer`; Organization; [PH eReferral PractitionerRole](StructureDefinition-ereferral-practitioner-role.html); `Task.owner` when assigned. |
| Referral request | What care, service, consultation, procedure, or action is being requested. | Defines the purpose and urgency of the referral request. | REF-13, REF-14, and REF-16 are referenced in `ERefServiceRequest` comments for authored date, category, priority, and requested service/reason concepts. | [EReferral ServiceRequest](StructureDefinition-ereferral-service-request.html); `ServiceRequest.code`; `ServiceRequest.category`; `ServiceRequest.priority`; `ServiceRequest.authoredOn`; `ServiceRequest.occurrence[x]`. |
| Clinical reason | Why the referral is needed. | Supports triage, acceptance, preparation, or redirection by the receiving facility. | REF-16 is referenced in `ERefServiceRequest` comments for reason for referral and supporting clinical reason concepts. | `ServiceRequest.reasonCode`; `ServiceRequest.reasonReference`; Condition; Observation. |
| Clinical context | Information needed to understand the patient's current condition. | Supports safe handover and receiving-facility preparation before the patient arrives or is redirected. | REF-15 is referenced for time called and supporting clinical information; other detailed clinical rows should be inserted from the data dictionary when confirmed. | `ServiceRequest.supportingInfo`; Observation; Condition; Procedure; DiagnosticReport if applicable; [ERefImmunization](StructureDefinition-ereferral-immunization.html). |
| Prior care / treatment given | What has already been done before referral. | Supports continuity of care, avoids duplicate or unsafe treatment, and helps the receiving facility understand stabilization already performed. | REF-39 is referenced in `ERefMedicationAdministration`; REF-15 is referenced for supporting information. Additional treatment rows should be confirmed from the data dictionary. | [EReferral MedicationAdministration](StructureDefinition-ereferral-medication-administration.html); Procedure if applicable; `ServiceRequest.supportingInfo`. |
| Workflow tracking | Where the referral is in the process and who is responsible for the next action. | Tracks responsibility, assignment, and progression without changing the clinical referral request itself. | REF-9 is referenced for care navigator assignment. Workflow status row mapping needs TDG confirmation. | [EReferral Task](StructureDefinition-ereferral-task.html); `Task.focus`; `Task.status`; `Task.requester`; `Task.owner`; `Task.authoredOn`; `Task.lastModified`. |
| Receiving response | What the receiving side decided or reported. | Confirms whether the patient can be accepted, cannot be received, is referred onward, or has another receiving-side outcome. | [DATA DICTIONARY ROW TO BE INSERTED] for receiving-facility response semantics. Current terminology is represented in the eReferral workflow code system and receiving response value set. | [EReferral Task](StructureDefinition-ereferral-task.html); `Task.businessStatus`; `Task.statusReason`; `Task.output`; onward `ServiceRequest.replaces` where applicable. |
| Audit / provenance | Who signed, submitted, changed, or updated referral information. | Supports accountability, medico-legal traceability, review, and implementation trust. | REF-3 and REF-4 are referenced in `ERefServiceRequest` and `ERefProvenance` comments for signature time and professional signature. | [EReferral Provenance](StructureDefinition-ereferral-provenance.html); `ServiceRequest.relevantHistory`; `Provenance.target`; `Provenance.recorded`; `Provenance.agent`; `Provenance.signature`. |

## 5. Data dictionary mapping approach

This page does not replace the data dictionary. It groups data dictionary elements into implementer-facing logical groups so CDG, TDG, implementers, and beta testers can discuss the referral package without starting from FHIR paths.

The REF row identifiers above are taken only from TDG references already visible in the repository's FSH comments and examples. They should be treated as draft mapping hints until checked against the source data dictionary. Do not treat this page as the authoritative row list.

Rows not visible in the repository are marked as `[DATA DICTIONARY ROW TO BE INSERTED]` or described as needing TDG confirmation. Missing row numbers should be filled from the approved data dictionary rather than inferred from adjacent rows.

## 6. FHIR mapping summary

| Logical group | Primary FHIR resource/profile | Main FHIR path | Notes / constraints |
|---------------|-------------------------------|----------------|---------------------|
| Patient | [ERefPatient](StructureDefinition-ereferral-patient.html) | `ServiceRequest.subject`; `Task.for` | The ServiceRequest subject identifies the referred patient. Task may also reference the patient for workflow context. |
| Referring source | [PH eReferral PractitionerRole](StructureDefinition-ereferral-practitioner-role.html), Practitioner, Organization | `ServiceRequest.requester`; `Task.requester` | `ServiceRequest.requester` is required in `ERefServiceRequest` and uses PractitionerRole to carry practitioner and facility context. |
| Receiving destination | Organization, [PH eReferral PractitionerRole](StructureDefinition-ereferral-practitioner-role.html) | `ServiceRequest.performer`; `Task.owner` | `ServiceRequest.performer` identifies the intended receiving performer. `Task.owner` identifies the assigned receiving-side owner when known. |
| Referral request | [EReferral ServiceRequest](StructureDefinition-ereferral-service-request.html) | `ServiceRequest.code`; `ServiceRequest.category`; `ServiceRequest.priority`; `ServiceRequest.intent`; `ServiceRequest.authoredOn`; `ServiceRequest.occurrence[x]` | `ServiceRequest.intent` is fixed to `order` for eReferral. Priority is bound to the eReferral priority value set. |
| Clinical reason | Condition, Observation, [EReferral ServiceRequest](StructureDefinition-ereferral-service-request.html) | `ServiceRequest.reasonCode`; `ServiceRequest.reasonReference` | Reason can be represented as a coded reason and/or references to condition or observation evidence. |
| Clinical context | Observation, Condition, Procedure, MedicationAdministration, Immunization | `ServiceRequest.supportingInfo` | Current profile constraints allow supporting Condition, Observation, Procedure, MedicationAdministration, and Immunization references from PH Core-based profiles. |
| Prior care / treatment given | [EReferral MedicationAdministration](StructureDefinition-ereferral-medication-administration.html), Procedure | `ServiceRequest.supportingInfo`; `MedicationAdministration.status`; `MedicationAdministration.medication[x]`; `MedicationAdministration.effective[x]` | Used for stabilization, medications, procedures, or other care already performed before referral. |
| Workflow tracking | [EReferral Task](StructureDefinition-ereferral-task.html) | `Task.focus`; `Task.status`; `Task.requester`; `Task.owner`; `Task.authoredOn`; `Task.lastModified` | `Task.focus` is required and points to the `ERefServiceRequest` being tracked. |
| Receiving response | [EReferral Task](StructureDefinition-ereferral-task.html) | `Task.businessStatus`; `Task.statusReason`; `Task.output` | `Task.status` carries the standard FHIR lifecycle status. `Task.businessStatus` carries the PeReF receiving-response term. |
| Audit / provenance | [EReferral Provenance](StructureDefinition-ereferral-provenance.html) | `ServiceRequest.relevantHistory`; `Provenance.target`; `Provenance.recorded`; `Provenance.agent`; `Provenance.signature` | `ERefProvenance.target` is constrained to the eReferral ServiceRequest. |
| Encounter closure context | [ERefEncounter](StructureDefinition-ereferral-encounter.html) | `Encounter.basedOn`; `Encounter.subject`; `Encounter.reasonReference` | Used when the referral results in or is associated with a receiving encounter. |

## 7. Relationship to AU eRequesting

The AU eRequesting guidance informed the structure of this page because it separates clinician-facing data requirements from FHIR implementation mapping. PeReF follows a similar pattern by first explaining logical referral information groups, then mapping those groups to FHIR artifacts and paths.

This page does not copy AU eRequesting content and does not adopt AU eRequesting requirements as Philippine policy. PeReF remains referral-specific and Philippine-context-specific.

Reference pages:

- [AU eRequesting General Guidance](https://build.fhir.org/ig/hl7au/au-fhir-erequesting/general-guidance.html)
- [AU eRequesting Data Items](https://build.fhir.org/ig/hl7au/au-fhir-erequesting/auereqdi.html)

## 8. Known limitations for v0.1

- This logical model is draft and intended for v0.1 beta testing and review.
- It does not yet represent the full production referral policy.
- Some data dictionary rows still need validation against the source data dictionary.
- Some clinical concepts may still require CDG confirmation.
- Some artifact mappings may change after TDG review.
- Production routing, consent, security, attachment exchange, and exchange hosting may be covered elsewhere or deferred.
- The dedicated workflow narrative from issue #80 / PR #83 is not yet present in this local branch, so this page links to the current local readiness, coverage, and decision pages instead of an internal workflow page.

## 9. Review expectations

This page should be reviewed by:

- CDG for clinical and operational meaning;
- TDG for data dictionary and FHIR mapping accuracy;
- IG Product Owner for v0.1 scope alignment.
