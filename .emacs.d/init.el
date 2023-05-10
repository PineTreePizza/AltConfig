;;###-INITIAL SET UP-###;;
(setq inhibit-startup-message t)
(setq completion-cycle-threshold 3)
(scroll-bar-mode  1)
(tool-bar-mode -1)
(tooltip-mode  -1)
(add-hook 'prog-mode-hook 'display-line-numbers-mode 1)
(set-fringe-mode 10)
(electric-pair-mode -1)
(set-face-attribute 'default nil :font "Terminus 14")
(set-frame-font 'default nil :font "Terminus 14")
(setq-default track-mouse nil)
;;Set the cursor to a bar with the width of 2
(setq-default cursor-type '(bar . 2))
(menu-bar-mode -1)
(cua-mode 1)
(setq visible-bell t)

;;###-BASIC KEY BINDS-###;;

(global-set-key (kbd "C-A") 'mark-whole-buffer)
(global-set-key (kbd "M-<right>") 'next-buffer)
(global-set-key (kbd "M-<left>") 'previous-buffer)
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-;") 'compile)

(setq scroll-step 2)  ; Set the amount of scrolling

(defun split-window-vertically-up-and-create-empty-buffer ()
  "Splits the current window and creates an empty buffer in the new window."
  (interactive)
  (split-window-vertically)
  (switch-to-buffer "*scratch"))

(defun split-window-vertically-down-and-create-empty-buffer ()
  "Splits the current window and creates an empty buffer in the new window."
  (interactive)
  (split-window-vertically)
  (other-window 1)
  (switch-to-buffer "*scratch")
  )

(defun split-window-horizontally-right-and-create-empty-buffer ()
  "Splits the current window and creates an empty buffer in the new window."
  (interactive)
  (split-window-horizontally)
  (other-window 1)
  (switch-to-buffer "*scratch"))

(defun split-window-horizontally-left-and-create-empty-buffer ()
  "Splits the current window and creates an empty buffer in the new window."
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
  (let ((buffer-quit-function (lambda () ())))
    ad-do-it))

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

(windmove-default-keybindings)
(global-set-key (kbd "C-X S-<left>") 'windmove-left)
(global-set-key (kbd "C-X S-<right>") 'windmove-right)
(global-set-key (kbd "C-X S-<up>") 'windmove-up)
(global-set-key (kbd "C-X S-<down>") 'windmove-down)

;;###-SOME TAB STUFF-###;;

(add-hook 'python-mode-hook 'guess-style-guess-tabs-mode)
(add-hook 'python-mode-hook (lambda ()
							  (guess-style-guess-tab-width)
                              (setq-default indent-tabs-mode t)
                              (setq-default tab-width 4)))

(setq-default tab-width 4)

(setq-default electric-indent-inhibit t)

;;###-FUN PACKAGE STUFF-###;;

(require 'package)

(setq package-check-signature nil)

(add-to-list 'package-archives
			 '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
			 '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
			 '("elpa-gnu" . "https://elpa.gnu.org/packages/") t)

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(package-initialize)

(require 'use-package)
;;(unless package-archive-contents
;; (package-refresh-contents))

										;(unless (package-installed-p 'use-package)
										;  (package-install 'use-package))

(setq use-package-always-ensure t)

(when (not package-archive-contents)
  (package-refresh-contents))


(use-package smartparens
  :ensure t
  :config
  (smartparens-global-mode 1))
 
(require 'smartparens-config)

;;Needs auth on the official site
;;Also this loads very jankily if you use my config download codeium.el from github and create a codeium folder-
;;-in .emacs.d/elpa and just put it's contents in there and you should be good 
(add-to-list 'load-path "~/.emacs.d/elpa/codeium/")
(require 'codeium)
(use-package codeium
  :load-path "~/.emacs.d/elpa/codeium/codeium.el"

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
  :ensure t
  :after company
  :init
  (company-tabnine 1)
  :config
  (add-to-list 'company-backends #'company-tabnine)
  )

(use-package ivy
  :diminish
  :config
  (ivy-mode 1))

(add-hook 'dired-mode-hook #'dired-hide-details-mode)

(use-package dired-sidebar
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
  :ensure t
  :commands (powerline-default-theme)
  )

(powerline-default-theme)
(use-package undo-fu-session
  :config
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'")))

(global-undo-fu-session-mode)


(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook(
		(c++-mode . lsp-deferred)
		(c-mode . lsp-deferred)
		(python-mode . lsp-deferred)
		(css-mode . lsp-deferred)
		(html-mode . lsp-deferred)
		(js-mode . lsp-deferred)
		)
  :config
  (setq lsp-idle-delay 0.500)
  (setq lsp-ui-doc-show-with-mouse nil)
  (setq lsp-ui-doc-show-with-cursor nil)
  (setq lsp-diagnostics-provider :none)
  (setq lsp-headerline-breadcrumb-enable nil)
  (lsp-enable-which-key-integration t)
  )

										;(use-package lsp-ivy :commands lsp-ivy-global-workspace-symbol)
										;(use-package lsp-treemacs :commands lsp-treemacs-errors-list);;(use-package dap-mode)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1.0))

;(use-package yasnippet
;  :ensure t
;  :config
;  (yas-global-mode 1)
;  (company-yasnippet 1)  
;  )

(use-package company
  :defer 0.1
  :config
  (global-company-mode t)
  (setq-default
   company-show-quick-access t
   company-idle-delay 0.05
   company-require-match nil
   company-minimum-prefix-length 0
   
   ;; get only preview
   company-frontends '(company-preview-frontend)
   ;; also get a drop down
   company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend)
   ))
;(add-to-list 'completion-at-point-functions #'lsp-completion-at-point)
;(add-to-list 'completion-at-point-functions #'company-capf)
(add-to-list 'completion-at-point-functions #'codeium-completion-at-point)

(use-package beacon
  :ensure t
  :init
  (beacon-blink-duration 0.4)
  (beacon-color "royal blue")
  (beacon-size 50)
  (beacon-mode t))

;;###-FUN THEME STUFF-###;;

(require 'rand-theme)
(use-package firecode-theme)
(use-package flatui-dark-theme)
(use-package danneskjold-theme)
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

;;Dark mode themes

;;(setq rand-theme-wanted '(firecode clues badwolf badger dakrone purple-haze almost-mono-gray))

;;Black mode themes

;;(setq rand-theme-wanted '(cyberpunk distinguished cherry-blossom hemisu-dark flatland-black danneskjold almost-mono-black flatui-dark grandshell quasi-monochrome))

;;All themes

;;(setq rand-theme-wanted '(firecode clues badwolf badger dakrone purple-haze almost-mono-gray cyberpunk distinguished cherry-blossom hemisu-dark flatland-black danneskjold almost-mono-black flatui-dark grandshell quasi-monochrome))

;;Uncomment rand-theme to have themes be randomized
;;If you do dont forge to uncomment one of the theme sets

;;(rand-theme)

;;Nice little thing that allows you to have different themes at night and day

(let ((hour (string-to-number (format-time-string "%H"))))
  (if (and (>= hour 9) (< hour 20))
      (load-theme 'badwolf t)
    (load-theme 'distinguished t)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("1cd4df5762b3041a09609b5fb85933bb3ae71f298c37ba9e14804737e867faf3" "c3957b559cf3606c9a40777c5712671db3c7538e5d5ea9f63eb0729afeac832b" "d0fd069415ef23ccc21ccb0e54d93bdbb996a6cce48ffce7f810826bb243502c" "16ab866312f1bd47d1304b303145f339eac46bbc8d655c9bfa423b957aa23cc9" "cb8b94bca7576a8552734086b32dc1a963b91c4c8b8dac95f335f5ce7e6f9dae" "130b47ad4ea2bc61b79e13ecb4a6e6b30351de0fea02e757f074477aa744128b" "0d23ecaa8eb7cc7b6c303c484677a6cbb85a7847e1840b1c5cd6b9477f11df9e" "7feeed063855b06836e0262f77f5c6d3f415159a98a9676d549bfeb6c49637c4" "77bdx459212c0176bdf63c1904c4ba20fce015f730f0343776a1a14432de80990" "bd82c92996136fdacbb4ae672785506b8d1d1d511df90a502674a51808ecc89f" "738c4838957c1884dfacbb6f4f783c54e87c4a6b31c336d6279fc1c2b2ee56c5" "7c20c453ad5413b110ccc3bb5df07d69999d741d29b1f894bd691f52b4abdd31" "c7b8dbc62bf969295d0068d8dcb47bd1832d9c466bd76ddc6ac325b93cbdf7c6" "6b6bad9d7a844d5de02761a1bd155869512f47bd6a7b14d799eea5c37
 )
