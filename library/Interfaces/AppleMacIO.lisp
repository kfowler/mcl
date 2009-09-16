(in-package :TRAPS)
; Generated from #P"macintosh-hd:hd3:CInterface Translator:Source Interfaces:AppleMacIO.h"
; at Sunday July 2,2006 7:25:40 pm.
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
; 
;  * Copyright (c) 1998 Apple Computer, Inc.  All rights reserved. 
;  *
;  * HISTORY
;  *
;  
; #ifndef _IOKIT_APPLEMACIO_H
; #define _IOKIT_APPLEMACIO_H

(require-interface "IOKit/IOService")

(require-interface "IOKit/platform/AppleMacIODevice")
#|
 confused about CLASS AppleMacIO #\: public IOService #\{ OSDeclareAbstractStructors #\( AppleMacIO #\) #\; IOService * fNub #\; IOMemoryMap * fMemory #\; struct ExpansionData #\{ #\} #\; ExpansionData * fReserved #\; protected #\: virtual bool selfTest #\( void #\) #\; public #\: virtual bool start #\( IOService * provider #\) #\; virtual IOService * createNub #\( IORegistryEntry * from #\) #\; virtual void processNub #\( IOService * nub #\) #\; virtual void publishBelow #\( IORegistryEntry * root #\) #\; virtual const char * deleteList #\( void #\) #\; virtual const char * excludeList #\( void #\) #\; virtual bool compareNubName #\( const IOService * nub #\, OSString * name #\, OSString ** matched = 0 #\) const #\; virtual IOReturn getNubResources #\( IOService * nub #\) #\; OSMetaClassDeclareReservedUnused #\( AppleMacIO #\, 0 #\) #\; OSMetaClassDeclareReservedUnused #\( AppleMacIO #\, 1 #\) #\; OSMetaClassDeclareReservedUnused #\( AppleMacIO #\, 2 #\) #\; OSMetaClassDeclareReservedUnused #\( AppleMacIO #\, 3 #\) #\;
|#

; #endif /* ! _IOKIT_APPLEMACIO_H */


(provide-interface "AppleMacIO")