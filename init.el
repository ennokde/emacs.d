;;; init-file --- THE init file of all times
;;; Commentary:
;;; Flycheck can really be pedantic about some style things...
;;; Code:

;; (add-to-list 'load-path "~/.emacs.d/elpa/benchmark-init-20150905.238/")
;; (require 'benchmark-init)

;poor man's benchmark
(defvar damn-init
  '()
  "An important list.")

(defun take-time (text)
  "Take the damn time and some TEXT."
  (push (cons text (current-time)) damn-init))

(take-time "Start of Init")

(defun print-time ()
  "Print results of timing."
  (let* ((thelist (reverse damn-init))
		 (prev (car thelist)))
	(dolist (curr thelist)
	  (message "%s -> %s : %s"
			   (car prev)
			   (car curr)
			   (format-time-string "%S.%3N" (time-subtract (cdr curr) (cdr prev))))
	  (setq prev curr))))

;; recompile configs on emacs shutdown
;(add-hook 'kill-emacs-hook (lambda () (byte-recompile-directory my-init-dir 0 t)))

(setf gc-cons-threshold 100000000); "turn off" gabage collection during init
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq initial-major-mode 'fundamental-mode)

(require 'package)
(take-time "require package")
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)
(take-time "package-initialize")

;; bootstrap utils

(defconst my-custom-file "~/.emacs.d/custom.el")

(setq custom-file my-custom-file)
(load my-custom-file t)
(setq make-backup-files nil)
(put 'erase-buffer 'disabled nil)

;(load-theme 'deeper-blue t)
(setq frame-title-format '("" "%b - Emacs " emacs-version))
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
;; start Emacs server
(require 'server)
(unless (server-running-p)
  (server-start))
(take-time "server start")

;; get use-/req-package
(defun require-package (package)
  "refresh package archives, check package presence and install if it's not installed"
  (if (null (require package nil t))
      (progn (let* ((ARCHIVES (if (null package-archive-contents)
                                  (progn (package-refresh-contents)
                                         package-archive-contents)
                                package-archive-contents))
                    (AVAIL (assoc package ARCHIVES)))
               (if AVAIL
                   (package-install package)))
             (require package))))

(require-package 'use-package)
(take-time "get use-package")
(require 'use-package)
(setq use-package-verbose t)
(setq use-package-minimum-reported-time 0.001)
(take-time "require use-package")

(require-package 'req-package)
(require 'req-package)
(take-time "require req-package")

;; basics needed for a good part of the rest of the config
(req-package-force key-chord
  :config
  (key-chord-mode 1)
  (setq key-chord-two-keys-delay 0.3))

(req-package-force use-package-chords)

(req-package-force hydra
  :config (progn (setq hydra-is-helpful t)))
(take-time "other basics")

;;;;;;;;;;;
;; Looks ;;
;;;;;;;;;;;

(tool-bar-mode -1)

;; fix colors on console
(req-package color-theme-approximate
  :if (not (display-graphic-p))
  :config (color-theme-approximate-on))

;; scrolling
(scroll-bar-mode -1) ;broken for me, plus i should not need it anyway
(setq mouse-wheel-progressive-speed nil)
(req-package smooth-scrolling
  :config
  (setq scroll-conservatively 9999
		scroll-step 1
		scroll-margin 5))

(req-package nyan-mode
  :defer 4
  :config (nyan-mode))

;; cursor
(setq-default cursor-type 'bar)
(blink-cursor-mode -1)

;; mode line
(column-number-mode t)
(req-package smart-mode-line
  :config
  (setq sml/shorten-modes t)
  (setq sml/shorten-directory t)
  (setq sml/name-width 20)
  (setq sml/mode-width 'full)
  (setq sml/hidden-modes nil)
  (setq sml/theme nil)
  (sml/setup)
  (load-theme 'smart-mode-line-dark t))

(req-package anzu
  :require smart-mode-line
  :diminish anzu-mode
  :config (global-anzu-mode 1))

;; miscellenous
(setq make-pointer-invisible nil)
(tooltip-mode -1)

;; yay parens!
(show-paren-mode t)

(req-package rainbow-delimiters
  :commands rainbow-delimiters-mode
  :init
  (custom-set-variables '(rainbow-delimiters-max-face-count 8))
  (custom-set-faces '(rainbow-delimiters-depth-1-face ((t (:inherit outline-1)))))
  (custom-set-faces '(rainbow-delimiters-depth-2-face ((t (:inherit outline-2)))))
  (custom-set-faces '(rainbow-delimiters-depth-3-face ((t (:inherit outline-3)))))
  (custom-set-faces '(rainbow-delimiters-depth-4-face ((t (:inherit outline-4)))))
  (custom-set-faces '(rainbow-delimiters-depth-5-face ((t (:inherit outline-5)))))
  (custom-set-faces '(rainbow-delimiters-depth-6-face ((t (:inherit outline-6)))))
  (custom-set-faces '(rainbow-delimiters-depth-7-face ((t (:inherit outline-7)))))
  (custom-set-faces '(rainbow-delimiters-depth-8-face ((t (:inherit outline-8)))))
  (req-package-hooks-add-execute 'emacs-lisp-mode (lambda () (rainbow-delimiters-mode 1))))

(defface font-lock-magic-numbers-face
  '((t (:foreground "red")))
  "Basic face for highlighting."
  :group 'basic-faces)

(font-lock-add-keywords 'c++-mode
						'(("[^[:alpha:]]\\([0-9]+\\)" 1 'font-lock-magic-numbers-face)))

(defface font-lock-c++-namespace-face
  '((t (:foreground "khaki")))
  "Basic face for highlighting."
  :group 'basic-faces)

(font-lock-add-keywords 'c++-mode
						'(("\\(\\w+\\)::" 1 'font-lock-c++-namespace-face)))

(defface font-lock-operator-face
  '((t (:foreground "gold")))
  "Basic face for highlighting."
  :group 'basic-faces)

(font-lock-add-keywords 'c++-mode
						'(("\\([~^&\|!:=,.<>\\?\\+*/%-]\\)" 1 'font-lock-operator-face)))

(take-time "looks")
;;;;;;;;;;;;;
;; General ;;
;;;;;;;;;;;;;
(delete-selection-mode t) ;because writing behind the junk I marked is weird
(fset 'yes-or-no-p 'y-or-n-p) ;type less
(setq auto-save-default nil) ;auto-save considered harmful
(setq make-backup-files nil)
(setq echo-keystrokes 0.1)
(setq-default tab-width 4)
(setq ring-bell-function #'ignore) ;KILL SYSTEM BELL

;; history
(req-package recentf
  :config
  (recentf-mode 1)
  (setq recentf-max-saved-items 100))

;; Save minibuffer history
(savehist-mode 1)
(setq history-length 1000)

;; Uniquify
;(require 'uniquify)
;(setq uniquify-buffer-name-style 'reverse)

;; Automatically create directories when creating a file
(defadvice find-file (before make-directory-maybe (filename &optional wildcards) activate)
  "Create parent directory if not exists while visiting file."
  (unless (file-exists-p filename)
    (let ((dir (file-name-directory filename)))
      (unless (file-exists-p dir)
        (make-directory dir)))))

;; emacs doesn't actually save undo history with revert-buffer
;; see http://lists.gnu.org/archive/html/bug-gnu-emacs/2011-04/msg00151.html
;; fix that.
;; http://stackoverflow.com/questions/4924389/is-there-a-way-to-retain-the-undo-list-in-emacs-after-reverting-a-buffer-from-fi
(defun revert-buffer-keep-history (&optional IGNORE-AUTO NOCONFIRM PRESERVE-MODES)
  (interactive)

  ;; tell Emacs the modtime is fine, so we can edit the buffer
  (clear-visited-file-modtime)

  ;; insert the current contents of the file on disk
  (widen)
  (delete-region (point-min) (point-max))
  (insert-file-contents (buffer-file-name))

  (save-buffer)
  (set-visited-file-modtime))

(setq revert-buffer-function 'revert-buffer-keep-history)

(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(take-time "general")

;;window management
(req-package-force windmove
  :chords
  (("WW" . windmove-up)
   ("AA" . windmove-left)
   ("SS" . windmove-down)
   ("DD" . windmove-right)))

(req-package-force ace-window
  :require windmove
  :config (ace-window-display-mode)
  (defhydra hydra-window (:color blue :hint nil :idle 1 :timeout 10 :columns 5)
	"window"
	("q" nil "nop")
	("1" delete-other-windows)
	("2" (progn (split-window-below) (windmove-down)))
	("3" (progn (split-window-right) (windmove-right)))
	("w" ace-window "goto")
	("a" ace-maximize-window "max")
	("s" ace-swap-window "swap")
	("d" ace-delete-window "del")
	;;non-ace stuff
	("f" find-file "file")
	("F" find-file-other-window "other file")
	("+" text-scale-increase "in" :color red)
	("-" text-scale-decrease "out" :color red))
  :chords (("qq" . hydra-window/body)))

;;TODO: I should really invest time in figuring this one out
(req-package winner
  :disabled t)
(take-time "windowing")

;;spelling
(req-package flyspell
  :defer 3
  :config
  ;; http://endlessparentheses.com/ispell-and-abbrev-the-perfect-auto-correct.html
  (defun crux-ispell-word-then-abbrev (p)
	"Call `ispell-word', then create an abbrev for it.
With prefix P, create local abbrev.  Otherwise it will
be global.
If there's nothing wrong with the word at point, keep
looking for a typo until the beginning of buffer.  You can
skip typos you don't want to fix with `SPC', and you can
abort completely with `C-g'."
	(interactive "P")
	(let (bef aft)
	  (save-excursion
		(while (if (setq bef (thing-at-point 'word))
				   ;; Word was corrected or used quit.
				   (if (ispell-word nil 'quiet)
					   nil ; End the loop.
					 ;; Also end if we reach `bob'.
					 (not (bobp)))
				 ;; If there's no word at point, keep looking
				 ;; until `bob'.
				 (not (bobp)))
		  (backward-word))
		(setq aft (thing-at-point 'word)))
	  (if (and aft bef (not (equal aft bef)))
		  (let ((aft (downcase aft))
				(bef (downcase bef)))
			(define-abbrev
			  (if p local-abbrev-table global-abbrev-table)
			  bef aft)
			(message "\"%s\" now expands to \"%s\" %sally"
					 bef aft (if p "loc" "glob")))
		(user-error "No typo at or before point")))))

;;versioncontrol
(req-package magit
  :defer 2
  :chords ("GG" . magit-status))

;;pkgbuild mode
(req-package pkgbuild-mode
  :mode "\\PKGBUILD\\'")

;;snippets
(req-package yasnippet
  :defer 2
  :diminish yas-minor-mode
  :config
  (setq yas-verbosity 1)
  (yas-global-mode 1)
  (define-key yas-minor-mode-map (kbd "C-M-y") 'yas-expand))

;;minibuffer
(req-package flx
  :defer 1)

(req-package flx-ido
  :require flx
  :config
  (ido-mode 1)
  (ido-everywhere 1)
  (flx-ido-mode 1)
  ;; disable ido faces to see flx highlights.
  (setq ido-enable-flex-matching t)
  (setq ido-use-faces nil)
  (global-set-key (kbd "C-x C-f") 'ido-find-file)
  :chords ("BB" . ido-switch-buffer))

(global-set-key (kbd "C-<") 'universal-argument)
(global-set-key (kbd "C-S-SPC") (lambda () (interactive) (set-mark-command 1)))

(req-package smex
  :bind ("M-x" . smex)
  :config (smex-initialize))
(take-time "misc")


;;org
(req-package org
  :mode ("\\.org$" . org-mode))

(req-package org-protocol
  :disabled t
  :require org
  :config (setq org-protocol-default-template-key "l"))
(take-time "org")


;;latex
(req-package pdf-tools
  :mode ("\\.tex\\'" . TeX-latex-mode)
  :config (pdf-tools-install))

(req-package auctex
  :mode ("\\.tex\\'" . TeX-latex-mode)
  :require pdf-tools
  :config
  (setq TeX-auto-save t
		TeX-parse-self t
		TeX-PDF-mode t
		LaTeX-command "latex --shell-escape -synctex=1"
		TeX-source-correlate-start-server t
		TeX-source-correlate-mode t)
										;(setq-default TeX-master nil)
  (add-hook 'LaTeX-mode-hook 'visual-line-mode)
  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
										;(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
										;(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
										;(setq reftex-plug-into-AUCTeX t)
  )
(take-time "latex")

;;editing
(req-package expand-region
  :config
  (setq expand-region-fast-keys-enabled nil)
  (defhydra hydra-expand-region (:idle 5)
	"expand-region"
	("S-SPC" er/expand-region "expand")
	("SPC" er/contract-region "contract"))
  (add-to-list hydra-expand-region/heads '("x" next-line "next-line" :exit nil))
  :bind ("S-SPC" . hydra-expand-region/body))

(req-package browse-kill-ring
  :bind ("M-y" . browse-kill-ring))

(req-package ace-jump-mode
  :preface (defun enno/simplefold ()
			 "Fold all indented lines or unfold all folded lines."
			 (interactive)
			 (if (not (equal selective-display nil))
				 (set-selective-display nil)
			   (set-selective-display (+ 1 (current-indentation)))))
  :chords(("CC" . ace-jump-mode)
		  ("FF" . enno/simplefold)))

(req-package highlight-symbol
  :diminish hl-s
  :config
  (add-hook 'prog-mode-hook (lambda () (highlight-symbol-mode)))
  (defhydra hydra-highlight (:hint nil :idle 1 :columns 5)
	"hightlight-symbol"
	("q" nil "exit" :color blue)
	("y" highlight-symbol "highlight")
	("x" highlight-symbol-prev "prev")
	("c" highlight-symbol-next "next")
	("Y" highlight-symbol-occur "occur")
	("X" highlight-symbol-query-replace "replace")
	("C" highlight-symbol-remove-all "clear"))
  :chords (("yy" . hydra-highlight/body)))
(take-time "editing")

;;completion
(req-package company
  :after init-is-done
  :diminish company-mode
  :config
  (global-company-mode 1)
  (setq company-idle-delay 1)
  (setq company-show-numbers t)
  (setq company-minimum-prefix-length 2)
  (setq company-dabbrev-downcase nil)
  (setq company-dabbrev-other-buffers t)
  (setq company-auto-complete nil)
  (setq company-dabbrev-code-other-buffers 'all)
  (setq company-dabbrev-code-everywhere t)
  (setq company-dabbrev-code-ignore-case t)
  (global-set-key (kbd "C-<tab>") 'company-dabbrev)
  (global-set-key (kbd "S-<tab>") 'company-complete)
  (global-set-key (kbd "C-c C-y") 'company-yasnippet))

(req-package company-quickhelp
  :require company
  :config (company-quickhelp-mode 1))
(take-time "completion")


;;coding
(defun c-c++-header ()
  "Set either 'c-mode' or 'c++-mode', whichever is appropriate for header."
  (interactive)
  (let ((c-file (concat (substring (buffer-file-name) 0 -1) "c")))
    (if (file-exists-p c-file)
        (c-mode)
      (c++-mode))))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c-c++-header))

(req-package modern-cpp-font-lock
  :diminish mc++fl
  :config (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode))

(req-package flycheck
  :defer 2
  ;:after cc-langs
  :config (global-flycheck-mode))

;; show error message at the bug rather than at the bottom of the buffer
(req-package flycheck-pos-tip
  :disabled t
  :require flycheck
  :config (flycheck-pos-tip-mode))

(req-package flycheck-google-cpplint
  :require flycheck
  :after cc-langs
  :config (flycheck-add-next-checker 'c/c++-clang
									 '(warnings-only . c/c++-googlelint)))

(req-package rtags
  :after cc-langs)

(req-package clang-format
  :after cc-langs)

(req-package cmake-ide
  :after cc-langs
  :config (cmake-ide-setup))

;; smart-parens for c/c++
(req-package corral
  :after cc-langs)

(req-package cmake-font-lock
  :require cmake-mode
  :config
  (autoload 'cmake-font-lock-activate "cmake-font-lock" nil t)
  (add-hook 'cmake-mode-hook 'cmake-font-lock-activate))

(req-package cmake-mode
  :mode (("CMakeLists\\.txt\\'" . cmake-mode)
         ("\\.cmake\\'"         . cmake-mode)))

(req-package smartparens-config
  :require smartparens
  :diminish smartparens-mode
  :bind
  (("C-a" . sp-beginning-of-sexp)
   ("C-e" . sp-end-of-sexp)
   ("C-M-right" . sp-forward-slurp-sexp)
   ("C-M-left" . sp-forward-barf-sexp))
  :config
  (show-smartparens-global-mode t)
  (smartparens-global-mode))

(req-package lua-mode
  :mode "\\.lua$")
(take-time "coding")

(req-package json-mode)

;; (req-package company-c-headers
;;   :require company
;;   :config (add-to-list 'company-backends 'company-c-headers))

;; actually load all the things
(req-package-finish)
(take-time "req-package-finish")

(add-hook 'after-init-hook '(lambda () (message (concat "--- Init took " (emacs-init-time) " ---"))
							  (print-time)
							  ;(enable-theme 'deeper-blue)
							  (setf gc-cons-threshold 800000)
							  (provide 'init-is-done)))

;; load extensions
;(let ((file-name-handler-alist nil)) (load "~/.emacs.d/init-this.el"))
;(load "~/.emacs.d/init-this.el")
; disabled late loading as loading time was not really an issue but missing settings on file opening were
; (add-hook 'after-init-hook (lambda () (load "~/.emacs.d/init-late.el")))

;;; init.el ends here
