;;; lsp-cfn-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "lsp-cfn" "lsp-cfn.el" (0 0 0 0))
;;; Generated autoloads from lsp-cfn.el

(autoload 'lsp-cfn-snippets-initialize "lsp-cfn" "\
Load the `lsp-cfn-snippets' snippets directory." nil nil)

(with-eval-after-load 'yasnippet (lsp-cfn-snippets-initialize))

(register-definition-prefixes "lsp-cfn" '("lsp-cfn-"))

;;;***

;;;### (autoloads nil nil ("lsp-cfn-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; lsp-cfn-autoloads.el ends here
