Instance: ExampleERefDiagnosticReportPDF
InstanceOf: ERefDiagnosticReport
Usage: #example
Title: "Example Laboratory Diagnostic Report with PDF Attachment"
Description: "Example laboratory DiagnosticReport associated with an eReferral and carrying complete report attachment metadata in presentedForm."

* status = #final
* category = http://terminology.hl7.org/CodeSystem/v2-0074#LAB "Laboratory"
* code = $loinc#11502-2 "Laboratory report"
* basedOn = Reference(ExampleERefServiceRequest)
* subject = Reference(ERefPatientExample)
* effectiveDateTime = "2025-03-15T08:30:00+08:00"
* issued = "2025-03-15T10:00:00+08:00"
* performer = Reference(ExampleERefReferringFacility)
* conclusion = "Laboratory report completed and attached for referral review."
* presentedForm.contentType = #application/pdf
* presentedForm.url = "https://example.org/fhir/reports/laboratory-report-2025-001.pdf"
* presentedForm.size = 245760
* presentedForm.title = "Laboratory Report 2025-001"
* presentedForm.creation = "2025-03-15T10:00:00+08:00"
