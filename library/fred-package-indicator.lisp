;;;-*- Mode: Lisp; Package: CCL -*-;;;;;; fred-package-indicator.lisp;;;;;; MAKES MCL FRED DISPLAY THE PACKAGE NAME IN A PLACARD WITH MENU INSTEAD OF AS TEXT IN THE MINIBUFFER;;;;;; Copyright ©2000-2010 Terje Norderhaug / inĄProgress;;;;;; Use and copying of this software and preparation of derivative works;;; based upon this software are permitted, so long as this copyright ;;; notice and the author's name are included intact in this file or the;;; source code of any derivative work. Let me know if you need another license.;;;;;; Digitool, Inc. is permitted to integrate parts or whole of this module ;;; into MCL without including the copyright notice, as long as the author's;;; name is included in any file containing or derived from the contents;;; of this file.;;; ;;; This software is made available AS IS, and no warranty is made about ;;; the software or its performance. ;;;;;; Author: Terje Norderhaug <terje@in-progress.com>;;; Version: 1.5#| VERSION HISTORY2010-Feb-11 TN Version 1.5 uploaded to mcl repository.2010-Feb-11 TN Eliminated pre-carbon and pre-osx code.2008-Apr-03 TN Version 1.4 released2008-Apr-03 TN Updating code to changes in MCL 5.22004-Jul-17 TN Version 1.3 released2004-Jul-17 TN Added ignore declarations to the drag-split method.2004-Apr-22 TN Fixed pop-up menu failure when the placard shows a non-existing package (Thanks Octav!)2004-Apr-02 TN Minor updates to ensure MCL 4.3.1 compatability.2004-Mar-28 TN Eliminated method redefinition of drag-split on fred-window, using an around method instead. 2004-Mar-15 TN Added an optional popup arrow to the package indicator to make it obvious that it is a menu.2004-Mar-15 TN Eliminated use of the placard-dialog-item from the appearance-manager contribution.2004-Feb-20 TN The horizontal scroll bar of the expanded minibuffer extends all the way to the package indicator:                Modified view-size-part :after on new-mini-buffer to extend the scroll bar.                New *mini-buffer-hide-unused-status-line* to ignore this behaviour.2004-Feb-15 TN The minibuffer package indicator draws theme compliant label in Carbon:                Theme text code added to view-draw-contents of minibuffer-package-indicator.                New view-default-font on minibuffer-package-indicator provides default theme font.                update-package-indicator on fred-window no longer specifies view-font for the placard and menu.                view-size-part :after on new-mini-buffer uses GetThemeTextDimensions to get text width.-----------03-feb-2003 TN Fix flaw in earlier stream-fresh-line newline change.03-feb-2003 TN Version 1.2 released.03-feb-2003 TN stream-fresh-line on view mini-buffer-fred-item doesn't output newline unecessarry.17-mar-2002 TN Version 1.1 released.16-mar-2002 TN No longer requires the appearance manager module to provide indicator as modern placard.               Minibuffer-package-indicator no longer subclass of static-text-dialog-item.03-Aug-2000 TN Renamed the dialog item to minibuffer-package-indicator.24-Jul-2000 TN The indicator's pop-up menu in Listener affects current package.23-aug-2000 TN Submitted to Digitool.18-Jul-2000 TN Version 1.0 released.|#(in-package :ccl);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PACKAGE INDICATOR;; Most of this is (or should be) integrated in the placard-dialog-item of the appearance manager.;; Consider turning it into a generalized placard-dialog-item.(defclass minibuffer-package-indicator (dialog-item)  ((menu :initform NIL :initarg :menu))  (:default-initargs    :view-position #@(0 0)    :view-size #@(64 16)))(defmethod view-click-event-handler ((view minibuffer-package-indicator) where)  (declare (ignore where))  (with-slots (menu) view    (unless (menu-installed-p menu)      (setf (pop-up-menu-auto-update-default menu) nil)      (menu-install menu))    (set-view-position menu (view-position view))    (menu-select menu NIL)))(defparameter *show-minibuffer-package-indicator-popup-arrow* T) ; customizable until we decide whether to always display arrow(defmethod view-draw-contents ((item minibuffer-package-indicator))  (when (appearance-available-p)    (with-focused-dialog-item (item)      (with-item-rect (rect item)        (#_DrawThemePlacard rect         (if (window-active-p (view-window item))           #$kThemeStateActive           #$kThemeStateInactive)))))  (with-font-focused-view item    (with-fore-color (if (or (not (appearance-available-p))                             (window-active-p (view-window item)))                       *black-color* *gray-color*)      (if (appearance-available-p)         (rlet ((rect :rect                      :topleft #@(0 1)                     :bottomright (subtract-points (view-size item)                                                    (if *show-minibuffer-package-indicator-popup-arrow*                                                     #@(10 0)                                                     #@(0 0)))))          (with-cfstrs ((cftext (dialog-item-text item)))            (#_SetThemeTextColor (if (window-active-p (view-window item))                                   #$kThemeTextColorPlacardActive                                    #$kThemeTextColorPlacardInactive)             256 t) ; # fix the depth!            (#_Drawthemetextbox cftext #$kThemeCurrentPortFont              (if (window-active-p (view-window item)) #$kThemeStateActive #$kThemeStateInactive)             t rect #$tejustcenter *null-ptr*))          (when *show-minibuffer-package-indicator-popup-arrow*            (rlet ((arect :rect                          :top 5                         :left (rref rect rect.right)                         :bottomright (view-size item)))              (#_DrawThemePopupArrow arect #$kThemeArrowDown #$kThemeArrow5pt                (if (window-active-p (view-window item)) #$kThemeStateActive #$kThemeStateInactive)                (%null-ptr) 0))))))))(defmethod view-default-font ((view minibuffer-package-indicator))  ; just use :label-font of modern-mcl instead?  (let ((font-id #$kThemeLabelFont))    (rlet ((name (:string 255))           (size :word)           (style :style))      (errchk (#_getThemeFont font-id #$smSystemScript name size style))      (list       (%get-string name) ; (#_FMGetFontFamilyFromName name) ; (font-number-from-name (%get-string name))       (%get-word size)       (make-style (#.(mactype-get-function (find-mactype :style)) style))))))(defmethod view-default-size ((view minibuffer-package-indicator))  (with-font-focused-view view  ;(multiple-value-bind (ff ms) (view-font-codes view)   ; (with-font-codes ff ms      (let ((pkg-str (dialog-item-text view)))                (with-cfstrs ((text pkg-str))           (rlet ((size :point)                 (baseline :signed-word))            (#_GetThemeTextDimensions text              #$kThemeCurrentPortFont              (if (window-active-p (view-window view)) #$kThemeStateActive #$kThemeStateInactive)             NIL             size             baseline)            (add-points (if *show-minibuffer-package-indicator-popup-arrow*                          #@(18 0)                          #@(8 0))                        (%get-point size)))))))(defmethod view-activate-event-handler :after ((item minibuffer-package-indicator))  (invalidate-view item))(defmethod view-deactivate-event-handler :after ((item minibuffer-package-indicator))  (invalidate-view item));;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; UPGRADE MINI BUFFER WITH PLACARD FOR THE PACKAGE(defmethod update-package-indicator ((w fred-window) &optional (pkg-str (view-package-string w)))  (let* ((view (view-container (view-mini-buffer w)))         (package-indicator (view-named 'package-indicator view)))    (if package-indicator      (if (equal pkg-str (dialog-item-text package-indicator))        (return-from update-package-indicator)        (set-dialog-item-text package-indicator pkg-str))      (make-instance (or ; (find-class 'placard-dialog-item NIL)                          'minibuffer-package-indicator)        :dialog-item-text pkg-str        :help-spec "Displays the name of the active package"        :view-nick-name 'package-indicator        ; :view-font (view-font view)        :view-container view        :menu        (make-instance 'pull-down-menu          :menu-title ""          :view-size #@(0 0)          :view-container view          ;:view-font (sys-font-spec)          :update-function ;; can be optimized by reusing menu items...          (lambda (menu)            (let ((packages (sort (list-all-packages) #'string-lessp :key #'package-name))                  (menu-items (menu-items menu)))              (apply #'remove-menu-items menu menu-items)              (apply #'add-menu-items menu                (mapcar                   (lambda (p)                    (make-menu-item (package-name p)                      (lambda ()                        (if (typep w 'listener)                          (set-package p) ;; toplevel-read doesn't use fred-package... but use set-window-package?                          (set-fred-package (fred-item w) p))                        (update-package-indicator w))))                   packages))              (let ((pos (position (view-package-string (view-window menu)) packages                            :key #'shortest-package-nickname :test #'string-equal)))                (when pos ; nil if the package of the document isn't yet defined.                  (set-pop-up-menu-default-item menu (1+ pos)))))))))      (view-size-parts (view-container view))))(defmethod fred-update ((fred mini-buffer-fred-item) &aux (w (view-window fred)))  (when w    (update-package-indicator w))  (call-next-method))#|(defmethod view-size-parts :after ((view new-mini-buffer))  (let* ((package-indicator (view-named 'package-indicator view))         (fred-item (fred-item view))         (status-line (view-named 'status-line view)))    (when package-indicator      (let* ((pkg-str (dialog-item-text package-indicator))             (package-indicator-size (view-default-size package-indicator))             (width              (height (point-v (view-size package-indicator))))        (set-view-position package-indicator                         (point-h (view-position package-indicator))                          (- (point-v (view-size view))                            height))        (set-view-size package-indicator width height)        (when status-line          (set-view-position status-line                            (+ (point-h (view-position status-line))                              width)                           (point-v (view-position status-line)))          (set-view-size status-line                       (- (point-h (view-size status-line))                          width)                       (point-v (view-size status-line))))        (set-view-position fred-item                           (if status-line                              #@(1 1)                             (make-point (1+ width) 2)))        (set-view-size fred-item                       (if status-line                         (view-size fred-item)                         (make-point                           (- (point-h (view-size fred-item)) width)                          (point-v (view-size fred-item)))))))))|#;;;;;;(defparameter *mini-buffer-hide-unused-status-line* T) ; mostly for debugging purposes - anybody needs this let me know!(defmethod view-size-parts :after ((view new-mini-buffer))  (let* ((package-indicator (view-named 'package-indicator view))         (fred-item (fred-item view))         (status-line (view-named 'status-line view)))    (when package-indicator      (let* ((width (point-h (view-default-size package-indicator)))             (height (point-v (view-size package-indicator))))        (set-view-position package-indicator                         (point-h (view-position package-indicator))                          (- (point-v (view-size view))                            height))        (set-view-size package-indicator width height)        (when status-line          (cond           (*mini-buffer-hide-unused-status-line*            (let* ((h-scroller (h-scroller view))                   (scroller-pos (view-position h-scroller)))              (set-view-position h-scroller                                 (- width 1)                                 (point-v (view-position h-scroller)))              (set-view-size h-scroller                             (+ (point-h (view-size h-scroller))                                (- (point-h scroller-pos) width)                                1)                             (point-v (view-size h-scroller)))              (set-view-size status-line 0 (point-v (view-size status-line)))))                         (T            (set-view-position status-line                                (+ (point-h (view-position status-line))                                  width)                               (point-v (view-position status-line)))            (set-view-size status-line                           (- (point-h (view-size status-line))                              width)                           (point-v (view-size status-line))))))        (set-view-position fred-item                           (if status-line                              #@(1 1)                             (make-point (1+ width) 2)))        (set-view-size fred-item                       (if status-line                         (view-size fred-item)                         (make-point                           (- (point-h (view-size fred-item)) width)                          (point-v (view-size fred-item)))))))));;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FRED PATCHES(let ((*warn-if-redefine* nil)      (*warn-if-redefine-kernel* nil));; what about using stream-fresh-line on mb to eliminate most of its code?(defmethod mini-buffer-update ((w fred-window))  (when (wptr w)       (let ((status (view-status-line w))          (mb (view-mini-buffer w)))      (when (and mb (not status))           (with-focused-view mb  ; shouldnt help and prob wont            (let* ((buf (fred-buffer mb))                   (size (buffer-size buf)))              (set-mark buf size)              (stream-tyo mb #\newline)              (set-fred-display-start-mark mb (1+ size))              (fred-update mb) ))))));; Note how similar it is to mini-buffer-update... but perhaps it is all unecessarry now and can be eliminated?;; Should have a similar method for stream-force-output?(defmethod stream-fresh-line ((view mini-buffer-fred-item))  (with-focused-view view  ; seems to mess up - maybe this will help- if it does figure out why??    (let* ((w (view-window view))           (buf (fred-buffer view))           (pos (buffer-size buf)))      (set-mark buf pos)      (if (view-status-line w)        (call-next-method)        (when (> pos 0) ;; # is the below even necessarry now?          (stream-tyo view #\newline)          (set-fred-display-start-mark view (1+ pos))          (fred-update view))))));; No longer adjust position based on the length of the package string:#-ccl-5.2(defmethod i-search-prompt ((w fred-window) &optional init)  (let ((mb (view-mini-buffer w))        (str "i-search"))    (when mb      (let* ((buf (fred-buffer mb))             (pos (buffer-position buf))             (bpos (buffer-line-start buf buf 0)))                                  (cond ((and (not init) bpos (< bpos pos)                      (not (position #\newline *i-search-search-string*))                      (progn                        (if (not (view-status-line w))                         (setq bpos (+ bpos #| (length (view-package-string w)) 2 |# )))                        (when (< bpos (buffer-size buf))                          (buffer-substring-p buf str bpos))))                 ; works when no pkg preface                 (buffer-delete buf (+ bpos (length str)) (buffer-size buf)))                (t (setq init t)))          (when init             (stream-fresh-line mb)            (buffer-insert buf str))          (buffer-insert buf *i-search-note-string*)          (buffer-insert buf (if *i-search-forward-p* ": " " reverse: "))          (buffer-insert buf *i-search-search-string*)          (fred-update mb)))))#+ccl-5.2(defmethod i-search-prompt ((w fred-window) &optional init)  (let ((mb (view-mini-buffer w))        (str "i-search"))    (when mb      (let* ((buf (fred-buffer mb))             (pos (buffer-position buf))             (bpos (buffer-line-start buf buf 0)))                                  (cond ((and (not init) bpos (< bpos pos)                      (not (string-eol-position  *i-search-search-string*))                      (progn                        (if (not (view-status-line w))                         (setq bpos (+ bpos #+ignore (length (view-package-string w)) #+ignore 2)))                        (when (< bpos (buffer-size buf))                          (buffer-substring-p buf str bpos))))                 ; works when no pkg preface                 (buffer-delete buf (+ bpos (length str)) (buffer-size buf)))                (t (setq init t)))          (when init             (stream-fresh-line mb)            (buffer-insert buf str))          (buffer-insert buf *i-search-note-string*)          (buffer-insert buf (if *i-search-forward-p* ": " " reverse: "))          (buffer-insert buf *i-search-search-string*)          (fred-update mb)))));; Redefined - so that minibuffer snaps into a minimum two line size ;; ensuring that the package placard always is displayed. Also, no;; longer necessarry to drag the poof-button to expand the minibuffer - simply;; clicking on it will do.(defmethod view-click-event-handler ((p poof-button) where)  ;(declare (ignore where))  (let* ((mb (view-container p))         (w (view-container mb))         (superior (do ((l (ordered-subviews w) (cdr l)))                       ((null l))                     (when (null (cddr l))(return (car l)))))         (s-tl (view-position superior))         (s-br (add-points (view-position superior)                           (subtract-points (view-size superior) #@(1 1)))))    (let* ((mouse-pos (convert-coordinates where mb w)) ; (view-mouse-position w))           (my-min (view-minimum-size superior))           (pos (convert-coordinates (view-position p)                                      mb ;(view-container mb)                                     w))            min max min-pos max-pos drawn delta)      (setq min (point-h s-tl)     ; min and max are extent of line            max (- (point-h s-br) 2)                        max-pos (+ (point-v (view-position superior))   ; min-pos and max-pos are extent of drag                        (point-v (view-size superior)) -1)            min-pos (+ (point-v my-min) (point-v (view-position superior)))            pos (+ (point-v pos) (point-v (view-size mb)) -1) ; just (point-v pos) is also interesting            delta (- pos (point-v mouse-pos)))      (flet ((draw-line (pos)                                  (draw-dragger-outline                w p pos min max :horizontal                (or (< pos min-pos)(> pos max-pos)))))        (declare (dynamic-extent #'draw-line))        ;(format t "~% pos ~S min-pos ~S max-pos ~S" pos min-pos max-pos)        (multiple-value-setq (pos drawn)          (track-and-draw w #'draw-line pos :vertical delta min-pos max-pos))        (when drawn          (when (<= pos (- max-pos #+ignore 15 0))            (setf pos (min pos (- max-pos 45)))            (set-view-container p nil)            (set-view-position mb -1 pos)                        (setf (h-scroll-fraction superior) nil)                              (let* ((h-scroller (h-scroller superior))                                      (h-size (point-h (view-size superior))))              (when h-scroller                (set-pane-splitter-position h-scroller  :left)                (setf (pane-splitter-cursor (pane-splitter h-scroller)) *left-ps-cursor*))              (make-instance 'bar-dragger                :split-view-direction :vertical                :view-container superior                :view-nick-name 'bar-dragger                :view-position #@(-3000 -3000))              (set-view-size mb h-size (1+ (- max-pos pos)))              (set-view-size superior h-size (- (point-v (view-size superior))(- max-pos pos)))              (add-remove-scroll-bars mb)))          (fred-update w) ; added 7/3 - lose caret turds          )        (set-current-key-handler w (fred-item superior) nil)))));; Collape the minibuffer when there is less than a line visible in it.;; Note that this might simplify add-remove-scroll-bars as we no longer use the middle state.;; The code in the around method is redundant if this functionality is integrated in MCL,;; just change the constant '15' to '30' in inner method instead!(defmethod drag-split :around ((w fred-window) dragger pos direction drawn in-drag-range view-one view-two)  (declare (ignore dragger direction))  (when (and drawn             in-drag-range             (eq view-two (view-container (view-mini-buffer w)))             (<= (- (point-v (view-size view-two))                     (- pos (point-v (view-position view-two)))) 30))    (when (not (typep view-one 'split-view))      (un-poof  view-one view-two))    (return-from drag-split nil))  (call-next-method))#| Old redefinition, but conflicts with drag-split in Alice's Fred-Placards.lisp(defmethod drag-split ((w fred-window)                        dragger pos direction drawn in-drag-range view-one view-two)  (when drawn    (if (eq direction :horizontal) (error "asdf"))    (let* ((delta (- pos (point-v (view-position view-two))))           (subviews (ordered-subviews w))           (size1 (view-size view-one))           (size2 (view-size view-two)))      (when (not (= 0 delta))        (cond          (in-drag-range          (let* ((width (point-h size1))                 (mb (view-container (view-mini-buffer w)))                 (v (- (point-v size2) delta)))            (when (eq view-two mb)              (when (<= v 30)                (when (not (typep view-one 'split-view))                  (un-poof  view-one view-two))                (return-from drag-split nil)))            (set-view-position view-two -1 pos)            (set-view-size view-one width (+ (point-v size1) delta))            (set-view-size view-two width v)            (if (eq view-two mb)              (add-remove-scroll-bars mb)              (progn                 (kill-erase-region (view-window view-one))                (validate-scroll-bar view-two :horizontal)))))         (t (when (> (length subviews) 2)              (cond               ((> delta 0) ; lose inferior - unless last                (when (eq view-two (car (last subviews)))                  (return-from drag-split nil))                (let* ((mb (view-mini-buffer w))                       (mb-container (and mb (view-container mb)))                       (poof (and mb (view-named 'poof mb-container))))                  (when (and poof (view-superior-p view-two mb-container))                    (if (typep view-one 'split-view)                      (progn  (poof view-two mb-container)                              (setq size2 (view-size view-two)))                      (progn                         (set-view-container dragger nil)                        (let* ((scroller (h-scroller view-one))                               (splitter (pane-splitter scroller)))                          (when splitter                            (set-pane-splitter-position scroller :right)                            (setf (pane-splitter-cursor splitter) *right-ps-cursor*)))                        (setf (h-scroll-fraction view-one) 4)))))                                          (when (key-handler-in-p view-two)                  (set-current-key-handler w (find-a-key-handler view-one) nil))                (remove-ordered-subview view-two w))                            (t ; lose superior                (when (key-handler-in-p view-one)                  (set-current-key-handler w (find-a-key-handler view-two) nil))                                  (remove-ordered-subview view-one w)                                  (set-view-position view-two (view-position view-one))                (setq view-one view-two)))                          (set-view-size view-one                              (point-h size1)                             (+ (point-v size1) (point-v size2) -1)))))))))|#) ;; end redefine;; --------------------------------------------------------------;; DO NOT EDIT BEYOND THIS LINE(provide :fred-package-indicator)