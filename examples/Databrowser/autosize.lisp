;;; autosize.lisp;;; Stuff that could be added to MCL to provide a general mechanism for auto-resizing subviews.;;; The idea is that any subview you want to be auto-resizable should inherit from auto-resizable-view-mixin.;;; Then it contains a slot that has the previous size of its container, and you can write a method;;; for it on auto-resize-view. (in-package :ccl)(let ((*warn-if-redefine* nil))  (defclass auto-resizable-view-mixin ()    ((previous-container-size :initarg :previous-container-size :initform nil                              :accessor previous-container-size                              :documentation "For use by auto-resize-view methods."))))(defgeneric auto-resize-view (view container)  (:documentation "Specialize this for various types of subviews. Second parameter provides a means for further     specialization as needed. You may need further specialization in cases where, e.g. you    have two databrowsers in a window, necessitating that they be both repositioned as well    as resized."))(defun maintain-corner-relationship (old-position old-size new-size)  "Find the corner of old-size that old-position is nearest and return   a new-position that's the same distance away from the same corner in   new-size."  (let ((new-h (point-h old-position)) ; assume closer to topleft        (new-v (point-v old-position))        (temp 0))    (if (> (point-h old-position) (setq temp (- (point-h old-size) (point-h old-position))))      (setq new-h (- (point-h new-size) temp))) ; closer to right edge    (if (> (point-v old-position) (setq temp (- (point-v old-size) (point-v old-position))))      (setq new-v (- (point-v new-size) temp))) ; closer to bottom edge    (make-point new-h new-v)))(defmethod auto-resize-view ((view t) (container t))  nil)(defclass check-box-dialog-item-ar (check-box-dialog-item auto-resizable-view-mixin)  ())#+DEPRECATE(defclass static-text-control-item-ar (static-text-control-item auto-resizable-view-mixin)  ()); This one seems to work now(defclass static-text-dialog-item-ar (static-text-dialog-item auto-resizable-view-mixin)  ())(defclass button-dialog-item-ar (button-dialog-item auto-resizable-view-mixin)  ())(defclass SCROLLING-FRED-VIEW-AR (scrolling-fred-view auto-resizable-view-mixin)  ())(defmethod auto-resize-view ((view check-box-dialog-item-ar) (container simple-view))  (set-view-position view (maintain-corner-relationship (view-position view)                                                     (previous-container-size view)                                                     (view-size container))))(defmethod auto-resize-view ((view button-dialog-item-ar) (container simple-view))  (set-view-position view (maintain-corner-relationship (view-position view)                                                     (previous-container-size view)                                                     (view-size container))))#+DEPRECATE(defmethod auto-resize-view ((view static-text-control-item-ar) (container simple-view))  (set-view-position view (maintain-corner-relationship (view-position view)                                                     (previous-container-size view)                                                     (view-size container))))(defmethod auto-resize-view ((view static-text-dialog-item-ar) (container simple-view))  (set-view-position view (maintain-corner-relationship (view-position view)                                                     (previous-container-size view)                                                     (view-size container))))(defmethod auto-resize-view ((view SCROLLING-FRED-VIEW-AR) (container simple-view))  (let ((delta (subtract-points (view-size container) (previous-container-size view))))    (set-view-size view (add-points (view-size view) delta))))(defmethod previous-container-size ((view t))  nil)(defmethod (setf previous-container-size) ((size t) (view t))  nil); Following two methods should take care of all auto-resizing from now on, provided;   methods for auto-resize-view are written.(defmethod set-view-size :before ((view window) h &optional v)  (declare (ignore h v))  (let* ((old-size (view-size view)))    (dovector (subview (view-subviews view))      (setf (previous-container-size subview) old-size))))(defmethod set-view-size :after ((view window) h &optional v)  (declare (ignore h v))  (dovector (subview (view-subviews view))    (auto-resize-view subview view)));;; End of auto-resizing stuff(provide :autosize) 