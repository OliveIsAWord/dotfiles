(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(deeper-blue))
 '(inhibit-startup-screen t)
 '(package-selected-packages '(rust-mode mines which-key))
 '(warning-suppress-types '((auto-save) (auto-save))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(global-unset-key (kbd "<left>"))
(global-unset-key (kbd "<right>"))
(global-unset-key (kbd "<up>"))
(global-unset-key (kbd "<down>"))
(global-unset-key (kbd "<C-left>"))
(global-unset-key (kbd "<C-right>"))
(global-unset-key (kbd "<C-up>"))
(global-unset-key (kbd "<C-down>"))
(global-unset-key (kbd "<M-left>"))
(global-unset-key (kbd "<M-right>"))
(global-unset-key (kbd "<M-up>"))
(global-unset-key (kbd "<M-down>"))

(add-to-list 'load-path "~/.emacs.d/idris2-mode/")
(require 'idris2-mode)
(setq idris-interpreter-path "idris2")

(add-to-list 'load-path "~/.emacs.d/god-mode/")
(require 'god-mode)
(god-mode)
(define-key input-decode-map [?\C-i] [C-i])
(global-set-key (kbd "<C-i>") #'god-mode-all)
(define-key god-local-mode-map (kbd ".") #'repeat)
(define-key god-local-mode-map (kbd "i") #'god-mode-all)
(setq god-exempt-major-modes nil)
(setq god-exempt-predicates nil)

; (toggle-word-wrap)

(defun open-my-init-el ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

; (global-set-key (kbd "<ESC>") #'keyboard-quit)
; (global-set-key (kbd "<C-^>") 'open-my-init-el)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-unset-key (kbd "<C-g>"))

