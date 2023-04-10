;;; auto-auto-indent-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "auto-auto-indent" "auto-auto-indent.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from auto-auto-indent.el

(autoload 'auto-auto-indent-mode "auto-auto-indent" "\
Automatic automatic indentation.
Works pretty well for lisp out of the box.
Other modes might need some tweaking to set up:
If you trust the mode's automatic indentation completely, you can add to it's
init hook:

This is a minor mode.  If called interactively, toggle the
`Auto-Auto-Indent mode' mode.  If the prefix argument is
positive, enable the mode, and if it is zero or negative, disable
the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `auto-auto-indent-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(set (make-local-variable 'aai-indent-function)
     'aai-indent-defun)

or

\(set (make-local-variable 'aai-indent-function)
     'aai-indent-forward)

depending on whether the language has small and clearly
identifiable functions, that `beginning-of-defun' and
`end-of-defun' can find.

If on the other hand you don't trust the mode at all, but like
the cursor correction and delete-char behaviour,

you can add

\(set (make-local-variable
      'aai-after-change-indentation) nil)

if the mode indents well in all but a few cases, you can change the
`aai-indentable-line-p-function'. This is what I have in my php mode setup:

\(set (make-local-variable
      'aai-indentable-line-p-function)
     (lambda ()
       (not (or (es-line-matches-p \"EOD\")
                (es-line-matches-p \"EOT\")))))

\(fn &optional ARG)" t nil)

(register-definition-prefixes "auto-auto-indent" '("aai-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; auto-auto-indent-autoloads.el ends here
