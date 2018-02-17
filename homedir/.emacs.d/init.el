(menu-bar-mode -1)                                 ; Disable the menubar at the top of the screen (File, Edit, Options, Buffer, etc.)
(if window-system
  (tool-bar-mode -1))                              ; Disable the toolbar (buttons)
(setq inhibit-startup-screen t)                    ; Disable startup screen with graphics
(set-default-font "Roboto Mono for Powerline 12")  ;
(setq-default indent-tabs-mode nil)                ; Use spaces instead of tabs
(setq tab-width 2)                                 ; Four spaces is a tab
(setq visible-bell nil)                            ; Disable annoying visual bell

;; Make keyboard bindings not suck
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)
(global-set-key "\M-c" 'copy-region-as-kill)
(global-set-key "\M-v" 'yank)
(global-set-key "\M-g" 'goto-line)

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t))
(package-initialize)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/atom-one-dark-theme/")
(load-theme 'atom-one-dark t)       ; Color theme 

(setq sml/no-confirm-load-theme t)  ; Bypass the warning “Loading themes can run lisp code”
(setq sml/theme 'powerline)
(sml/setup)
