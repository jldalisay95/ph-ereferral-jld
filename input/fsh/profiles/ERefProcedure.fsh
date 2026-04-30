Profile: ERefProcedure
Parent: PHCoreProcedure
Id: ereferral-procedure
Title: "EReferral Procedure"
Description: "Procedure profile for procedures performed or documented as part of the clinical context of a Philippine eReferral."

* status MS
  * ^short = "Procedure status"
  * ^definition = "The current state of the procedure, such as preparation, in-progress, completed, or not done."

* category MS
  * ^short = "Procedure category"
  * ^definition = "A broad classification of the procedure, such as diagnostic, surgical, therapeutic, or another intervention category when known."

* code MS
  * ^short = "Procedure performed"
  * ^definition = "Identifies the specific procedure, intervention, or documented clinical action performed for the patient."

* subject MS
  * ^short = "Patient who received the procedure"
  * ^definition = "The patient who received or was the subject of the procedure documented in the referral clinical context."

* encounter MS
  * ^short = "Encounter associated with the procedure"
  * ^definition = "The encounter during which the procedure was performed or documented, when this context is available."

* performed[x] MS
  * ^short = "When the procedure was performed"
  * ^definition = "The date, time, period, or approximate timing when the procedure or intervention was performed."

* performer MS
  * ^short = "Who performed the procedure"
  * ^definition = "The practitioner, practitioner role, organization, or other actor who performed or participated in the procedure."

* performer.actor MS
  * ^short = "Actor performing the procedure"
  * ^definition = "Reference to the actor who performed or participated in the procedure."

* reasonCode MS
  * ^short = "Coded reason for the procedure"
  * ^definition = "A coded or textual clinical reason why the procedure or intervention was performed."

* reasonReference MS
  * ^short = "Clinical reason reference"
  * ^definition = "Reference to a condition, observation, prior procedure, report, or document that explains why the procedure was performed."

* note MS
  * ^short = "Procedure notes"
  * ^definition = "Additional narrative details about the procedure, intervention, or its relevance to the referral."
