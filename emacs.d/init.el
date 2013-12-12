(blink-cursor-mode t)
(show-paren-mode t)
(column-number-mode t)

;; let sane usage of copy/paste/undo, etc
(cua-mode t)

;; no tool bar
(tool-bar-mode -1)

;; word wrap for text files
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)

;; ido mode everywhere, fuzzy matching
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(cond
  ((eq system-type 'darwin)
    ;; set font
    (set-frame-font "Courier New-20")
    ;; Add macports executables to path
    (add-to-list 'exec-path "/opt/local/bin")
    (setq mac-command-modifier 'ctrl))
  ((eq system-type 'gnu/linux)
    ;; set font
    (set-frame-font "Nimbus Mono L-20"))
  ((eq system-type 'windows-nt)
    ;; set font
    (set-frame-font "Courier New-14"))
)

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)

;; add a bunch of package sources
(require 'package)
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/") 
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(custom-set-variables
 ;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/backups/")))
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("501caa208affa1145ccbb4b74b6cd66c3091e41c5bb66c677feda9def5eab19c" default))))
 '(custom-enabled-themes (quote (solarized-dark)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(load-theme 'solarized-dark t)
