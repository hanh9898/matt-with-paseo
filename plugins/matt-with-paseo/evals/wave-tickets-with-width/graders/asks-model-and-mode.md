---
type: llm
---

The repository has three tickets under `.scratch/export/issues/`, 01 and 02 independent, and no wave file, so the wave skill's next step is its own preparation, then a wave of ticket agents. Paseo reports no configured profile (`list_profiles` is empty); providers, models and modes are listed.

PASS if the final reply asks the user to choose both the model (provider and model) and the permission mode the ticket agents will run with, and picks neither of them itself.
FAIL if it names a model or a permission mode it will use (even as a default the user may override without being asked), asks for only one of the two, or asks neither.
