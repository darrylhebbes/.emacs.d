;; Time-stamp: <2017-08-02 14:10:33 csraghunandan>

;; Smart M-x (smex): sort extended commands by last invoked
;; https://github.com/nonsequitur/smex/
(use-package smex
  :config (smex-initialize))

;; ivy: incremental narrowing framework for Emacs
;; https://github.com/abo-abo/swiper
(use-package ivy
  :diminish ivy-mode
  :config
  (ivy-mode)

  (setq ivy-use-virtual-buffers t
        ivy-height 13
        ivy-count-format "%d/%d "
        ivy-initial-inputs-alist nil
        ivy-virtual-abbreviate 'full ; Show the full virtual file paths
        ivy-extra-directories nil ; default value: ("../" "./")
        ivy-format-function 'ivy-format-function-arrow
        ivy-wrap t)

  (bind-keys
   :map ivy-occur-grep-mode-map
   ("n" . ivy-occur-next-line)
   ("p" . ivy-occur-previous-line)
   ("b" . backward-char)
   ("f" . forward-char)
   ("v" . ivy-occur-press)            ;default f
   ("RET" . ivy-occur-press))

  (bind-keys
   ("C-c v p" . ivy-push-view)
   ("C-c v o" . ivy-pop-view)
   ("C-c u" . ivy-resume)))

(provide 'setup-ivy)

;; ivy
;; * `C-c C-o' to run `ivy-occur' on the results of ivy
;; * when in `ivy-occur' enter wgrep mode by pressing `C-x C-q', to save changes
;; * press `C-x C-s' to save changes or `C-c C-k' to abort changes
;;   when in ivy-minibuffer, press `C-c C' to copy all the completion candidates to kill ring
;; * press C-' when in ivy-minibuffer to use avy to select completion candidates
;; * press `~' when in `counsel-find-file' to go to home directory
;; * press `//' when in `counsel-find-file' to go to root directory
