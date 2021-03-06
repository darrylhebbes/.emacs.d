;; Time-stamp: <2017-08-03 20:11:53 csraghunandan>

;; https://magit.vc , https://github.com/magit/magit
;; magit: the git porcelain to manage git
(use-package magit
  :bind (("C-c m b" . magit-blame)
         ("C-c m s" . hydra-magit/body))

  :config (setq magit-completing-read-function 'ivy-completing-read)
  (progn
    ;; Magit Submodule support
    ;; https://www.reddit.com/r/emacs/comments/6aiwk5/how_to_manage_multiple_gitrepositories_at_once/dhf47dg/
    (dolist (fn '(;; Below will end up being the last of these newly added fns,
                  ;; and the last element in `magit-status-sections-hook' too.
                  magit-insert-modules-unpulled-from-upstream
                  magit-insert-modules-unpushed-to-pushremote
                  magit-insert-modules-unpushed-to-upstream
                  magit-insert-modules-unpulled-from-pushremote
                  ;; Below will end up being the first of these newly added fns.
                  magit-insert-submodules))
      (magit-add-section-hook 'magit-status-sections-hook `,fn nil :append)))

  (defun wh/switch-magit-status-buffer ()
    "Allow switching between open magit status buffers."
    (interactive)
    (let* ((buffers (--filter (eq #'magit-status-mode (with-current-buffer it major-mode))
                              (buffer-list)))
           (bufs-with-names (--map (cons
                                    (with-current-buffer it
                                      (projectile-project-name))
                                    it)
                                   buffers))
           (chosen-buf
            (cdr (assoc (completing-read "Git project: " bufs-with-names)
                        bufs-with-names))))
      (switch-to-buffer chosen-buf)))
  (bind-key "C-C m p" #'wh/switch-magit-status-buffer)
  (progn
    (defhydra hydra-magit (:color blue
                                  :columns 4)
      "Magit"
      ("g" magit-status "status")
      ("s" magit-status "status")
      ("l" magit-log-all-branches "log")
      ("b" magit-branch-popup "branch popup")
      ("r" magit-rebase-popup "rebase popup")
      ("R" magit-show-refs-popup "show refs")
      ("f" magit-fetch-popup "fetch popup")
      ("P" magit-push-popup "push popup")
      ("F" magit-pull-popup "pull popup")
      ("f" magit-log-buffer-file-popup "file log popup")
      ("W" magit-format-patch "format patch")
      ("$" magit-process-buffer "process"))))

;; git-timemachine: to rollback to different commits of files
;; https://github.com/pidu/git-timemachine
(use-package git-timemachine :defer t
  :diminish git-timemachine-mode "𝐓𝐦"
  :bind (("C-c g t" . git-timemachine-toggle)))

;; diff-hl: highlight diffs in the fringe
;; https://github.com/dgutov/diff-hl
(use-package diff-hl
  :config
  (add-hook 'dired-mode-hook #'diff-hl-dired-mode)
  (global-diff-hl-mode)
  ;; integate diff-hl with magit
  (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)

  (bind-key "C-c h d"
            (defhydra diff-hl-hunk-hydra (:color red)
              ("p" diff-hl-previous-hunk "prev hunk")
              ("n" diff-hl-next-hunk "next hunk")
              ("d" diff-hl-diff-goto-hunk "goto hunk")
              ("r" diff-hl-revert-hunk "revert hunk")
              ("m" diff-hl-mark-hunk "mark hunk")
              ("q" nil "quit" :color blue))))

;; git-messenger: popup commit message at current line
;; https://github.com/syohex/emacs-git-messenger
(use-package git-messenger
  :config
  ;; Enable magit-show-commit instead of pop-to-buffer
  (setq git-messenger:use-magit-popup t)

  (bind-key "C-c g m" 'git-messenger:popup-message)
  (bind-key "m" 'git-messenger:copy-message git-messenger-map))

;; git-link: emacs package for getting the github/gitlab/bitbucket URL
;; https://github.com/sshaw/git-link
(use-package git-link
  :commands (git-link git-link-commit git-link-homepage)
  :bind
  ("C-c g l" . git-link)
  ("C-c g c" . git-link-commit)
  ("C-c g h" . git-link-homepage))

(use-package magit-log :ensure nil
  :init
  (progn
    ;; Set `magit-log-margin' value in :init as many other variables will be
    ;; dynamically set based on its value when `magit-log' is loaded.
    ;; (setq magit-log-margin '(t age magit-log-margin-width t 18)) ;Default value
    ;; Show the commit ages with 1-char time units
    ;;   minute->m, hour->h, day->d, week->w, month->M, year->Y
    ;; Also reduce the author column width to 10 as the author name is being
    ;; abbreviated below.
    (setq magit-log-margin '(t age-abbreviated magit-log-margin-width :author 11)))
  :config
  (progn
    ;; Abbreviate author name, show "F Last" instead of "First Last".
    ;; If author's name is just "First", don't abbreviate it.
    (defun modi/magit-log--abbreviate-author (&rest args)
      "The first arg is AUTHOR, abbreviate it.
First Last -> F Last
First      -> First (no change)."
      ;; ARGS             -> '((AUTHOR DATE))
      ;; (car ARGS)       -> '(AUTHOR DATE)
      ;; (car (car ARGS)) -> AUTHOR
      (let* ((author (car (car args)))
             (author-abbr (replace-regexp-in-string "\\(.\\).*? +\\(.*\\)" "\\1 \\2" author)))
        (setf (car (car args)) author-abbr))
      (car args))                       ;'(AUTHOR-ABBR DATE)
    (advice-add 'magit-log-format-margin :filter-args #'modi/magit-log--abbreviate-author)))

(provide 'setup-git-stuff)

;; diff-hl
;; C-x v [ -> diff-hl-previous-hunk
;; C-x v ] -> diff-hl-next-hunk
;; C-x v = -> diff-hl-goto-hunk
;; C-x v n -> diff-hl-revert-hunk

;; magit
;; |---------+----------------------------------|
;; | Binding | Description                      |
;; |---------+----------------------------------|
;; | j n     | Jump to Untracked section        |
;; | j u     | Jump to Unstaged section         |
;; | j s     | Jump to Staged section           |
;; | j p     | Jump to Unpushed section         |
;; | M-p     | Jump to previous sibling section |
;; | M-n     | Jump to next sibling section     |
;; |---------+----------------------------------|

;; Tip: Adding prefix to above jump commands also expands those sections and
;; brings that section to the top of the buffer.
;;   So `C-u j s' is analogous to doing `j s C-l C-l 4`
