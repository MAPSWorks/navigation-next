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
/* (C) Copyright 2004 by Networks In Motion, Inc.                */
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
 * data_sliceres.c: created 2004/12/09 by Mark Goddard.
 */

#include "data_sliceres.h"

NB_Error	
data_sliceres_init(data_util_state* pds, data_sliceres* ps)
{

	ps->start = 0;
	ps->end = 0;
	ps->total = 0;

	return NE_OK;
}

void		
data_sliceres_free(data_util_state* pds, data_sliceres* ps)
{
	data_sliceres_init(pds, ps);
}

tpselt		
data_sliceres_to_tps(data_util_state* pds, data_sliceres* ps)
{
	tpselt te;

	te = te_new("sliceres");

	if (te == NULL)
		goto errexit;

	if (!te_setattru(te, "start", ps->start))
		goto errexit;

	if (!te_setattru(te, "end", ps->end))
		goto errexit;

	if (!te_setattru(te, "total", ps->total))
		goto errexit;

	return te;

errexit:

	te_dealloc(te);
	return NULL;
}

NB_Error	
data_sliceres_from_tps(data_util_state* pds, data_sliceres* ps, tpselt te)
{
	NB_Error err = NE_OK;
	
	if (te == NULL) {
		err = NE_INVAL;
		goto errexit;
	}

	data_sliceres_free(pds, ps);

	err = data_sliceres_init(pds, ps);

	if (err != NE_OK)
		goto errexit;

	ps->start = te_getattru(te, "start");
	ps->end   = te_getattru(te, "end");
	ps->total = te_getattru(te, "total");

errexit:
	if (err != NE_OK)
		data_sliceres_free(pds, ps);

	return err;
}

boolean		
data_sliceres_equal(data_util_state* pds, data_sliceres* ps1, data_sliceres* ps2)
{
	return	(boolean) (ps1->start == ps2->start && 
					   ps1->end == ps2->end && 
					   ps1->total == ps2->total);
}

NB_Error	
data_sliceres_copy(data_util_state* pds, data_sliceres* ps_dest, data_sliceres* ps_src)
{
	NB_Error err = NE_OK;

	data_sliceres_free(pds, ps_dest);

	err = err ? err : data_sliceres_init(pds, ps_dest);

	ps_dest->start = ps_src->start;
	ps_dest->end   = ps_src->end;
	ps_dest->total = ps_src->total;

	return err;
}
