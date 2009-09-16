(in-package :TRAPS)
; Generated from #P"macintosh-hd:hd3:CInterface Translator:Source Interfaces:rot.h"
; at Sunday July 2,2006 7:31:27 pm.
; 
;  * rot.h
;  *
;  * FUNCTION:
;  * rotation matrix utilities
;  *
;  * HISTORY:
;  * Linas Vepstas Aug 1990
;  
;  ========================================================== 
;  
;  * The MACROS below generate and return more traditional rotation
;  * matrices -- matrices for rotations about principal axes.
;  
;  ========================================================== 
; #define ROTX_CS(m,cosine,sine)		{					   /* rotation about the x-axis */						   m[0][0] = 1.0;			   m[0][1] = 0.0;			   m[0][2] = 0.0;			   m[0][3] = 0.0;								   m[1][0] = 0.0;			   m[1][1] = (cosine);			   m[1][2] = (sine);			   m[1][3] = 0.0;								   m[2][0] = 0.0;			   m[2][1] = -(sine);			   m[2][2] = (cosine);			   m[2][3] = 0.0;								   m[3][0] = 0.0;			   m[3][1] = 0.0;			   m[3][2] = 0.0;			   m[3][3] = 1.0;			}				
;  ========================================================== 
; #define ROTY_CS(m,cosine,sine)		{					   /* rotation about the y-axis */						   m[0][0] = (cosine);			   m[0][1] = 0.0;			   m[0][2] = -(sine);			   m[0][3] = 0.0;								   m[1][0] = 0.0;			   m[1][1] = 1.0;			   m[1][2] = 0.0;			   m[1][3] = 0.0;								   m[2][0] = (sine);			   m[2][1] = 0.0;			   m[2][2] = (cosine);			   m[2][3] = 0.0;								   m[3][0] = 0.0;			   m[3][1] = 0.0;			   m[3][2] = 0.0;			   m[3][3] = 1.0;			}
;  ========================================================== 
; #define ROTZ_CS(m,cosine,sine)		{					   /* rotation about the z-axis */						   m[0][0] = (cosine);			   m[0][1] = (sine);			   m[0][2] = 0.0;			   m[0][3] = 0.0;								   m[1][0] = -(sine);			   m[1][1] = (cosine);			   m[1][2] = 0.0;			   m[1][3] = 0.0;								   m[2][0] = 0.0;			   m[2][1] = 0.0;			   m[2][2] = 1.0;			   m[2][3] = 0.0;								   m[3][0] = 0.0;			   m[3][1] = 0.0;			   m[3][2] = 0.0;			   m[3][3] = 1.0;			}
;  ========================================================== 

(provide-interface "rot")