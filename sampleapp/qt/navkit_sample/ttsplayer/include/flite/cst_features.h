/*
Copyright (c) 2018, TeleCommunication Systems, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
   * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the TeleCommunication Systems, Inc., nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED. IN NO EVENT SHALL TELECOMMUNICATION SYSTEMS, INC.BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*************************************************************************/
/*                                                                       */
/*                  Language Technologies Institute                      */
/*                     Carnegie Mellon University                        */
/*                        Copyright (c) 1999                             */
/*                        All Rights Reserved.                           */
/*                                                                       */
/*  Permission is hereby granted, free of charge, to use and distribute  */
/*  this software and its documentation without restriction, including   */
/*  without limitation the rights to use, copy, modify, merge, publish,  */
/*  distribute, sublicense, and/or sell copies of this work, and to      */
/*  permit persons to whom this work is furnished to do so, subject to   */
/*  the following conditions:                                            */
/*   1. The code must retain the above copyright notice, this list of    */
/*      conditions and the following disclaimer.                         */
/*   2. Any modifications must be clearly marked as such.                */
/*   3. Original authors' names are not deleted.                         */
/*   4. The authors' names are not used to endorse or promote products   */
/*      derived from this software without specific prior written        */
/*      permission.                                                      */
/*                                                                       */
/*  CARNEGIE MELLON UNIVERSITY AND THE CONTRIBUTORS TO THIS WORK         */
/*  DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING      */
/*  ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT   */
/*  SHALL CARNEGIE MELLON UNIVERSITY NOR THE CONTRIBUTORS BE LIABLE      */
/*  FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES    */
/*  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN   */
/*  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,          */
/*  ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF       */
/*  THIS SOFTWARE.                                                       */
/*                                                                       */
/*************************************************************************/
/*             Author:  Alan W Black (awb@cs.cmu.edu)                    */
/*               Date:  December 1999                                    */
/*************************************************************************/
/*                                                                       */
/*  feature-values lists                                                 */
/*                                                                       */
/*************************************************************************/
#ifndef _CST_FEATURES_H__
#define _CST_FEATURES_H__

#include "cst_alloc.h"
#include "cst_val.h"
#include "cst_string.h"

typedef struct cst_featvalpair_struct {
    const char *name;
    cst_val *val;
    struct cst_featvalpair_struct *next;
} cst_featvalpair;

typedef struct cst_features_struct {
    struct cst_featvalpair_struct *head;
    cst_alloc_context ctx;
} cst_features;

/* Constructor functions */
cst_features *new_features(void);
cst_features *new_features_local(cst_alloc_context ctx);
void delete_features(cst_features *f);

/* Accessor functions */
int feat_int(const cst_features *f, const char *name);
float feat_float(const cst_features *f, const char *name);
const char *feat_string(const cst_features *f, const char *name);
const cst_val *feat_val(const cst_features *f, const char *name);

int get_param_int(const cst_features *f, const char *name,int def);
float get_param_float(const cst_features *f, const char *name, float def);
const char *get_param_string(const cst_features *f, const char *name, const char *def);
const cst_val *get_param_val(const cst_features *f, const char *name, cst_val *def);

/* Setting functions */
void feat_set_int(cst_features *f, const char *name, int v);
void feat_set_float(cst_features *f, const char *name, float v);
void feat_set_string(cst_features *f, const char *name, const char *v);
void feat_set(cst_features *f, const char *name,const cst_val *v);

int feat_remove(cst_features *f,const char *name);
int feat_present(const cst_features *f,const char *name);
int feat_length(const cst_features *f);

CST_VAL_USER_TYPE_DCLS(features,cst_features)

int feat_copy_into(const cst_features *from,cst_features *to);
int feat_print(cst_file fd,const cst_features *f);

#endif
