(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-command "latex --shell-escape -synctex=1")
 '(TeX-view-program-selection
   (quote
	(((output-dvi has-no-display-manager)
	  "dvi2tty")
	 ((output-dvi style-pstricks)
	  "dvips and gv")
	 (output-dvi "xdvi")
	 (output-pdf "PDF Tools")
	 (output-html "xdg-open"))))
 '(custom-safe-themes
   (quote
	("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(highlight-symbol-idle-delay 0.5)
 '(rainbow-delimiters-max-face-count 8)
 '(recentf-exclude
   (quote
	("/\\(\\(\\(COMMIT\\|NOTES\\|PULLREQ\\|TAG\\)_EDIT\\|MERGE_\\|\\)MSG\\|BRANCH_DESCRIPTION\\)\\'" "ido.last" "\\.emacs\\.d/elpa/")))
 '(recentf-keep (quote ("init.el" recentf-keep-default-predicate)))
 '(safe-local-variable-values (quote ((cmake-ide-dir . "build")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#141622" :foreground "gray85" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "PfEd" :family "DejaVu Sans Mono"))))
 '(font-lock-c++-namespace-face ((t (:foreground "khaki"))))
 '(font-lock-comment-delimiter-face ((t (:foreground "medium spring green"))))
 '(font-lock-comment-face ((t (:foreground "medium spring green"))))
 '(font-lock-constant-face ((t (:foreground "LightCoral"))))
 '(font-lock-function-name-face ((t (:foreground "goldenrod"))))
 '(font-lock-keyword-face ((t (:foreground "dark turquoise" :weight bold))))
 '(font-lock-magic-numbers-face ((t (:foreground "light coral"))))
 '(font-lock-operator-face ((t (:foreground "goldenrod"))))
 '(font-lock-preprocessor-face ((t (:foreground "magenta"))))
 '(font-lock-string-face ((t (:foreground "dark gray"))))
 '(font-lock-type-face ((t (:foreground "deep sky blue" :slant italic))))
 '(font-lock-variable-name-face ((t (:foreground "white"))))
 '(outline-1 ((t (:foreground "dark violet"))))
 '(outline-2 ((t (:foreground "royal blue"))))
 '(outline-3 ((t (:foreground "sky blue"))))
 '(outline-4 ((t (:foreground "spring green"))))
 '(outline-5 ((t (:foreground "forest green"))))
 '(outline-6 ((t (:foreground "green yellow"))))
 '(outline-7 ((t (:foreground "orange"))))
 '(outline-8 ((t (:foreground "orange red"))))
 '(rainbow-delimiters-depth-1-face ((t (:inherit outline-1))))
 '(rainbow-delimiters-depth-2-face ((t (:inherit outline-2))))
 '(rainbow-delimiters-depth-3-face ((t (:inherit outline-3))))
 '(rainbow-delimiters-depth-4-face ((t (:inherit outline-4))))
 '(rainbow-delimiters-depth-5-face ((t (:inherit outline-5))))
 '(rainbow-delimiters-depth-6-face ((t (:inherit outline-6))))
 '(rainbow-delimiters-depth-7-face ((t (:inherit outline-7))))
 '(rainbow-delimiters-depth-8-face ((t (:inherit outline-8)))))
