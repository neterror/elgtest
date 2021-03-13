(require 'org)

(defconst gt-tokens '(tests failures disabled errors timestamp time status))

(defun gt-as-property(cons)
  "Convert to org property string"
  (if (consp cons)
    (format "  :%s: %s\n" (car cons) (cdr cons))))

(defun gt-summary-property-list(report tokens)
  "Converts the json properties from the assoc list to string list in org mode property format"
  (remove-if #'null
             (mapcar #'(lambda(x) (gt-as-property (assoc x report))) tokens)))


(defun gt-append-headline(stars report &optional progress)
  "Insert org item. Optionally display percent progress of the subitems"
  (insert stars " " (alist-get 'name report))
  (when progress
    (insert progress))
  (insert "\n  :PROPERTIES:\n")
  (mapc #'insert (gt-summary-property-list report gt-tokens))
  (insert "  :END:\n"))


(defun gt-append-failure-message(msg)
  (insert "*** " (alist-get 'failure msg) "\n\n"))


(defun gt-append-test-case(case)
  (insert  "** " (alist-get 'name case))
  (if (assoc 'failures case)
      (org-todo '(1)) ;;assumed this is TODO
    (org-todo '(2)))  ;;assumed this is DONE
  (insert "\n")
  (mapc #'gt-append-failure-message (alist-get 'failures case)))
      

(defun gt-append-group(group)
  "gtest test suite consists of multiple tests"
  (gt-append-headline "*" group " [%]")
  (mapc 'gt-append-test-case (alist-get 'testsuite group)))

(defun gt-append-test-groups(report)
  (mapc 'gt-append-group report))
      
(defun gt-json-to-org(report buffer)
  (with-current-buffer buffer
    (save-excursion
      (view-mode -1) ;; turn off view mode (from previos calls)
      (erase-buffer)
      (org-mode)
      (insert "#+STARTUP: overview\n\n") ;; everything is folded initially
      (gt-append-test-groups (alist-get 'testsuites report)) ;;append the test groups
      (org-set-startup-visibility)
      (save-buffer)
      (view-mode))))


(provide 'orgreport)
