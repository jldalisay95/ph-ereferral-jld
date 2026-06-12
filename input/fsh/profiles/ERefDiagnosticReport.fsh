// PH Core does not currently publish a DiagnosticReport profile, so this
// eReferral profile derives directly from the FHIR R4 base resource.
// TDG REF-40 maps laboratory result attachments to presentedForm and links
// the report from ServiceRequest.supportingInfo.
Profile: ERefDiagnosticReport
Parent: DiagnosticReport
Id: ereferral-diagnostic-report
Title: "EReferral DiagnosticReport"
Description: "Diagnostic report profile for laboratory, diagnostic imaging, pathology, and histopathology reports shared as supporting clinical information in a Philippine eReferral."

* ^status = #draft
* ^experimental = true
* ^purpose = "To support referral handover of diagnostic reports that summarize or group diagnostic findings, link to structured atomic Observation results when available, and carry a complete formatted report attachment when needed."

* status MS
  * ^short = "Diagnostic report status"
  * ^definition = "The current status of the diagnostic report shared with the referral."

* category MS
  * ^short = "Diagnostic service category"
  * ^definition = "The diagnostic service category, such as laboratory, radiology, or pathology."

* code MS
  * ^short = "Diagnostic report type"
  * ^definition = "The diagnostic report or panel represented by this resource. The inherited FHIR R4 preferred binding uses LOINC diagnostic report codes."

* subject 1..1 MS
* subject only Reference(ERefPatient)
  * ^short = "Patient who is the subject of the report"
  * ^definition = "The eReferral patient whose diagnostic findings are summarized in this report."

* effective[x] MS
  * ^short = "Clinically relevant report time"
  * ^definition = "The clinically relevant time or period for the diagnostic observations represented by the report."

* issued MS
  * ^short = "When the report was issued"
  * ^definition = "The date and time when the diagnostic report was released."

* performer MS
* performer only Reference(PHCorePractitioner or PHCoreOrganization)
  * ^short = "Diagnostic report performer"
  * ^definition = "The practitioner, laboratory, imaging center, or other healthcare organization responsible for the report."

* result MS
* result only Reference(ERefObservation)
  * ^short = "Structured atomic diagnostic results"
  * ^definition = "References to structured atomic Observation results included in or summarized by this report."

* media MS

* media.link MS
  * ^short = "Selected key image"
  * ^definition = "A reference to a Media resource containing a selected key image associated with the report. The complete issued report belongs in presentedForm."

* conclusion MS
  * ^short = "Clinical conclusion or interpretation"
  * ^definition = "A concise clinical interpretation or summary of the diagnostic findings."

* presentedForm MS
  * ^short = "Complete formatted diagnostic report"
  * ^definition = "The complete report as an attachment. Supported formats are PDF or PDF/A (application/pdf), PNG (image/png), JPG/JPEG (image/jpeg), and GIF (image/gif). Attachments should not exceed 5 MB (5,242,880 bytes)."

* presentedForm.contentType 1..1

* obeys eref-diagnosticreport-attachment-size

Invariant: eref-diagnosticreport-attachment-size
Description: "Presented report attachments should not exceed 5 MB when Attachment.size is populated."
Severity: #warning
Expression: "presentedForm.all(size.empty() or size <= 5242880)"
