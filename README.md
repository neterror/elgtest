# elgtest
Emacs extension to start googletest and convert the result as org mode report

Each failed test is displayed as org-mode TODO item, successful tests are DONE items. Uses the org-mode progress feature to visualize the percentage of failed items. Numbeer of failed/succeded tests are org-mode properties. If the org report is included in org-agenda-files, quick lookups of the results can be done - summary of all falied tests, match by failure property.
