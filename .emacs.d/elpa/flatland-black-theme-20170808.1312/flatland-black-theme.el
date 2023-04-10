;;; flatland-black-theme.el --- an Emacs 24 theme based on Flatland Black (tmTheme)
;;
;;; Author: Jason Milkins
;;; Version: 20141116
;; Package-Version: 20170808.1312
;; Package-Commit: 348c5d5fe615e6ea13cadc17f046e506e789ce07
;;; Url: https://github.com/emacsfodder/flatland-black-theme
;;; Package-Requires: ((emacs "24.0"))
;;
;;; Commentary:
;;  This theme was automatically generated by tmtheme-to-deftheme (tm2deftheme),
;;  from Flatland Black (tmTheme)
;;
;;; Licence: MIT
;;; Code:

(deftheme flatland-black
  "flatland-black-theme - Created by tmtheme-to-deftheme - 2014-11-16 10:26:37 +0800")

(custom-theme-set-variables
 'flatland-black
)

(custom-theme-set-faces
 'flatland-black
 ;; basic theming.

 '(default ((t (:foreground "#F8F8F8" :background "#000000" ))))
 '(region  ((t (:background "#515559"))))
 '(cursor  ((t (:background "#BBBCBD"))))

 ;; Temporary defaults
 '(linum                               ((t (:foreground "#323232"  :background "#191919" ))))
 '(fringe                              ((t (                       :background "#191919" ))))

 '(minibuffer-prompt                   ((t (:foreground "#1278A8"  :background nil       :weight bold                                  ))))
 '(escape-glyph                        ((t (:foreground "orange"   :background nil                                                     ))))
 '(highlight                           ((t (:foreground "orange"   :background nil                                                     ))))
 '(shadow                              ((t (:foreground "#777777"  :background nil                                                     ))))

 '(trailing-whitespace                 ((t (:foreground "#FFFFFF"  :background "#C74000"                                               ))))
 '(link                                ((t (:foreground "#00b7f0"  :background nil       :underline t                                  ))))
 '(link-visited                        ((t (:foreground "#4488cc"                        :underline t :inherit (link)                  ))))
 '(button                              ((t (:foreground "#FFFFFF"  :background "#444444" :underline t :inherit (link)                  ))))
 '(next-error                          ((t (                                             :inherit (region)                             ))))
 '(query-replace                       ((t (                                             :inherit (isearch)                            ))))
 '(header-line                         ((t (:foreground "#EEEEEE"  :background "#444444" :box nil :inherit (mode-line)                 ))))

 '(mode-line-highlight                 ((t (                                             :box nil                                      ))))
 '(mode-line-emphasis                  ((t (                                             :weight bold                                  ))))
 '(mode-line-buffer-id                 ((t (                                             :box nil :weight bold                         ))))

 '(mode-line-inactive                  ((t (:foreground "#c6c6c6"  :background "#191919" :box nil :weight light :inherit (mode-line)   ))))
 '(mode-line                           ((t (:foreground "#f8f8f8"  :background "#191919" :box nil ))))

 '(isearch                             ((t (:foreground "#99ccee"  :background "#444444"                                               ))))
 '(isearch-fail                        ((t (                       :background "#ffaaaa"                                               ))))
 '(lazy-highlight                      ((t (                       :background "#77bbdd"                                               ))))
 '(match                               ((t (                       :background "#3388cc"                                               ))))

 '(tooltip                             ((t (:foreground "black"    :background "LightYellow" :inherit (variable-pitch)                 ))))

 '(js3-function-param-face             ((t (:foreground "#BFC3A9"                                                                      ))))
 '(js3-external-variable-face          ((t (:foreground "#F0B090"  :bold t                                                             ))))

 '(secondary-selection                 ((t (                       :background "#342858"                                               ))))
 '(cua-rectangle                       ((t (:foreground "#E0E4CC"  :background "#342858" ))))

 ;; Magit hightlight
 '(magit-item-highlight                ((t (:foreground "white" :background "#1278A8" :inherit nil ))))

 ;; flyspell-mode
 '(flyspell-incorrect                  ((t (:underline "#AA0000" :background nil :inherit nil ))))
 '(flyspell-duplicate                  ((t (:underline "#009945" :background nil :inherit nil ))))

 ;; flymake-mode
 '(flymake-errline                     ((t (:underline "#AA0000" :background nil :inherit nil ))))
 '(flymake-warnline                    ((t (:underline "#009945" :background nil :inherit nil ))))

 ;;git-gutter
 '(git-gutter:added                    ((t (:foreground "#609f60" :bold t))))
 '(git-gutter:modified                 ((t (:foreground "#3388cc" :bold t))))
 '(git-gutter:deleted                  ((t (:foreground "#cc3333" :bold t))))

 '(diff-added                          ((t (:background "#305030"))))
 '(diff-removed                        ((t (:background "#903010"))))
 '(diff-file-header                    ((t (:background "#362145"))))
 '(diff-context                        ((t (:foreground "#E0E4CC"))))
 '(diff-changed                        ((t (:foreground "#3388cc"))))
 '(diff-hunk-header                    ((t (:background "#242130"))))


 '(font-lock-comment-face ((t (:foreground "#798188"  ))))
 '(font-lock-constant-face ((t (:foreground "#b8d977"  ))))
 '(font-lock-type-face ((t (:foreground "#72AACA"  ))))
 '(font-lock-keyword-face ((t (:foreground "#fa9a4b"  ))))
 '(font-lock-string-face ((t (:foreground "#C4E2F2"  ))))
 '(font-lock-variable-name-face ((t (:foreground "#FB9A4B"  ))))
 '(diff-removed ((t (:foreground "#EB939A" :background "#D03620" ))))
 '(diff-changed ((t (:foreground "#72AACA" :background "#C4B14A" ))))
 '(diff-added ((t (:foreground "#B7D877" :background "#41A83E" ))))
 '(git-gutter:deleted ((t (:foreground "#EB939A"  ))))
 '(git-gutter:modified ((t (:foreground "#72AACA"  ))))
 '(git-gutter:added ((t (:foreground "#B7D877"  ))))
 '(git-gutter:untracked ((t (:foreground "#798188"  ))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#798188"  ))))

;; Rainbow delimiters
 '(rainbow-delimiters-depth-1-face ((t (:foreground "#555b60"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "#5d6469"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "#666d73"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "#6e767d"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "#777f86"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "#80888f"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "#8a9197"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "#949aa0"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "#9da3a8"))))
 '(rainbow-delimiters-unmatched-face ((t (:foreground "#FF0000"))))
) ;; End face definitions

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'flatland-black)

;; Local Variables:
;; eval: (when (fboundp 'rainbow-mode) (rainbow-mode +1))
;; End:

;;; flatland-black-theme.el ends here
