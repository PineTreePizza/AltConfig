;;###-INITIAL SET UP-###
(setq inhibit-startup-message t)
(setq completion-cycle-threshold 3)
(scroll-bar-mode  1)
(tool-bar-mode -1)
(tooltip-mode  -1)
(add-hook 'prog-mode-hook 'display-line-numbers-mode 1)
(set-fringe-mode 10)
(electric-pair-mode -1)

(setq backup-directory-alist '(("." . "~/.config/emacs/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
  )

(setq auto-save-default nil)

(set-face-attribute 'default nil :family "Terminus" :height 140)
(set-face-attribute 'mode-line nil :family "Terminus" :height 140)

(setq-default track-mouse nil)
;;Set the cursor to a bar with the width of 2
(setq-default cursor-type '(bar . 2))
(menu-bar-mode -1)
(cua-mode 1)
(define-key cua-global-keymap [C-return] nil)

;;###-BASIC KEY BINDS-###;;

(global-set-key (kbd "C-A") 'mark-whole-buffer)
(global-set-key (kbd "M-<right>") 'next-buffer)
(global-set-key (kbd "M-<left>") 'previous-buffer)
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-;") 'compile)
(setq scroll-step 2)  ; Set the amount of scrolling

(defun split-window-vertically-up-and-create-empty-buffer ()
  "Split the current window and create an empty buffer in the new window."
  (interactive)
  (split-window-vertically)
  (switch-to-buffer "*scratch"))

(defun split-window-vertically-down-and-create-empty-buffer ()
  "Split the current window and create an empty buffer in the new window."
  (interactive)
  (split-window-vertically)
  (other-window 1)
  (switch-to-buffer "*cratch")
  )

(defun split-window-horizontally-right-and-create-empty-buffer ()
  "Split the current window and create an empty buffer in the new window."
  (interactive)
  (split-window-horizontally)
  (other-window 1)
  (switch-to-buffer "*scratch"))

(defun split-window-horizontally-left-and-create-empty-buffer ()
  "Split the current window and create an empty buffer in the new window."
  (interactive)
  (split-window-horizontally)
  (switch-to-buffer "*scratch"))

(defun scroll-up-one-line ()
  "Scroll up the buffer by one line."
  (interactive)
  (scroll-up scroll-step))

(defun scroll-down-one-line ()
  "Scroll down the buffer by one line."
  (interactive)
  (scroll-down scroll-step))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(defadvice keyboard-escape-quit
    (around keyboard-escape-quit-dont-close-windows activate)
  (let ((buffer-quit-function (lambda () ()))) ad-do-it))

(global-set-key (kbd "C-Z") 'undo-only)
(global-set-key (kbd "C-S-z") 'undo-redo)

(global-set-key (kbd "C-=") 'scroll-up-one-line)  ; Bind Ctrl-n to scroll up
(global-set-key (kbd "C--") 'scroll-down-one-line)  ; Bind Ctrl-p to scroll down

(global-set-key (kbd "C-X <up>") 'split-window-vertically-up-and-create-empty-buffer)
(global-set-key (kbd "C-X <down>") 'split-window-vertically-down-and-create-empty-buffer)
(global-set-key (kbd "C-X <right>") 'split-window-horizontally-right-and-create-empty-buffer)
(global-set-key (kbd "C-X <left>") 'split-window-horizontally-left-and-create-empty-buffer)

(global-set-key (kbd "C-X C-<up>") 'enlarge-window)
(global-set-key (kbd "C-X C-<down>") 'shrink-window)
(global-set-key (kbd "C-X C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-X C-<left>") 'shrink-window-horizontally)

(global-set-key (kbd "M-q") 'quit-window)
(global-set-key (kbd "C-x C-q") 'delete-other-windows)
(global-set-key (kbd "C-x q") 'delete-window)

(global-set-key (kbd "C-X S-<left>") 'windmove-left)
(global-set-key (kbd "C-X S-<right>") 'windmove-right)
(global-set-key (kbd "C-X S-<up>") 'windmove-up)
(global-set-key (kbd "C-X S-<down>") 'windmove-down)

;;###-SOME TAB STUFF-###;;

(add-hook 'python-mode-hook
          (lambda ()
            (setq tab-width 2)
            (setq indent-tabs-mode nil)))

(setq indent-tabs-mode nil)
(setq-default tab-width 2)

(setq-default electric-indent-inhibit t)

;;###-FUN PACKAGE STUFF-###;;

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq package-enable-at-startup nil)
(straight-use-package 'use-package)

(defun org-setup ()
	(org-indent-mode)
	(org-CUA-compatible 1)
	(variable-pitch-mode 1)
	(auto-fill-mode 0)
	(visual-line-mode 1)
	(set-face-attribute 'default nil :family "Terminus" :height 140)
	(set-face-attribute 'mode-line nil :family "Terminus" :height 140))

(use-package org
	:straight t
	:ensure t
	:hook (org-mode . org-setup)
	:config
	(setq org-ellipsis " ▼"
				org-hide-emphasis-markers t))

(use-package org-bullets
	:after org
	:straight t
	:ensure t
	:hook (org-mode . org-bullets-mode)
	:custom
	(org-bullets-bullet-list '("‣" "◦" "•" "◦" "•" "◦" "•")))
 
(use-package org-roam
	:straight t
	:ensure t)

(use-package smartparens
	:straight t
  :ensure t
  :init
  (smartparens-global-mode 1))
 
(require 'smartparens-config)

(use-package starhugger
	:after company
	:straight (:type git :host github :repo "daanturo/starhugger.el")
	:init
	(setq starhugger-api-token "MY TOKEN YAY")
	;;(starhugger-auto-mode t)
	:config
	;; `starhugger-inline-menu-item' makes a conditional binding that is only active at the inline suggestion start
	(global-set-key (kbd "C-<tab>") 'starhugger-trigger-suggestion)
	(keymap-set starhugger-inlining-mode-map "<tab>" (starhugger-inline-menu-item #'starhugger-accept-suggestion))
	(keymap-set starhugger-inlining-mode-map "C-<tab>" (starhugger-inline-menu-item #'starhugger-dismiss-suggestion))
	(keymap-set starhugger-inlining-mode-map "M-[" (starhugger-inline-menu-item #'starhugger-show-prev-suggestion))
	(keymap-set starhugger-inlining-mode-map "M-]" (starhugger-inline-menu-item #'starhugger-show-next-suggestion))
	(keymap-set starhugger-inlining-mode-map "M-f" (starhugger-inline-menu-item #'starhugger-accept-suggestion-by-word)))


;;Needs auth on the official site
(use-package codeium
  :straight (:type git :host github :repo "Exafunction/codeium.el")
	:init
  ;; use globally
  (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
  ;; or on a hook
  ;; (add-hook 'python-mode-hook
  ;;     (lambda ()
  ;;         (setq-local completion-at-point-functions '(codeium-completion-at-point))))
	
  ;; if you want multiple completion backends, use cape (https://github.com/minad/cape):
  ;; (add-hook 'python-mode-hook
  ;;     (lambda ()
  ;;         (setq-local completion-at-point-functions
  ;;             (list (cape-super-capf #'codeium-completion-at-point #'lsp-completion-at-point)))))
  ;; an async company-backend is coming soon!
	
  ;; codeium-completion-at-point is autoloaded, but you can
  ;; optionally set a timer, which might speed up things as the
  ;; codeium local language server takes ~0.2s to start up
  (add-hook 'emacs-startup-hook
						(lambda () (run-with-timer 0.1 nil #'codeium-init)))
	
  ;; :defer t ;; lazy loading, if you want
  :config
  (setq use-dialog-box nil) ;; do not use popup boxes
	
  ;; if you don't want to use customize to save the api-key
  ;; (setq codeium/metadata/api_key "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")
	(setq codeium/metadata/api_key "TOKEN HERE")
    ;; get codeium status in the modeline
  (setq codeium-mode-line-enable
        (lambda (api) (not (memq api '(CancelRequest AcceptCompletion)))))
  ;;(add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
  ;; alternatively for a more extensive mode-line
  (add-to-list 'mode-line-format '(-50 "" codeium-mode-line) t)
	
  ;; use M-x codeium-diagnose to see apis/fields that would be sent to the local language server
    (setq codeium-api-enabled
					(lambda (api)
            (memq api '(GetCompletions CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))
    ;; you can also set a config for a single buffer like this:
    ;; (add-hook 'python-mode-hook
    ;;     (lambda ()
    ;;         (setq-local codeium/editor_options/tab_size 4)))
		
    ;; You can overwrite all the codeium configs!
    ;; for example, we recommend limiting the string sent to codeium for better performance
    (defun my-codeium/document/text ()
        (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
    ;; if you change the text, you should also change the cursor_offset
    ;; warning: this is measured by UTF-8 encoded bytes
    (defun my-codeium/document/cursor_offset ()
        (codeium-utf8-byte-length
            (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
    (setq codeium/document/text 'my-codeium/document/text)
    (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset))
  


;;Needs auth on the official site

(use-package company-tabnine
	:straight t
  :ensure t
  :after company
  :init
  (company-tabnine 1)
  (company-tabnine-restart-server)
  :config
  (add-to-list 'company-backends #'company-tabnine)
  )

(use-package ivy
	:straight t
  :diminish
  :config
  (ivy-mode 1))

(add-hook 'dired-mode-hook #'dired-hide-details-mode)

(use-package dired-sidebar
	:straight t
  :bind (("C-x t" . dired-sidebar-toggle-sidebar))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)

  (setq dired-sidebar-subtree-line-prefix "  ")
  (setq dired-sidebar-theme 'ascii)
  (setq dired-sidebar-width 25)
  
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font nil))


(add-hook 'dired-sidebar-mode-hook (lambda () (display-line-numbers-mode -1)))

(defun yafolding-toggle-parent-element()
  (interactive)
  (condition-case err
	  (yafolding-go-parent-element)
	(error))
  (yafolding-toggle-element)
  )

(use-package yafolding
	:straight t
  :ensure t
  :config
  (global-set-key (kbd "C-x C-a") 'yafolding-toggle-all)
  (global-set-key (kbd "C-x <C-S-return>") 'yafolding-hide-parent-element)
  (global-set-key (kbd "C-x C-<tab>") 'yafolding-toggle-parent-element)
  )

(add-hook 'prog-mode-hook
		  (lambda () (yafolding-mode)))

;(use-package corfu
;  :after orderless
;  :after company
;  :ensure t
;  :custom
;  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
;  (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
;  (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
;  (corfu-quit-no-match t)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; Enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.
  ;; This is recommended since Dabbrev can be used globally (M-/).
  ;; See also `corfu-exclude-modes'.
;  :init
;(global-corfu-mode))

(use-package dimmer
	:straight t
  :ensure t
  :config
  (dimmer-configure-which-key)
  (dimmer-configure-company-box)
  (dimmer-configure-org)
  (setq dimmer-adjustment-mode :foreground)
  (setq dimmer-use-colorspace :rgb)
  (setq dimmer-fraction 0.2)
  (dimmer-mode t))

(use-package powerline
	:straight t
  :ensure t
  :commands (powerline-default-theme)
  )

(use-package nerd-icons 
	:straight t
  :ensure t
  )

(powerline-default-theme)
(use-package undo-fu-session
	:straight t
	:ensure t
  :config
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'")))

(global-undo-fu-session-mode)

(use-package flycheck
	:straight t
  :ensure t)

(use-package lsp-mode
	:straight t
  :ensure t
  :commands (lsp lsp-deferred)
  :init (setq lsp-keymap-prefix "C-c l")
  :hook (((c++-mode c-mode python-mode css-mode html-mode js-mode) . lsp-deferred))
  :config
  (setq lsp-enable-snippet nil)
  (setq lsp-idle-delay 1.0)
  (setq lsp-diagnostics-engine :auto)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-diagnostics-severity-threshold '(error))
  (add-hook 'lsp-after-initialize-hook
            (lambda ()
              (when (derived-mode-p 'python-mode)
                (setq-local flycheck-checker 'python-pycompile)
                (setq-local flycheck-disabled-checkers '(lsp))
                (flycheck-mode)))))

(use-package lsp-ui
	:straight t
  :ensure t
  :config
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-use-webkit nil)
  (setq lsp-ui-doc-use-childframe t)
  (setq lsp-ui-doc-delay 0.0)
  (setq lsp-ui-doc-enhanced-markdown t)
  (setq lsp-ui-doc-position 'above)
  (setq lsp-ui-doc-show-with-cursor t)
  (setq lsp-ui-doc-show-with-mouse nil)
  (setq lsp-ui-sideline-show-code-actions t)
  (setq lsp-ui-sideline-delay 0.1)
  (setq lsp-ui-sideline-show-diagnostics t)
  )
 
(global-set-key ( kbd "C-x n") #'lsp-ui-peek-find-definitions)
(global-set-key ( kbd "C-x p") #'lsp-ui-peek-find-references)
;;(use-package lsp-ivy :commands lsp-ivy-global-workspace-symbol)
;;(use-package lsp-treemacs :commands lsp-treemacs-errors-list);;(use-package dap-mode)

(use-package rainbow-delimiters
	:straight t
	:ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
	:straight t
	:ensure t
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1.0))

;;(use-package yasnippet
;  :ensure t
;  :config
;  (yas-global-mode 1)
;  (company-yasnippet 1)
;  )
;(use-package yasnippet-snippets)

(use-package company
	:straight t
	:ensure t
  :defer 0.1
  :config
  (global-company-mode t)
  (setq-default
   company-minimum-prefix-length 1
   company-show-quick-access t
   company-idle-delay 0.05
   company-require-match nil
   
   ;; get only preview
   company-frontends '(company-preview-frontend)
   ;; also get a drop down
   company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend)
   ))
;(add-to-list 'completion-at-point-functions #'lsp-completion-at-point)
;(add-to-list 'completion-at-point-functions #'company-capf)
(add-to-list 'completion-at-point-functions #'codeium-completion-at-point)

(use-package beacon
	:straight t
  :ensure t
  :init
  (setq beacon-blink-duration 0.4
		beacon-color "royal blue"
		beacon-size 50)
  (beacon-mode t))

;;###-FUN THEME STUFF-###;;

(use-package rand-theme
	:straight t)
(use-package firecode-theme)
(use-package flatui-dark-theme)
(use-package danneskjold-theme)
(use-package ujelly-theme
	:straight t)
(use-package lush-theme
	:straight t)
(use-package majapahit-themes
	:straight t)
(use-package material-theme
	:straight t)
(use-package mellow-theme
	:straight t)
(use-package railscasts-theme
	:straight t)
(use-package spacegray-theme
	:straight t)
(use-package sublime-themes
	:straight t)
(use-package zen-and-art-theme
	:straight t)
(use-package yoshi-theme
	:straight t)
(use-package bubbleberry-theme
	:straight t)
(use-package colonoscopy-theme
	:straight t)
(use-package dream-theme
	:straight t)
(use-package kooten-theme
	:straight t)
(use-package cyberpunk-theme)
(use-package clues-theme)
(use-package cherry-blossom-theme)
(use-package almost-mono-themes)
(use-package badwolf-theme)
(use-package badger-theme)
(use-package creamsody-theme)
(use-package dakrone-theme)
(use-package dark-krystal-theme)
(use-package distinguished-theme)
(use-package dream-theme)
(use-package flatland-black-theme)
(use-package grandshell-theme)
(use-package hemisu-theme)
(use-package purple-haze-theme)
(use-package quasi-monochrome-theme)


(if (and (>= (string-to-number (format-time-string "%H")) 9)
         (< (string-to-number (format-time-string "%H")) 20))
    (setq rand-theme-wanted '(bubbleberry mellow brin))
  (setq rand-theme-wanted '(junio ujelly)))
;;Dark mode themes

;;(setq rand-theme-wanted '(firecode clues badwolf badger dakrone purple-haze almost-mono-gray))

;;Black mode themes

;;(setq rand-theme-wanted '(cyberpunk distinguished cherry-blossom hemisu-dark flatland-black danneskjold almost-mono-black flatui-dark grandshell quasi-monochrome))

;;All themes

;;(setq rand-theme-wanted '(firecode clues badwolf badger dakrone purple-haze almost-mono-gray cyberpunk distinguished cherry-blossom hemisu-dark flatland-black danneskjold almost-mono-black flatui-dark grandshell quasi-monochrome))

;;Uncomment rand-theme to have themes be randomized
;;If you do dont forge to uncomment one of the theme sets

(rand-theme)

;;Nice little thing that allows you to have different themes at night and day
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
	 '((eval face-remap-add-relative 'default
					 '(:family "Terminus" :height 140))
		 (eval face-remap-add-relative 'default
					 '(:family "Terminus" :height 140 :background "black"))))
 '(w3m-use-tab-line nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
