;;; romanian-holidays.el --- Romanian holidays                   -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Petre Mierluțiu

;; Author: Petre Mierluțiu
;; Version: 0.0.1
;; URL: https://github.com/petrem/romanian-holidays
;; Keywords: calendar holidays romanian
;; Package-Requires: ((emacs "26"))

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides Romanian national holidays and other commemoration dates.
;;
;; Installation:
;;
;;   M-x package-install RET romanian-holidays RET
;;
;; You'll likely need to add to your config files:
;;  (require 'romanian-holidays)
;;
;; Or with `use-package', add to your config file:
;;
;;   (use-package romanian-holidays)
;;
;; Configuration:
;;
;; You can use `romanian-holidays' in several ways. For example:
;;
;; To replace the built-in list of holidays with all the romanian ones:
;;
;;  (setq calendar-holidays romanian-holidays-all-holidays)
;;
;; To add the romanian legal days off as the user-defined holidays:
;;
;;  (setq holiday-other-holidays romanian-holidays-legal)
;;
;; You may want to disable all (or some of) the pre-defined holidays:
;;
;;   (setq holiday-general-holidays nil
;;         holiday-bahai-holidays nil
;;         holiday-hebrew-holidays nil
;;         holiday-christian-holidays nil
;;         holiday-islamic-holidays nil
;;         holiday-oriental-holidays nil)
;;
;; See also: `calendar-holidays'.

;;; Credits:
;;
;; This package took from brazilian-holidays and german-holidays.
;;
;; Sources for the data:
;; - Legal national holidays enacted in labor law
;;   <https://www.codulmuncii.ro/titlul_3/capitolul_2/sectiunea_3_1.html>
;; - <https://ro.wikipedia.org/wiki/S%C4%83rb%C4%83tori_publice_%C3%AEn_Rom%C3%A2nia>

;;; Code:

(require 'calendar)
(require 'holidays)
(require 'cal-julian)

(defvar romanian-holidays--general-holidays
  '((holiday-fixed       1    1 "Anul Nou")
    (holiday-fixed       1    2 "Anul Nou")
    (holiday-fixed       1   24 "Ziua Unirii Principatelor Române")
    (holiday-fixed       5    1 "Ziua Internațională a Muncii")
    (holiday-fixed       6    1 "Ziua Copilului")
    (holiday-fixed      12    1 "Ziua Națională a României"))
  "National holidays in Romania (legal holidays).")


(defvar romanian-holidays--christian-holidays
  '((romanian-holidays--holiday-orthodox-easter-etc      -2 "Vinerea Mare")
    (romanian-holidays--holiday-orthodox-easter-etc       0 "Duminica Paștelui")
    (romanian-holidays--holiday-orthodox-easter-etc       1 "Lunea Luminată")
    (romanian-holidays--holiday-orthodox-easter-etc      50 "Duminica Rusaliilor")
    (romanian-holidays--holiday-orthodox-easter-etc      51 "Lunea Rusaliilor")
    (holiday-fixed       1    6 "Botezul Domnului - Boboteaza")
    (holiday-fixed       1    7 "Soborul Sfântului Proroc Ioan Botezătorul")
    (holiday-fixed       8   15 "Adormirea Maicii Domnului")
    (holiday-fixed      11   30 "Sfântul Andrei")
    (holiday-fixed      12   25 "Crăciunul")
    (holiday-fixed      12   26 "A doua zi de Crăciun"))
  "(Orthodox) Christian romanian holidays (legal holidays).")


(defvar romanian-holidays-legal-holidays
  (append romanian-holidays--general-holidays romanian-holidays--christian-holidays nil)
  "Legal holidays (days off) in Romania.")


;; This is a list of (possibly) more common holidays. Up for debate.
(defvar romanian-holidays--other-holidays
  '((holiday-fixed       1    1      "Sf. Vasile cel Mare")
    (holiday-fixed       2   24      "Dragobetele")
    (holiday-fixed       3    1      "Mărțișor")
    (holiday-fixed       3    8      "Ziua Internațională a Femeii")
    (holiday-easter-etc  0           "Paștele Catolic")
    (holiday-easter-etc  1           "Paștele Catolic")
    (holiday-fixed       4   23      "Sf. Gheorghe")
    (holiday-fixed       4    8      "Sărbătoarea Etniei Romilor din România")
    (holiday-float       5    0    1 "Ziua Mamei")
    (holiday-float       5    0    2 "Ziua Tatălui")
    (holiday-fixed       5    9      "Ziua Europei")
    (holiday-fixed       5   10      "Ziua Monarhiei")
    (holiday-fixed       5   10      "Ziua Independenței României")
    (holiday-fixed       5   21      "Ss. Constantin și Elena")
    (romanian-holidays--holiday-orthodox-easter-etc       40 "Ziua Eroilor")
    (romanian-holidays--holiday-orthodox-easter-etc       40 "Înățarea Domnului")
    (holiday-fixed       6   20      "Sf. Ilie")
    (holiday-fixed       6   29      "Ss. Petru și Pavel")
    (holiday-fixed       9   29      "Ss. Mihail, Gabriel și Rafael")
    (holiday-fixed      10   26      "Sf. Dumitru"))
  "Some other holidays and commemorative dates observed in Romania.")


(defvar romanian-holidays-all-holidays
  (append romanian-holidays-legal-holidays romanian-holidays--other-holidays nil)
  "Romanian Holidays and commemoration dates.")

;; An Orthodox Easter day calculation.
;; There is a package for it, see
;; https://github.com/hexmode/holiday-pascha-etc/blob/master/holiday-pascha-etc.el
;; but I don't want to depend on a third party.
;;
;; For the calculation I've also consulted:
;;
;; - https://dateutil.readthedocs.io/en/stable/_modules/dateutil/easter.html
;;
;; - https://www.tondering.dk/claus/cal/easter.php
;;
;; - https://hackage.haskell.org/package/time-1.14/docs/src/Data.Time.Calendar.Easter.html#orthodoxEaster
;;
;; The last references N. Dershowitz and E. M. Reingold, "Calendrical Calculations", ch.
;; 8. Interestingly this gives a Lisp implememntation that closely matches the "western"
;; Easter in Emacs's implementation for `holiday-easter-etc'. Not surprising, given that
;; the second author wrote `calendar.el' ;-).

;; Unfortunately there's no algorithm given for Orthodox Easter. Thus I've adapted the
;; Haskell "time" package version, arriving at a solution similar to the emacs package
;; referenced above.

(defun romanian-holidays--holiday-orthodox-easter-etc (n string)
  "Date of Nth day after Orthodox Easter (named STRING).

See `holiday-easter-etc'. However this function requires its
arguments and does not work similarly in \"backwards
compatibility mode\"."
  (let* ((y displayed-year)
         (jyear (if (> y 0) y (1- y)))
         (shifted-epact (% (+ 14 (* 11 (% jyear 19))) 30))
         (paschal-moon (- (calendar-julian-to-absolute `(4 19 ,jyear)) shifted-epact))
         (abs-easter   ;; sunday after paschal moon
          (calendar-dayname-on-or-before 0 (+ paschal-moon 7)))
         (greg (calendar-gregorian-from-absolute (+ abs-easter n))))
    (if (calendar-date-is-visible-p greg)
        (list (list greg string)))))


(provide 'romanian-holidays)
;;; romanian-holidays.el ends here
