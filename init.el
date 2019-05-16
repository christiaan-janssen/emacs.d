;;; Package --- Sumary:
;;; Emacs main config file
;;; Commentary:

;;; Code:

;;; Create some ssane defaults
(setq delete-old-versions -1)    ;; delete excessclojure play sound backup versions silently
(setq version-control t)    ; use version control
(setq vc-make-backup-files t)    ; make backups file even when in version controlled dir
(setq backup-directory-alist `(("." . "~/.emacs.d/backups"))) ; which directory to put backups file
(setq vc-follow-symlinks t)               ; don't ask for confirmation when opening symlinked file
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t))) ;transform backups file name
(setq inhibit-startup-screen t)  ; inhibit useless and old-school startup screen
(setq ring-bell-function 'ignore)  ; silent bell when you make a mistake
(setq coding-system-for-read 'utf-8)  ; use utf-8 by default
(setq coding-system-for-write 'utf-8)
(setq sentence-end-double-space nil)  ; sentence SHOULD end with only a point.
(setq fill-column 80)    ; toggle wrapping text at the 80th character
(setq initial-scratch-message "Welcome to Emacs") ; print a default message in the empty scratch buffer opened at startup
(add-to-list 'exec-path "~/.bin")
(setq create-lockfiles nil)

(setq auto-save-file-name-transforms
  `((".*" "~/.emacs.d/backups/" t)))

;; == [ GNU elpa GPG error work around ] ==
;; WARNIGN: This will disable signature check on install for any package
;;(setq package-check-signature nil)

;; clean up the interface
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; setup use-package

(require 'package)

(setq package-archives
      '(("mepla" . "http://melpa.org/packages/")
        ("org"       . "http://orgmode.org/elpa/")
        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("gnu"       . "http://elpa.gnu.org/packages/")))

(package-initialize)

;; Bootstrap 'use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)
;(add-to-list 'package-pinned-packages '(magit . "melpa-stable") t)

(let ((dir "~/.emacs.d/packages"))
  (unless (file-directory-p dir)
    (make-directory dir)))

(if (file-directory-p "~/.emacs.d/packages/undo-tree")
    (add-to-list 'load-path "~/.emacs.d/packages/undo-tree")
  (progn (shell-command "git clone http://www.dr-qubit.org/git/undo-tree.git ~/.emacs.d/packages/undo-tree")
	 (add-to-list 'load-path "~/.emacs.d/packages/undo-tree")))

(let ((file "~/.emacs.d/treemacs.el"))
  (if (file-exists-p file)
      (load-file file)
    nil))

(let ((file "~/.emacs.d/chef.el"))
  (if (file-exists-p file)
      (load-file file)
    nil))

(require 'undo-tree)
(global-undo-tree-mode)

(set-face-attribute 'default t :font "Source Code Pro" :height 100)

(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (which-key-show-major-mode)
  (setq which-key-separator " : "))

(use-package exec-path-from-shell :ensure t)
(use-package eyebrowse :ensure t)
(use-package helm :ensure t)
(require 'helm-config)
(use-package general :ensure t)
(use-package smex :ensure t)
(use-package magit :ensure t)
(use-package multiple-cursors :ensure t)
(use-package swiper :ensure t)
(use-package org :ensure t)

(use-package company :ensure t)
(add-hook 'after-init-hook 'global-company-mode)

(use-package projectile
  :ensure t
  :config
  (projectile-mode)
  (setq projectile-indexing-method 'alien)
  (setq projectile-enable-caching t))

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

;;;; ==[ Helm ]==============
(helm-autoresize-mode t)
(setq helm-autoresize-max-height 40)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)

;;;; ==[ Key Bindings ]======

(general-define-key
 "C-s" 'swiper
 "M-x" 'smex
 "M-S-x" 'helm-M-x
 "C->" 'mc/mark-next-like-this
 "C-<" 'mc/mark-previous-like-this
 "C-c C-<" 'mc/mark-all-like-this)

(general-define-key
 :prefix "C-c"
 "f"   '(:ignore t :which-key "files")
 "ff"  'helm-find-files
 "fr"  'helm-recentf
 "ft"  'treemacs
 "g"   '(:ignore t :which-key "Git")
 "gs"  'magit-status
 "k"   '(:ignore t :which-key "Knife")
 "ks"  'knife-status
 "o"   '(:ignore t :which-key "org")
 "oc"  'org-capture
 "p"   'projectile-command-map)

(general-define-key
 :prefix "C-c"
 :keymaps 'robe-mode-map
 "c"   '(:ignore t :which-key "Chef")
 "cc"  'kitchen-converge
 "cd"  'kitchen-destroy
 "ct"  'kitchen-test
 "cv"  'kitchen-verify)

(general-define-key
 :prefix "C-x"
 "b" 'helm-mini)

(general-define-key
 :prefix "C-S-c"
 "c" 'mc/edit-lines)

;;;; ==[ Languages ]=========
(use-package yaml-mode :ensure t)
(use-package markdown-mode :ensure t)

(use-package clojure-mode :ensure t)
(use-package clojure-mode-extra-font-locking :ensure t)
(use-package cider :ensure t)

(use-package paredit
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'enable-paredit-mode))

(use-package sly :ensure t)
(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package js2-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (add-hook 'js2-mode-hook #'js2-imenu-extra-mode))

(use-package js2-refactor :ensure t)
(use-package company-tern :ensure t)

(use-package robe
  :ensure t
  :config
  (add-hook 'ruby-mode-hook 'robe-mode)
  (push 'company-robe company-backends))

(use-package gruvbox-theme :ensure t)
(use-package rebecca-theme :ensure t)

(use-package all-the-icons :ensure t)

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-height 20)
  (setq doom-modeline-major-mode-color-icon t)
  (setq doom-modeline-buffer-state-icon t)
  (setq doom-modeline-buffer-encoding nil)
  )


(load-theme 'rebecca t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("f633d825e380caaaefca46483f7243ae9a663f6df66c5fad66d4cab91f731c86" "1436d643b98844555d56c59c74004eb158dc85fc55d2e7205f8d9b8c860e177f" default)))
 '(package-selected-packages
   (quote
    (sly doom-modeline slime-company slime embrace rebecca-theme eyebrowse swiper flycheck general smex clojure-mode-extra-font-locking clojure-mode cider which-key markdown-mode yaml-mode rainbow-delimiters paredit treemacs-magit treemacs-icons-dired treemacs-projectile treemacs gruvbox-theme robe use-package js2-refactor helm exec-path-from-shell company-tern))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
