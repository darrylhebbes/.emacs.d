;; Time-stamp: <2017-08-16 01:32:04 csraghunandan>

;; swiper: isearch with an overview!
;; https://github.com/abo-abo/swiper
(use-package swiper
  :bind (:map isearch-mode-map
              ("C-c s" . swiper-from-isearch)) ; isearch > swiper
  :bind
  (("C-s" . counsel-grep-or-swiper))
  :config (setq swiper-action-recenter t))

(provide 'setup-swiper)

;; swiper
;; press `M-n' to select the symbol at point in swiper
;; press `C-c s' to search regexp from isearch to swiper
;; press `C-S-s' to search all the open files(can be slow)
