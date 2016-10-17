;;
;; PROXY SETTINGS
;;
;; (setq url-proxy-services
;;    '(("no_proxy" . "\\(localhost\\|127\\.0\\.0\\.0/8\\|::1\\|10\\.0\\.0\\.0/8\\)")
;;      ("https" . "127.0.0.1:3128")
;;      ("http" . "127.0.0.1:3128")))

(setq package-archives
   '(("melpa" . "http://melpa.org/packages/")))


(defvar my-packages
  '(ac-anaconda anaconda-mode ansible ansible-doc apache-mode auto-complete autopair
    cheatsheet color-theme company concurrent crontab-mode diffview direx
    find-file-in-project fixmee fringe-helper git-blame git-commit git-gutter+
    git-gutter-fringe+ helm helm-backup helm-core hide-comnt hideshow-org
    highlight-indentation hl-todo hydra ivy jedi jedi-core jedi-direx jinja2-mode json-mode
    json-reformat json-snatcher ldap-mode list-utils llvm-mode magit magit-filenotify
    magit-popup markdown-mode nav-flash neotree nginx-mode org-beautify-theme ox-mediawiki
    pcache persistent-soft php-mode popup projectile pydoc python-environment pythonic
    python-mode pyvenv smartparens smartrep solarized-theme sort-words swiper systemd
    ucs-utils web-mode websocket with-editor workgroups yaml-mode yasnippet )
  "List of packages to install by default")


(require 'package)
(package-initialize)

(defun install-my-packages()
  (interactive)
  (package-refresh-contents)
  (progn
    (dolist (p my-packages)
      (when (not (package-installed-p p))
	(package-install p))))
  )
(install-my-packages)

;;-------------------------------------------------------------------------------------
;; GLOBALS
;;
( server-start )
( toggle-scroll-bar 0 )
( tool-bar-mode 0 )
( desktop-save-mode t )
( setq line-number-mode            t
       column-number-mode          t
       line-spacing                0.4
       x-select-enable-clipboard   t
       browse-url-browser-function 'browse-url-firefox
       )
( global-font-lock-mode 1 )
( global-set-key "\M-g" 'goto-line )
( global-hl-line-mode t)
( delete-selection-mode t)           ;; replace selection on paste



(ido-mode)
;;(ido-mode 'buffers)
;;(setq ido-ignore-buffers '("^ " "*Completions*" "*Shell Command Output*" "*Messages*" "Async Shell Command"))


(winner-mode)   ;; Use "Ctrl-c [left|rigth]" to switch between window layouts
(require 'neotree)
(global-set-key (kbd "<f8>") 'neotree-toggle)

(require 'helm-backup)
(add-hook 'after-save-hook 'helm-backup-versioning)
(global-set-key (kbd "C-c b") 'helm-backup)

(require 'auto-complete-config)
(ac-config-default)

(require 'hideshow)
(defun my-hs-mode-setup()
  (define-key hs-minor-mode-map (kbd "<C-tab>") 'hs-toggle-hiding))
(add-hook 'hs-minor-mode-hook 'my-hs-mode-setup)

(require 'smartparens-config)

(require 'git-gutter-fringe+)
(setq git-gutter-fr+-side 'right-fringe)
(global-git-gutter+-mode t)

(require 'cheatsheet)
(load-file "~/.emacs.d/cheatsheet.el")


;;
;; TEXT MODES
;;

(defun my-org-mode-setup()
  (setq org-hidden-keywords       (quote (author date title))
        org-hide-emphasis-markers t
	org-hide-leading-stars    t
        org-src-fontify-natively  t
        org-support-shift-select  t
	org-tags-column           -120
        org-todo-keyword-faces
	(quote (("WIP" :inherit org-todo :foreground "darkorange" :weight bold)
		("CANC" :inherit org-done :foreground "dim gray" :weight bold)
		("FEEDBACK" . "red")))
        org-todo-keywords
	(quote ((sequence "TODO" "WIP(a@)" "WAIT(w@)" "FEEDBACK(f@)" "|"
			  "DONE(d@)" "CANC(k@)"))))
  	org-fontify-whole-heading-line t
  )
(add-hook 'org-mode-hook 'my-org-mode-setup)

;;
;; PROGRAMMING MODES
;;
(defun my-prog-mode-setup()
  (auto-complet-mode t)
  (linum-mode t)
  (git-gutter+-mode t)
  (smartparens-mode t)
  (show-smartparens-mode t)
  (yas-minor-mode t)  
  (add-to-list 'write-file-functions 'delete-trailing-whitespace)
  )


(require 'python)
(setq python-shell-interpreter "ipython")
(setq python-shell-interpreter-args "--pylab")
(defun my-python-mode-setup()
  (jedi:setup)
  (setq jedi:complete-on-dot t)
  (hs-minor-mode))

(add-hook 'python-mode-hook  'my-python-mode-setup)


;;
;; XML
;;
(require 'sgml-mode)
(require 'nxml-mode)

(add-to-list 'hs-special-modes-alist
             '(nxml-mode
               "<!--\\|<[^/>]*[^/]>"
               "-->\\|</[^/>]*[^/]>"

               "<!--"
               sgml-skip-tag-forward
               nil))

(add-hook 'nxml-mode-hook 'hs-minor-mode)
;; optional key bindings, easier than hs defaults
;; (define-key nxml-mode-map (kbd "C-c h") 'hs-toggle-hiding)

;;
;; Ansible
;;
(defun ansible-playbook-hook()  
  (yas-minor-mode 1)
  (auto-complete-mode 1)
  ;; (autopair-mode 1)
  ;; (show-paren-mode 1)
  (smartparens-mode 1)
  (linum-mode 1)
  (ansible 1)
  (local-set-key (kbd "C-m")   'newline-and-indent)
  (local-set-key (kbd "C-c d") 'ansible-doc)
)
(add-hook 'yaml-mode-hook 'ansible-playbook-hook)


;;
;; CUSTOMS (via UI)
;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist (quote (("." . "~/.emacs.d/auto-backup/"))))
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(dired-kept-versions 5)
 '(fill-column 92)
 '(git-gutter+-window-width 1)
 '(kept-new-versions 5)
 '(kept-old-versions 5)
 '(line-spacing 0.3)
 '(linum-format "%4d ")
 '(magit-diff-use-overlays nil)
 '(neo-toggle-window-keep-p t)
 '(neo-vc-integration (quote (char)))
 '(neo-window-position (quote right))
 '(neo-window-width 45)
 '(package-archives (quote (("melpa" . "http://melpa.org/packages/"))))
 '(transient-mark-mode (quote (only . t)))
 '(url-proxy-services nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :height 90 :width normal))))
 '(ansible-task-label-face ((t (:foreground "spring green"))))
 '(fixmee-notice-face ((t (:foreground "#93a1a1" :box (:line-width 1 :color "dim gray") :underline nil :slant italic :weight bold))))
 '(fringe ((t (:background "#001e26" :foreground "#586e75" :height 0.8 :width condensed))))
 '(linum ((t (:background "#001e26" :foreground "#586e75" :height 0.8 :width condensed))))
 '(mode-line ((t (:background "#171717" :foreground "#839496" :box (:line-width 1 :color "#073642" :style unspecified) :overline "#073642" :underline "#284b54"))))
 '(org-done ((t (:background "gray10" :foreground "forest green" :weight bold))))
 '(org-todo ((t (:background "gray11" :foreground "#2aa198" :weight bold)))))
(put 'narrow-to-region 'disabled nil)


;; emacs theme
(load-theme 'solarized-dark)
