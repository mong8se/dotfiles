(blink-cursor-mode t)
(show-paren-mode t)
(column-number-mode t)
(cua-mode t)
(tool-bar-mode -1)
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)

(set-frame-font "Courier New-20")
(add-to-list 'exec-path "/opt/local/bin")

(require 'package)
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/") 
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(custom-set-variables
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
