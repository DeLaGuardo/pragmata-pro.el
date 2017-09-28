;;; pragmata-pro.el --- Shows ligatures from PragmataPro fontface in all programming modes  -*- lexical-binding: t; -*-

;; Copyright (C) 2017 delaguardo

;; Author: delaguardo
;; Version: 1.0
;; Keywords: pragmatapro fontface ligatures
;; Package-Requires: ((emacs "24.4"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; To use this package, simply add this to your init.el:
;; (pragmata-pro-mode)

;; To manually install, add this to your init.el before the hook mentioned above.
;; (add-to-load-path (expand-file-name "~/path/to/pragmata-pro.el"))
;; (load "pragmata-pro.el")

(require 'pragmata-pro/all-symbols "./data/all-symbols.el")

(defconst pragmata-pro/space-character (vector (decode-char 'ucs #X0020) '(Br . Bl)))

(defcustom pragmata-pro/version "0.826"
  ""
  :version "25.1"
  :type '(string)
  :group 'pragmata-pro-mode)

(defun pragmata-pro/combine-ligature (liga-typle)
  `(,(car liga-typle)
    .
    ,(vconcat
      (apply 'vconcat
             (make-list
              (- (length (car liga-typle)) 1)
              pragmata-pro/space-character))
      (vector (decode-char 'ucs (cadr liga-typle))))))

(defun pragmata-pro/match-to-alist (name alist)
  (mapcar (lambda (it) (and (equal name (car it))) (cdr it)) alist))

(defun pragmata-pro/prettify-symbols-mode-hook ()
  (dolist (ligature (pragmata-pro/match-to-alist
                     (mapconcat 'identity (list "liga" pragmata-pro/version) "-")
                     pragmata-pro/all-symbols))
    (push (pragmata-pro/combine-ligature ligature)
          prettify-symbols-alist)))

;;;###autoload
(define-minor-mode pragmata-pro-mode
  "Replace some characters that can be represented as ligatures with ligature character from
PragmataPro fontface."
  :lighter " pragmata-pro-mode"
  (progn
    (setq prettify-symbols-unprettify-at-point 'right-edge)
    (add-hook 'prog-mode-hook 'pragmata-pro/prettify-symbols-mode-hook)))

(provide 'pragmata-pro)
;;; pragmata-pro.el ends here
