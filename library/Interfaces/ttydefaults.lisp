(in-package :TRAPS)
; Generated from #P"macintosh-hd:hd3:CInterface Translator:Source Interfaces:ttydefaults.h"
; at Sunday July 2,2006 7:32:02 pm.
; 
;  * Copyright (c) 2000-2002 Apple Computer, Inc. All rights reserved.
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
;  Copyright (c) 1997 Apple Computer, Inc. All Rights Reserved 
; -
;  * Copyright (c) 1982, 1986, 1993
;  *	The Regents of the University of California.  All rights reserved.
;  * (c) UNIX System Laboratories, Inc.
;  * All or some portions of this file are derived from material licensed
;  * to the University of California by American Telephone and Telegraph
;  * Co. or Unix System Laboratories, Inc. and are reproduced herein with
;  * the permission of UNIX System Laboratories, Inc.
;  *
;  * Redistribution and use in source and binary forms, with or without
;  * modification, are permitted provided that the following conditions
;  * are met:
;  * 1. Redistributions of source code must retain the above copyright
;  *    notice, this list of conditions and the following disclaimer.
;  * 2. Redistributions in binary form must reproduce the above copyright
;  *    notice, this list of conditions and the following disclaimer in the
;  *    documentation and/or other materials provided with the distribution.
;  * 3. All advertising materials mentioning features or use of this software
;  *    must display the following acknowledgement:
;  *      This product includes software developed by the University of
;  *      California, Berkeley and its contributors.
;  * 4. Neither the name of the University nor the names of its contributors
;  *    may be used to endorse or promote products derived from this software
;  *    without specific prior written permission.
;  *
;  * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
;  * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;  * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
;  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
;  * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;  * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;  * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
;  * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
;  * SUCH DAMAGE.
;  *
;  *	@(#)ttydefaults.h	8.4 (Berkeley) 1/21/94
;  
; 
;  * System wide defaults for terminal state.
;  
; #ifndef _SYS_TTYDEFAULTS_H_
; #define	_SYS_TTYDEFAULTS_H_
; 
;  * Defaults on "first" open.
;  
(defconstant $TTYDEF_IFLAG 11010)
; #define	TTYDEF_IFLAG	(BRKINT	| ICRNL	| IMAXBEL | IXON | IXANY)
(defconstant $TTYDEF_OFLAG 3)
; #define TTYDEF_OFLAG	(OPOST | ONLCR)
(defconstant $TTYDEF_LFLAG 1483)
; #define TTYDEF_LFLAG	(ECHO | ICANON | ISIG | IEXTEN | ECHOE|ECHOKE|ECHOCTL)
(defconstant $TTYDEF_CFLAG 19200)
; #define	TTYDEF_CFLAG	(CREAD | CS8 | HUPCL)
(defconstant $TTYDEF_SPEED 9600)
; #define TTYDEF_SPEED	(B9600)
; 
;  * Control Character Defaults
;  
(defconstant $CTRL 0)
; #define CTRL(x)	(x&037)
; #define	CEOF		CTRL('d')
(defconstant $CEOL 255)
; #define	CEOL		0xff		/* XXX avoid _POSIX_VDISABLE */
(defconstant $CERASE 177)
; #define	CERASE		0177
; #define	CINTR		CTRL('c')
(defconstant $CSTATUS 255)
; #define	CSTATUS		0xff		/* XXX avoid _POSIX_VDISABLE */
; #define	CKILL		CTRL('u')
(defconstant $CMIN 1)
; #define	CMIN		1
(defconstant $CQUIT 34)
; #define	CQUIT		034		/* FS, ^\ */
; #define	CSUSP		CTRL('z')
(defconstant $CTIME 0)
; #define	CTIME		0
; #define	CDSUSP		CTRL('y')
; #define	CSTART		CTRL('q')
; #define	CSTOP		CTRL('s')
; #define	CLNEXT		CTRL('v')
; #define	CDISCARD 	CTRL('o')
; #define	CWERASE 	CTRL('w')
; #define	CREPRINT 	CTRL('r')
; #define	CEOT		CEOF
;  compat 
; #define	CBRK		CEOL
; #define CRPRNT		CREPRINT
; #define	CFLUSH		CDISCARD
;  PROTECTED INCLUSION ENDS HERE 

; #endif /* !_SYS_TTYDEFAULTS_H_ */

; 
;  * #define TTYDEFCHARS to include an array of default control characters.
;  
; #ifdef TTYDEFCHARS
#| #|
static cc_t	ttydefchars[NCCS] = {
	CEOF,	CEOL,	CEOL,	CERASE, CWERASE, CKILL, CREPRINT,
	_POSIX_VDISABLE, CINTR,	CQUIT,	CSUSP,	CDSUSP,	CSTART,	CSTOP,	CLNEXT,
	CDISCARD, CMIN,	CTIME,  CSTATUS, _POSIX_VDISABLE
};
#undef TTYDEFCHARS
#endif
|#
 |#

(provide-interface "ttydefaults")