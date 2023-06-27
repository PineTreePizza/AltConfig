;;; starhugger-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:


;;;### (autoloads nil "starhugger" "starhugger.el" (0 0 0 0))
;;; Generated autoloads from starhugger.el

(autoload 'starhugger-toggle-debug "starhugger" "\
More verbose logging (and maybe indicators)." t nil)

(autoload 'starhugger-trigger-suggestion "starhugger" "\
Show AI-powered code suggestions as overlays.
When an inline suggestion is already showing, new suggestions
will be fetched, you can switch to them by calling
`starhugger-show-next-suggestion' after fetching finishes. NUM:
number of suggestions to fetch at once (actually sequentially,
the newly fetched ones are appended silently). FORCE-NEW: try to
fetch different responses. Non-nil INTERACT: show spinner.

\(fn &key INTERACT FORCE-NEW NUM)" t nil)

(autoload 'starhugger-show-fetched-suggestions "starhugger" "\
Display fetched suggestions at point, or ALL positions.
Note that the number of suggestions are limited by
`starhugger-suggestion-list-size'.

\(fn &optional ALL)" t nil)

(autoload 'starhugger-auto--after-change-h "starhugger" "\


\(fn &optional BEG END OLD-LEN)" nil nil)

(autoload 'starhugger-auto--post-command-h "starhugger" nil nil nil)

(define-minor-mode starhugger-auto-mode "\
Automatic `starhugger-trigger-suggestion' in current buffer." :lighter " 💫" :global nil (if starhugger-auto-mode (progn (add-hook 'post-command-hook #'starhugger-auto--post-command-h nil t) (add-hook 'after-change-functions #'starhugger-auto--after-change-h nil t)) (progn (remove-hook 'post-command-hook #'starhugger-auto--post-command-h t) (remove-hook 'after-change-functions #'starhugger-auto--after-change-h t))))

(register-definition-prefixes "starhugger" '("starhugger-"))

;;;***

;;;### (autoloads nil "starhugger-x" "starhugger-x.el" (0 0 0 0))
;;; Generated autoloads from starhugger-x.el

(autoload 'starhugger-query "starhugger-x" "\
Interactive send PROMPT to the model.
Non-nil END-POS (interactively when prefix arg: active region's
end of current point): insert the parsed response there.
BEG-POS:the beginning of the prompt area. Non-nil DISPLAY:
displays the parsed response. FORCE-NEW: disable caching (options
wait_for_model), interactively: PROMPT equals the old one. ARGS
is optional arguments.

\(fn PROMPT &rest ARGS &key BEG-POS END-POS DISPLAY FORCE-NEW)" t nil)

(autoload 'starhugger-complete "starhugger-x" "\
Insert completion using the prompt from BEGINNING to current point.
BEGINNING defaults to start of current line, paragraph or defun,
whichever is the furthest.

Interactively, you may find `starhugger-complete*' performs
better as it takes as much as `starhugger-max-prompt-length'
allows, starting from buffer beginning.

\(fn &optional BEGINNING)" t nil)

(make-obsolete 'starhugger-complete 'nil '"0.1.8")

(autoload 'starhugger-complete* "starhugger-x" "\
Insert completion, use as much text as possible before point as prompt.
Just `starhugger-complete' under the hood." t nil)

(make-obsolete 'starhugger-complete* 'nil '"0.1.8")

(register-definition-prefixes "starhugger-x" '("starhugger--complete-default-beg-position"))

;;;***

(provide 'starhugger-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; starhugger-autoloads.el ends here
