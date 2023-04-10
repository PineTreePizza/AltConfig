;;; org-ai-useful.el --- A few useful functions and commands -*- lexical-binding: t; -*-

;; This file is NOT part of GNU Emacs.

;; org-ai.el is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; org-ai.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with org-ai.el.
;; If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; None specific org commands.

;;; Code:

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; snippet helpers
(defvar yas-snippet-dirs)

(defvar org-ai-output-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "q") (lambda () (interactive) (kill-buffer-and-window)))
    map)
  "Keymap for `org-ai-output-mode'.")

(define-minor-mode org-ai-output-mode
  "Minor mode for buffers showing org-ai output."
  :init-value nil
  :keymap org-ai-output-mode-map
  :group 'org-ai
  (read-only-mode 1))

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

(defun org-ai-install-yasnippets ()
  "Installs org-ai snippets."
  (interactive)
  (let ((snippet-dir (expand-file-name "snippets/"
                                       (file-name-directory (locate-library "org-ai")))))
    (unless (boundp 'yas-snippet-dirs)
      (setq yas-snippet-dirs nil))
    (add-to-list 'yas-snippet-dirs snippet-dir t)
    (when (fboundp 'yas-load-directory)
      (yas-load-directory snippet-dir))))

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; just prompt

(defcustom org-ai-talk-spoken-input nil
  "Whether to use speech input.
Whether to use speech input for `org-ai-prompt' and
`org-ai-talk-on-region' commands. See `org-ai-talk' for the
details and implementation."
  :type 'boolean
  :group 'org-ai-talk)

(defcustom org-ai-talk-confirm-speech-input nil
  "Ask for confirmation before sending speech input to AI?"
  :type 'boolean
  :group 'org-ai-talk)

(defun org-ai-confirm-send (prompt input)
  "Show `PROMPT' and `INPUT' and ask for confirmation.
Will always return t if `org-ai-talk-confirm-speech-input' is nil."
  (if org-ai-talk-confirm-speech-input
      (let ((window-config (current-window-configuration))
            (buf (get-buffer-create "*org-ai-confirm*")))
        (unwind-protect
            (progn (pop-to-buffer buf)
                   (erase-buffer)
                   (insert prompt)
                   (insert "\n")
                   (insert input)
                   (prog1
                       (y-or-n-p (format "Send to AI?"))
                     (kill-buffer buf)))
          (set-window-configuration window-config)))
    t))

(defmacro org-ai-with-input-or-spoken-text (prompt input &rest body)
  "Macro to optionally use speech input.
`PROMPT' is the prompt to ask the user for.
`INPUT' is the variable to bind the input to.
`BODY' is the body to execute with `INPUT' bound."
  (declare (indent 2))
  `(if ,input
       (progn
         ,@body)
     (if (fboundp 'org-ai-talk--record-and-transcribe-speech)
         (org-ai-talk--record-and-transcribe-speech (lambda (,input)
                                                      (when (org-ai-confirm-send ,prompt ,input)
                                                        ,@body))
                                                    ,prompt)
       (error "Module not loaded: org-ai-talk"))))

(cl-defun org-ai-prompt (prompt &optional &key sys-prompt output-buffer select-output callback)
  "Prompt for a gpt input, insert the response in current buffer.
`PROMPT' is the prompt to use.
`SYS-PROMPT' is the system prompt to use.
`OUTPUT-BUFFER' is the buffer to insert the response in.
`SELECT-OUTPUT' is whether to mark the output.
`CALLBACK' is a function to call after the response is inserted."
  (interactive
   (list (unless org-ai-talk-spoken-input (read-string "What do you want to know? " nil 'org-ai-prompt-history))))

  (org-ai-with-input-or-spoken-text "What do you want to know?" prompt
    (let ((output-buffer (or output-buffer (current-buffer)))
          (start-pos (point)))
      (let* ((sys-input (if sys-prompt (format "[SYS]: %s\n" sys-prompt)))
             (input (format "%s\n[ME]: %s" sys-input prompt)))
        (org-ai-stream-request :messages (org-ai--collect-chat-messages input)
                               :model org-ai-default-chat-model
                               :callback (lambda (response)
                                           (if-let* ((choices (or (alist-get 'choices response)
                                                                  (plist-get response 'choices)))
                                                     (choice (aref choices 0)))
                                               (let ((delta (plist-get choice 'delta)))
                                                 (cond
                                                  ((plist-get delta 'role)
                                                   (let ((role (plist-get delta 'role)))
                                                     (run-hook-with-args 'org-ai-after-chat-insertion-hook 'role role)))
                                                  ((plist-get delta 'content)
                                                   (let ((text (plist-get delta 'content)))
                                                     (with-current-buffer output-buffer
                                                       (insert (decode-coding-string text 'utf-8)))
                                                     (run-hook-with-args 'org-ai-after-chat-insertion-hook 'text text)))
                                                  ((plist-get choice 'finish_reason)
                                                   (when select-output
                                                     (with-current-buffer output-buffer
                                                       (set-mark (point))
                                                       (goto-char start-pos))))))
                                             (run-hook-with-args 'org-ai-after-chat-insertion-hook 'end "")
                                             (when callback (with-current-buffer output-buffer (funcall callback))))))))))

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; org-ai-on-region

(cl-defun org-ai--on-region-internal (start end text-prompt-fn &optional &key output-buffer show-output-buffer callback)
  "Get the currently selected text, create a prompt, insert the response.
`OUTPUT-BUFFER' is the buffer to insert the response in.
`TEXT-PROMPT-FN' is a function that takes the selected text as
argument and returns a prompt.
`START' is the buffer position of the region.
`END' is the buffer position of the region.
`OUTPUT-BUFFER' is the name or the buffer to insert the response in.
`CALLBACK' is a function to call after the response is inserted."
  (let* ((text (encode-coding-string (buffer-substring-no-properties start end) 'utf-8))
         (full-prompt (funcall text-prompt-fn text))
         (output-buffer (get-buffer-create (or output-buffer "*org-ai-on-region*"))))
    (with-current-buffer output-buffer
      (erase-buffer)
      (toggle-truncate-lines -1)
      (when show-output-buffer
        (display-buffer output-buffer)))
    (org-ai-prompt full-prompt :output-buffer output-buffer :callback callback)))


(defun org-ai--insert-quote-prefix (str)
  "Prepend all lines in `STR' with '>'."
  (replace-regexp-in-string "^" "> " str))

(defun org-ai--prompt-on-region-create-text-prompt (user-input text)
  "Create a prompt for `org-ai-on-region'.
`USER-INPUT' is the user input like a question to answer.
`TEXT' is the text of the region."
  (format "In the following I will show you a question and then a text. I want you to answer that question based on the text. Use the text as primary source but also add any external information you think is relevant.

Here is the question:
%s

Here is the text:
%s
" (org-ai--insert-quote-prefix user-input) (org-ai--insert-quote-prefix text)))

(defun org-ai--prompt-on-region-create-code-prompt (user-input text)
  "Create a prompt for `org-ai-on-region'.
`USER-INPUT' is the user input like a question to answer.
`TEXT' is the code of the region."
  (format "In the following I will show you a question and then a code snippet. I want you to answer that question based on the code snippet.

Here is the question:
%s

Here is the code snippet:
%s
" (org-ai--insert-quote-prefix user-input) (org-ai--insert-quote-prefix text)))

(defun org-ai-on-region (start end question &optional buffer-name text-kind)
  "Ask ChatGPT to answer a question based on the selected text.
`QUESTION' is the question to answer.
`START' is the buffer position of the region.
`END' is the buffer position of the region.
`BUFFER-NAME' is the name of the buffer to insert the response in.
`TEXT-KIND' is either the symbol 'text or 'code. If nil, it will
be guessed from the current major mode."
  (interactive
   (let ((question (unless org-ai-talk-spoken-input (read-string "What do you want to know? " nil 'org-ai-on-region-history))))
     (list (region-beginning) (region-end) question)))

  (org-ai-with-input-or-spoken-text "What do you want to know?" question
    (let* ((text-kind (or text-kind (cond ((derived-mode-p 'prog-mode) 'code)
                                          ((derived-mode-p 'text-mode) 'text)
                                          (t 'text))))
           (text-prompt-fn (pcase text-kind
                             ('text (lambda (text) (org-ai--prompt-on-region-create-text-prompt question text)))
                             ('code (lambda (text) (org-ai--prompt-on-region-create-code-prompt question text)))
                             (_ (error "Invalid text-kind: %s" text-kind))))
           (output-buffer (get-buffer-create (or buffer-name "*org-ai-on-region*"))))
      (org-ai--on-region-internal start end text-prompt-fn
                                  :output-buffer output-buffer
                                  :show-output-buffer t
                                  :callback (lambda () (org-ai-output-mode))))))

(defcustom org-ai-summarize-prompt "Summarize this text."
  "The template to use for `org-ai-summarize'."
  :type 'string
  :group 'org-ai)

(defun org-ai-summarize (start end)
  "Ask ChatGPT for a summary of the marked text.
`START' is the buffer position of the start of the text to summarize.
`END' is the buffer position of the end of the text to summarize."
  (interactive "r")
  (org-ai-on-region start end org-ai-summarize-prompt))

(defcustom org-ai-explain-code-prompt "The following shows a source code snippet. Explain what it does and mention potential issues and improvements."
  "The template to use for `org-ai-explain-code'."
  :type 'string
  :group 'org-ai)

(defun org-ai-explain-code (start end)
  "Ask ChatGPT explain a code snippet.
`START' is the buffer position of the start of the code snippet.
`END' is the buffer position of the end of the code snippet."
  (interactive "r")
  (org-ai-on-region start end org-ai-explain-code-prompt))

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; refactor code

(defun org-ai-refactor-code (start end how)
  "Ask ChatGPT refactor a piece of code.
`START' is the buffer position of the start of the code snippet.
`END' is the buffer position of the end of the code snippet.
`HOW' is a string describing how the code should be modified."

  (interactive
   (let ((how (unless org-ai-talk-spoken-input (read-string "How should the code be modified? " nil 'org-ai-on-region-history))))
     (list (region-beginning) (region-end) how)))

  (org-ai-with-input-or-spoken-text "How should the code be modified? " how
    (let ((text-prompt-fn (lambda (code) (format "
In the following I will show you an instruction and then a code snippet. I want you to modify the code snippet based on the instruction. Only output the modified code. Do not include any explanation.

Here is the instruction:
%s

Here is the code snippet:
%s
" how (org-ai--insert-quote-prefix code))))
          (buffer-with-selected-code (current-buffer))
          (output-buffer (get-buffer-create "*org-ai-refactor*"))
          (win-config (current-window-configuration)))
      (org-ai--on-region-internal start end text-prompt-fn
                                  :output-buffer output-buffer
                                  :show-output-buffer t
                                  :callback (lambda ()
                                              (progn
                                                (with-current-buffer output-buffer
                                                  ;; ensure buffer ends with a newline
                                                  (goto-char (point-max))
                                                  (unless (eq (char-before) ?\n) (insert ?\n))
                                                  ;; mark the whole buffer
                                                  (push-mark)
                                                  (push-mark (point-max) nil t)
                                                  (goto-char (point-min)))
                                                (org-ai--diff-and-patch-buffers buffer-with-selected-code output-buffer)
                                                (set-window-configuration win-config)))))))

(defun org-ai--diff-and-patch-buffers (buffer-a buffer-b)
  "Will diff `BUFFER-A' and `BUFFER-B' and and offer to patch'.
`BUFFER-A' is the first buffer.
`BUFFER-B' is the second buffer.
Will open the diff buffer and return it."
  (let* ((reg-A (with-current-buffer buffer-a
                  (cons (region-beginning) (region-end))))
         (reg-B (with-current-buffer buffer-b
                  (cons (region-beginning) (region-end))))
         (text-a (with-current-buffer buffer-a
                   (buffer-substring-no-properties (car reg-A) (cdr reg-A))))
         (text-b (with-current-buffer buffer-b
                   (buffer-substring-no-properties (car reg-B) (cdr reg-B))))
         (win-config (current-window-configuration))
         (diff-buffer (org-ai--diff-strings text-a text-b)))
    ;; Normally the diff would popup a new window. That's annoying.
    (set-window-configuration win-config)
    (display-buffer-use-some-window (get-buffer-create "*Diff*") nil)
    (when (y-or-n-p "Patch?")
      (pop-to-buffer buffer-a)
      (delete-region (car reg-A) (cdr reg-A))
      (insert text-b)
      (deactivate-mark))
    (kill-buffer diff-buffer)
    (kill-buffer buffer-b)
    (set-window-configuration win-config)))

;; (let ((buffer-with-selected-code (current-buffer))
;;       (output-buffer (get-buffer-create "*org-ai-refactor*")))
;;   (with-current-buffer output-buffer
;;     ;; ensure buffer ends with a newline
;;     (end-of-buffer)
;;     (unless (eq (char-before) ?\n) (insert ?\n))
;;     (mark-whole-buffer))
;;   (org-ai--diff-and-patch-buffers buffer-with-selected-code output-buffer))

(defun org-ai--diff-strings (string-a string-b)
  "Will create a unified diff of the two strings.
`STRING-A' is the first string.
`STRING-B' is the second string.
Will open the diff buffer and return it."
  (with-temp-buffer
    (insert string-a)
    (let ((diff-switches "-u")
          (temp-buffer-a (current-buffer)))
      (with-temp-buffer
        (insert string-b)
        (let* ((win (diff temp-buffer-a (current-buffer) nil t))
               (diff-buffer (window-buffer win)))
          diff-buffer)))))

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

(provide 'org-ai-useful)

;;; org-ai-useful.el ends here
