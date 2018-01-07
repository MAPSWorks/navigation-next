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

/*****************************************************************/
/*                                                               */
/* (C) Copyright 2008 by Networks In Motion, Inc.                */
/*                                                               */
/* The information contained herein is confidential, proprietary */
/* to Networks In Motion, Inc., and considered a trade secret as */
/* defined in section 499C of the penal code of the State of     */
/* California. Use of this information by anyone other than      */
/* authorized employees of Networks In Motion is granted only    */
/* under a written non-disclosure agreement, expressly           */
/* prescribing the scope and manner of such use.                 */
/*                                                               */
/*****************************************************************/

/*-
 * data_asr_reco_reply.h: created 2008/04/29 by NikunK.
 */

#ifndef DATA_ASR_RECO_REPLY_H
#define DATA_ASR_RECO_REPLY_H

#include "datautil.h"
#include "data_sliceres.h"
#include "data_locmatch.h"
#include "data_iter_result.h"
#include "data_proxmatch.h"
#include "data_locmatch.h"
#include "data_string.h"
#include "abexp.h"

typedef struct data_asr_reco_reply_ {

	/* Child Elements */
	struct CSL_Vector*		vec_proxmatch;
	uint32	iter_result;
	struct CSL_Vector*		vec_locmatch;
	struct CSL_Vector*		vec_data_elem_id;

	/* Attributes */
	uint32	completion_code;
	data_string	asr_id;
	data_string	ambiguous_interaction;

} data_asr_reco_reply;

NB_Error	data_asr_reco_reply_init(data_util_state* pds, data_asr_reco_reply* pgr);
void		data_asr_reco_reply_free(data_util_state* pds, data_asr_reco_reply* pgr);

NB_Error	data_asr_reco_reply_from_tps(data_util_state* pds, data_asr_reco_reply* pgr, tpselt te);

boolean		data_asr_reco_reply_equal(data_util_state* pds, data_asr_reco_reply* pgr1, data_asr_reco_reply* pgr2);
NB_Error	data_asr_reco_reply_copy(data_util_state* pds, data_asr_reco_reply* pgr_dest, data_asr_reco_reply* pgr_src);

#endif