(in-package :TRAPS)
; Generated from #P"macintosh-hd:hd3:CInterface Translator:Source Interfaces:IOGraphicsDevice.h"
; at Sunday July 2,2006 7:28:48 pm.
; 
;  * Copyright (c) 1998-2000 Apple Computer, Inc. All rights reserved.
;  *
;  * @APPLE_LICENSE_HEADER_START@
;  * 
;  * The contents of this file constitute Original Code as defined in and
;  * are subject to the Apple Public Source License Version 1.1 (the
;  * "License").  You may not use this file except in compliance with the
;  * License.  Please obtain a copy of the License at
;  * http://www.apple.com/publicsource and read it before using this file.
;  * 
;  * This Original Code and all software distributed under the License are
;  * distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, EITHER
;  * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
;  * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
;  * FITNESS FOR A PARTICULAR PURPOSE OR NON-INFRINGEMENT.  Please see the
;  * License for the specific language governing rights and limitations
;  * under the License.
;  * 
;  * @APPLE_LICENSE_HEADER_END@
;  
; #ifndef _IOKIT_IOGRAPHICSDEVICE_H
; #define _IOKIT_IOGRAPHICSDEVICE_H

(require-interface "IOKit/IOService")

(require-interface "IOKit/graphics/IOGraphicsTypes")
#|
 confused about CLASS IOGraphicsDevice #\: public IOService #\{ OSDeclareAbstractStructors #\( IOGraphicsDevice #\) public #\: virtual void hideCursor #\( void #\) = 0 #\; virtual void showCursor #\( Point * cursorLoc #\, int frame #\) = 0 #\; virtual void moveCursor #\( Point * cursorLoc #\, int frame #\) = 0 #\; virtual void getVBLTime #\( AbsoluteTime * time #\, AbsoluteTime * delta #\) = 0 #\; virtual void getBoundingRect #\( Bounds ** bounds #\) = 0 #\;
|#

; #endif /* ! _IOKIT_IOGRAPHICSDEVICE_H */


(provide-interface "IOGraphicsDevice")