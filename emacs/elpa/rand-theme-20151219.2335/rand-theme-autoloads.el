;;; rand-theme-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "rand-theme" "rand-theme.el" (0 0 0 0))
;;; Generated autoloads from rand-theme.el

(autoload 'rand-theme "rand-theme" "\
Randomly pick a theme from `rand-theme-unwanted' or if non-nil from `rand-theme-wanted'.
Will raise error if both of these variables are nil." t nil)

(autoload 'rand-theme-iterate "rand-theme" "\
Iterate through the list of themes.
In case you want to go incremental." t nil)

(autoload 'rand-theme-iterate-backwards "rand-theme" "\
Iterate backwards through list of themes.
In case you accidentally pass the theme you wanted." t nil)

(register-definition-prefixes "rand-theme" '("rand-theme-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; rand-theme-autoloads.el ends here
