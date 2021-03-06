;; Time-stamp: <2017-06-18 19:10:57 csraghunandan>

;; info+: extend the standard `info.el' emacs library
;; https://www.emacswiki.org/emacs/InfoPlus
(use-package info+
  :config (require 'info+))

(defhydra hydra-info (:color blue
                      :hint nil)
      "
Info-mode:

  ^^_]_ forward  (next logical node)       ^^_l_ast (←)        _u_p (↑)                             _f_ollow reference       _T_OC
  ^^_[_ backward (prev logical node)       ^^_r_eturn (→)      _m_enu (↓) (C-u for new window)      _i_ndex                  _d_irectory
  ^^_n_ext (same level only)               ^^_H_istory         _g_oto (C-u for new window)          _,_ next index item      _c_opy node name
  ^^_p_rev (same level only)               _<_/_t_op           _b_eginning of buffer                virtual _I_ndex          _C_lone buffer
  regex _s_earch (_S_ case sensitive)      ^^_>_ final         _e_nd of buffer                      ^^                       _a_propos

  _1_ .. _9_ Pick first .. ninth item in the node's menu.

"
      ("]"   Info-forward-node)
      ("["   Info-backward-node)
      ("n"   Info-next)
      ("p"   Info-prev)
      ("s"   Info-search)
      ("S"   Info-search-case-sensitively)

      ("l"   Info-history-back)
      ("r"   Info-history-forward)
      ("H"   Info-history)
      ("t"   Info-top-node)
      ("<"   Info-top-node)
      (">"   Info-final-node)

      ("u"   Info-up)
      ("^"   Info-up)
      ("m"   Info-menu)
      ("g"   Info-goto-node)
      ("b"   beginning-of-buffer)
      ("e"   end-of-buffer)

      ("f"   Info-follow-reference)
      ("i"   Info-index)
      (","   Info-index-next)
      ("I"   Info-virtual-index)

      ("T"   Info-toc)
      ("d"   Info-directory)
      ("c"   Info-copy-current-node-name)
      ("C"   clone-buffer)
      ("a"   info-apropos)

      ("1"   Info-nth-menu-item)
      ("2"   Info-nth-menu-item)
      ("3"   Info-nth-menu-item)
      ("4"   Info-nth-menu-item)
      ("5"   Info-nth-menu-item)
      ("6"   Info-nth-menu-item)
      ("7"   Info-nth-menu-item)
      ("8"   Info-nth-menu-item)
      ("9"   Info-nth-menu-item)

      ("?"   Info-summary "Info summary")
      ("h"   Info-help "Info help")
      ("q"   Info-exit "Info exit")
      ("C-g" nil "cancel" :color blue))

(bind-keys
 :map Info-mode-map
 ("?" . hydra-info/body)
 ("y" . bury-buffer))

(bind-key "C-c h a"
          (defhydra hydra-apropos (:color blue
                                          :hint nil)
"
_a_: apropos    _e_: val          _l_: lib       _v_: variable
_c_: cmd        _d_: doc          _o_: option    _i_: info
_t_: tags       _z_: customize    _q_: quit
"
            ("a" apropos)
            ("c" apropos-command)
            ("d" apropos-documentation)
            ("e" apropos-value)
            ("l" apropos-library)
            ("o" apropos-user-option)
            ("v" apropos-variable)
            ("i" info-apropos)
            ("t" tags-apropos)
            ("z" hydra-customize-apropos/body)
            ("q" nil :color blue)))

(defhydra hydra-customize-apropos (:color blue)
  "Apropos (customize)"
  ("a" customize-apropos "apropos")
  ("f" customize-apropos-faces "faces")
  ("g" customize-apropos-groups "groups")
  ("o" customize-apropos-options "options"))

;; http://oremacs.com/2015/03/17/more-info/
(defun ora-open-info (topic bufname)
  "Open info on TOPIC in BUFNAME."
  (if (get-buffer bufname)
      (progn
        (switch-to-buffer bufname)
        (unless (string-match topic Info-current-file)
          (Info-goto-node (format "(%s)" topic))))
    (info topic bufname)))

(defhydra hydra-info-to (:hint nil
                               :color teal)
  "
_i_nfo      _o_rg      e_l_isp      e_L_isp intro      _e_macs      _c_alc      _g_rep emacs info"
  ("i" info)
  ("o" (ora-open-info "org" "*org info*"))
  ("l" (ora-open-info "elisp" "*elisp info*"))
  ("L" (ora-open-info "eintr" "*elisp intro info*"))
  ("e" (ora-open-info "emacs" "*emacs info*"))
  ("c" (ora-open-info "calc" "*calc info*"))
  ("C" (ora-open-info "cl" "*emacs common lisp info*"))
  ("g" counsel-ag-emacs-info))

(bind-key "C-c h i" #'hydra-info-to/body)

(provide 'setup-info)
