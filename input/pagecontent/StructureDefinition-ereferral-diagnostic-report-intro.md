### EReferral DiagnosticReport

The **EReferral DiagnosticReport** profile represents laboratory, diagnostic imaging, pathology, and histopathology reports that are relevant to referral handover. A report is normally linked from `ServiceRequest.supportingInfo`. When the originating referral request is known, `DiagnosticReport.basedOn` may reference the associated `ERefServiceRequest`.

The [PeReF PDF attachment example](DiagnosticReport-ExampleERefDiagnosticReportPDF.html) demonstrates a report associated with an eReferral and a complete report attachment represented through `presentedForm`. Additional payload patterns are available in the official [FHIR R4 DiagnosticReport examples](https://hl7.org/fhir/R4/diagnosticreport-examples.html).

#### Clinical Rationale

Referral recipients need both individual findings and the report-level interpretation produced by a laboratory, imaging service, or pathologist. `Observation` alone represents atomic findings; `DiagnosticReport` supplies the report context, groups structured results, carries a conclusion, and can include the complete issued report.

#### Diagnostic Results

- Use `Observation` for an atomic finding or measurement, such as a glucose result.
- Use `DiagnosticReport.result` to link the report to structured atomic `ERefObservation` results when available.
- Use `DiagnosticReport.basedOn` to reference the associated `ERefServiceRequest` when known.
- Use `DiagnosticReport.conclusion` for a concise report-level interpretation or summary.
- Use `DiagnosticReport.presentedForm` for the complete formatted report.
- Use `DiagnosticReport.media.link` only for selected key images represented as `Media`; it is not a substitute for the complete report attachment.

`DiagnosticReport.code` retains the FHIR R4 preferred binding to diagnostic report codes from [LOINC](https://loinc.org/). PeReF does not introduce a narrower report-code value set for v0.1.

This profile does not define a full laboratory information system, radiology workflow, PACS integration, DICOM exchange, or `ImagingStudy` workflow.

#### Report Attachments

Complete report attachments use `presentedForm`. Supported MIME types are:

| File type | MIME type |
|-----------|-----------|
| PDF or PDF/A | `application/pdf` |
| PNG | `image/png` |
| JPG or JPEG | `image/jpeg` |
| GIF | `image/gif` |

Attachments should not exceed **5 MB (5,242,880 bytes)**. The profile applies this as a warning when `Attachment.size` is populated. Implementers should prefer `Attachment.url` for externally retrievable report content or use a small payload when inline `Attachment.data` is necessary; large base64 examples are intentionally excluded.

The supported MIME types remain narrative guidance for v0.1. `Attachment.contentType` keeps its standard FHIR R4 required binding to the MIME Types value set; PeReF does not add a custom MIME CodeSystem or ValueSet.

This is a simple eReferral attachment approach aligned with [FHIR R4 DiagnosticReport](https://hl7.org/fhir/R4/diagnosticreport.html) and informed by [NHS e-Referral file attachment guidance](https://digital.nhs.uk/services/e-referral-service/api/updates-and-releases/roadmap/file-attachments), adapted for PeReF referral supporting information.
