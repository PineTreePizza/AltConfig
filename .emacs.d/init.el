(setq inhibit-startup-message t)
;; TAB cycle if there are only few candidates
(setq completion-cycle-threshold 5)
(setq package-check-signature nil)
(setq package-check-signature "allow-unsigned")
;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
;; Corfu commands are hidden, since they are not supposed to be used via M-x.
;; (setq read-extended-command-predicate
;;       #'command-completion-default-include-p)

;; Enable indentation+completion using the TAB key.
;; `completion-at-point' is often bound to M-TAB.
(setq tab-always-indent 'complete)
(scroll-bar-mode  1)
(tool-bar-mode -1)
(tooltip-mode  -1)
(set-fringe-mode 20)
(global-display-line-numbers-mode 1)
(line-number-mode 1)
(electric-pair-mode 1)
(add-to-list 'default-frame-alist '(font . "SourceCodePro 12" ))
(set-face-attribute 'default t :font "SourceCodePro 12" )
(setq electric-pair-pairs
      '(
	(?\' . ?\')
	(?\{ . ?\})
	(?\( . ?\))
	))
(global-set-key (kbd "C-A") 'mark-whole-buffer)
(global-set-key (kbd "M-<right>") 'next-buffer)
(global-set-key (kbd "M-<left>") 'previous-buffer)
(global-set-key (kbd "M-q") 'quit-window)
(global-set-key (kbd "C-M-q") 'kill-buffer-and-window)

;;(add-to-list 'load-path "~/.emacs.d/elpa/tabnine-capf/")
;;(require 'tabnine-capf)
;;(add-to-list 'completion-at-point-functions #'tabnince-completion-at-point)

(when (not package-archive-contents)
    (package-refresh-contents))

(add-to-list 'load-path "~/.emacs.d/elpa/codeium/")
(require 'codeium)
(use-package codeium 
  :load-path  "~/.emacs.d/elpa/codeium/"
    ;; if you use straight
    ;; :straight '(:type git :host github :repo "Exafunction/codeium.el")
    ;; otherwise, make sure that the codeium.el file is on load-path

    :init
    ;; use globally
    (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
    (codeium-init)
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
    ;; (add-hook 'emacs-startup-hook
    ;;  (lambda () (run-with-timer 0.1 nil #'codeium-init)))

    ;; :defer t ;; lazy loading, if you want
  :defer nil
  :config
  (setq use-dialog-box nil) ;; do not use popup boxes

  ;; get codeium status in the modeline
  (setq codeium-mode-line-enable
        (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
  (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
  ;; alternatively for a more extensive mode-line
  ;(add-to-list 'mode-line-format '(-50 "" codeium-mode-line) t)

  ;; use M-x codeium-diagnose to see apis/fields that would be sent to the local language server
  (setq codeium-api-enabled
        (lambda (api)
          (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))

  ;; You can overwrite all the codeium configs!
  ;; for example, we recommend limiting the string sent to codeium for better performance
  (defun my-codeium/document/text ()
    (buffer-substring-no-properties (max (- (point) 500) (point-min)) (min (+ (point) 10) (point-max))))
  ;; if you change the text, you should also change the cursor_offset
  ;; warning: this is measured by UTF-8 encoded bytes
  (defun my-codeium/document/cursor_offset ()
    (codeium-utf8-byte-length
     (buffer-substring-no-properties (max (- (point) 500) (point-min)) (point))))
  (setq codeium/document/text 'my-codeium/document/text)
  (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset))


(use-package company
   :defer t
   :config
   (setq-default
    company-idle-delay 0.2
    company-require-match nil
    company-minimum-prefix-length 0
    
    ;; get only preview
    company-frontends '(company-preview-frontend)
    ;; also get a drop down
;;    company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend)
    ))



(use-package company-tabnine :ensure t)
(require 'company-tabnine)
(setq company-tabnine 1)
(global-set-key (kbd "C-q") 'kill-whole-line)
(add-to-list 'company-backends #'company-tabnine)
;;Trigger completion immediately.
(setq company-idle-delay 0.2)



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
  (lsp-enable-which-key-integration t)
)

;(use-package lsp-ivy :commands lsp-ivy-global-workspace-symbol)
;(use-package lsp-treemacs :commands lsp-treemacs-errors-list);;(use-package dap-mode)
;(use-package which-key
;  :config
;  (which-key-mode))

(setq-default electric-indent-inhibit t)
(defun enable-tabs  ()
  (global-set-key (kbd "TAB") 'tab-to-tab-stop)
  (setq indent-tabs-mode t)
  (setq tab-width custom-tab-width))

(defun set-newline-and-indent ()
  (global-set-key (kbd "RET") 'newline-and-indent))
(add-hook 'lisp-mode-hook 'set-newline-and-indent)

(setq-default cursor-type '(bar . 2))
(menu-bar-mode -1)
(cua-mode 1)

(setq visible-bell t)

(global-set-key (kbd "C-Z") 'undo)
(global-set-key (kbd "C-S-z") 'undo-redo)

(defun escapecommands ()
  (interactive)
  (keyboard-escape-quit))

(global-set-key (kbd "C-c a b c") 'my-run-some-commands)

(global-set-key (kbd "<escape>") 'escapecommands)

(defadvice keyboard-escape-quit
    (around keyboard-escape-quit-dont-close-windows activate)
  (let ((buffer-quit-function (lambda () ())))
    ad-do-it))
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stalbe if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("elpa-gnu" . "https://elpa.gnu.org/packages/") t)
;;(unless package-archive-contents
 ;; (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(require 'org-ai)
(org-ai-global-mode 1)
(use-package org-ai
  :ensure
  :commands (org-ai-mode)
  :custom
  (org-ai-openai-api-token "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")
  :init
  (add-hook 'org-mode-hook #'org-ai-global-mode)
  :config
  (org-ai-install-yasnippets))

(use-package ivy
  :diminish
  :config
  (ivy-mode 1))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package dired-sidebar
  :ensure t
  :commands (dired-sidebar-toggle-sidebar))
(global-set-key (kbd "C-x t") 'dired-sidebar-toggle-sidebar)


;; Number the candidates (use M-1, M-2 etc to select completions).
(setq company-show-quick-access t)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1.0))
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
;;dark mode themes
;;(setq rand-theme-wanted '(firecode clues badwolf badger creamsody dakrone purple-haze almost-mono-gray))

;;black mode themes
(setq rand-theme-wanted '(cyberpunk distinguished cherry-blossom hemisu-dark flatland-black danneskjold almost-mono-black flatui-dark grandshell quasi-monochrome))
(rand-theme)

;;(load-theme 'creamsody t)

(require 'yasnippet)
(yas-global-mode 1)
(company-yasnippet 1)

(global-set-key (kbd "C-;") 'compile)(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(codeium/metadata/api_key "5f8d682d-d35e-4e12-a8fb-3d16cfa3194b")
 '(custom-safe-themes
   '("1cd4df5762b3041a09609b5fb85933bb3ae71f298c37ba9e14804737e867faf3" "c3957b559cf3606c9a40777c5712671db3c7538e5d5ea9f63eb0729afeac832b" "d0fd069415ef23ccc21ccb0e54d93bdbb996a6cce48ffce7f810826bb243502c" "16ab866312f1bd47d1304b303145f339eac46bbc8d655c9bfa423b957aa23cc9" "cb8b94bca7576a8552734086b32dc1a963b91c4c8b8dac95f335f5ce7e6f9dae" "130b47ad4ea2bc61b79e13ecb4a6e6b30351de0fea02e757f074477aa744128b" "0d23ecaa8eb7cc7b6c303c484677a6cbb85a7847e1840b1c5cd6b9477f11df9e" "7feeed063855b06836e0262f77f5c6d3f415159a98a9676d549bfeb6c49637c4" "77bd459212c0176bdf63c1904c4ba20fce015f730f0343776a1a14432de80990" "bd82c92996136fdacbb4ae672785506b8d1d1d511df90a502674a51808ecc89f" "738c4838957c1884dfacbb6f4f783c54e87c4a6b31c336d6279fc1c2b2ee56c5" "7c20c453ad5413b110ccc3bb5df07d69999d741d29b1f894bd691f52b4abdd31" "c7b8dbc62bf969295d0068d8dcb47bd1832d9c466bd76ddc6ac325b93cbdf7c6" "6b6bad9d7a844d5de02761a1bd155869512f47bd6a7b14d799eea5c37f08ead4" "e7ba99d0f4c93b9c5ca0a3f795c155fa29361927cadb99cfce301caf96055dfd" default))
 '(package-selected-packages
   '(gnu-elpa-keyring-update yasnippet-snippets ivy-yasnippet yasnippet org-ai codeium kind-icon emacs cape corfu tabnine-capf dap-LANGUAGE undo-fu-session crux focus lsp-intellij cmake-mode lsp-ui dap-cpptools dap-c dap-c++ dap-mode lsp-cfn lsp-mode lsp-ivy auto-auto-indent dark-krystal-theme dakrone-theme creamsody-theme company-tabnine dired-sidebar company-lua nasm-mode flymake-nasm firecode-theme flatui-dark-theme dream-theme danneskjold-theme cyberpunk-theme clues-theme cherry-blossom-theme almost-mono-themes badwolf-theme badger-theme avk-emacs-themes rand-theme twilight-theme which-key rainbow-delimiters auto-dark flycheck-clang-tidy flycheck electric-pair electric-pair-mode auto-complete-clang centaur-tabs company-lsp company use-package ivy doom-modeline ccls)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



