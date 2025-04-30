;; ~/.emacs.d/init.el

;;––––– turn off async native-comp warnings –––––
(when (boundp 'native-comp-async-report-warnings-errors)
  (setq native-comp-async-report-warnings-errors nil))


;;––––– skip deferred compilation entirely (optional) ––––
(when (fboundp 'comp-deferred-compilation)
  (setq comp-deferred-compilation nil))


;;----- basic configuration -----
(setq inhibit-startup-screen t)       ; ditch the splash
(tool-bar-mode -1)                    ; no toolbar fluff
(menu-bar-mode -1)                    ; fewer menus
(scroll-bar-mode -1)                  ; bye scrollbar


;;----- setup line numbers -----
;(setq display-line-numbers-width          4
;      display-line-numbers-width-start    t
;      display-line-numbers-grow-only      t
;      display-line-numbers-format        "%-4d ")

;(add-hook 'prog-mode-hook #'display-line-numbers-mode)


;;----- package setup -----
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Auto-install use-package if missing
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)


;;----- theming -----
;; Hack to trick emacs tui mode for the bg color
(set-face-background 'default "undefined")

;; Spacemacs theme with “Popping and Locking” overrides
(use-package spacemacs-theme
  :ensure t
  :config
  ;; Override Spacemacs theme colors to match “Popping and Locking”
  (setq spacemacs-theme-custom-colors
        '((bg1           . "#181921")   ; main background
          (bg2           . "#1D2021")   ; current-line highlight
          (bg3           . "#21222d")   ; Yet another darker shade of the background color.
	  (bg4           . "#1f2026")   ; The darkest background
          (base          . "#EBDBB2")   ; default text
          (comment       . "#928374")   ; comments
          (keyword       . "#D3869B")   ; keywords, builtins
          (str           . "#B8BB26")   ; strings
          (func          . "#99C6CA")   ; function names
          (var           . "#FABD2F")   ; variable names
          (const         . "#7EC16E")   ; constants
          (err           . "#CC241D")   ; errors
          (war           . "#F42C3E")   ; warnings
          (suc           . "#98971A")   ; success messages
          (highlight     . "#FABD2F")   ; region, TODOs, etc.
          (highlight-dim . "#928374")   ; subdued highlights
;          (lnum          . "#21222d")   ; line numbers
          (mat           . "#D3869B")   ; matching parens/brackets
          (type          . "#689D6A")   ; type names
          (cursor        . "#C7C7C7")   ; cursor
          (border        . "#1D2021")   ; mode-line borders

          ;; explicit color overrides (optional)
          (aqua      . "#689D6A")   (aqua-bg    . "#7EC16E")
          (green     . "#98971A")   (green-bg   . "#B8BB26") (green-bg-s . "#98971A")
          (cyan      . "#7EC16E")
          (red       . "#CC241D")   (red-bg     . "#F42C3E") (red-bg-s   . "#CC241D")
          (blue      . "#458588")   (blue-bg    . "#99C6CA") (blue-bg-s  . "#458588")
          (magenta   . "#B16286")
          (yellow    . "#D79921")   (yellow-bg  . "#FABD2F")))

  ;; (Optional) Tweak italics/background for comments/org if you like:
  (setq spacemacs-theme-comment-bg    nil   ; disable block behind comments
        spacemacs-theme-comment-italic t   ; slanted comments
        spacemacs-theme-keyword-italic t   ; slanted keywords
        spacemacs-theme-org-agenda-height  t
        spacemacs-theme-org-bold          t
        spacemacs-theme-org-height        t
        spacemacs-theme-org-highlight     t
        spacemacs-theme-org-priority-bold t
        spacemacs-theme-underline-parens  t)

  ;; Finally, load the theme
  (load-theme 'spacemacs-dark t))


;;----- custom keybinds -----
(global-set-key (kbd "C-c L") #'global-display-line-numbers-mode) ; C-c L   Toggle Line Numbers


;;----- custom set variables -----
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 '(package-selected-packages '(spacemacs-theme use-package)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 )
