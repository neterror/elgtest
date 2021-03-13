;;; -*- lexical-binding: t -*-
(require 'json)
(require 'orgreport)

;; set the appropriate file name, which can be included as org-agenda file
(defvar gtest-report "~/org/gtest.org")

(defun gt-output-file()
  "Temporary file name to be used for the json output"
  (concat temporary-file-directory (make-temp-name "gtest")))

(defun gt-clear-buffer(buf)
  (with-current-buffer buf
    (save-excursion
      (erase-buffer))))

  
(defun gt-completed(file-name)
  "gtest completion callback. Parse the result into the report file, remove the temp json file"
  (gt-json-to-org (json-read-file file-name)
               (find-file gtest-report))
  (delete-file file-name))


(defun gt-working-directory(program)
  (mapconcat #'identity (butlast (split-string program "/")) "/"))


(defun gt-start(program)
  (interactive "sTest program: ")
  (let ((gtlog (get-buffer-create "*gtlog*"))
        (json-file-name (gt-output-file))
        (default-directory (gt-working-directory program)))

    (gt-clear-buffer gtlog)
    (make-process :name "gtest"
                  :command (list program (concat "--gtest_output=json:" json-file-name))
                  :buffer "gtest"
                  :stderr gtlog
                  :sentinel #'(lambda(process event)
                                (gt-completed json-file-name)))))
(provide 'gtest)
