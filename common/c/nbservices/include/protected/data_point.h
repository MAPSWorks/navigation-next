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
 * data_point.h: created 2004/12/09 by Mark Goddard.
 */

#ifndef DATA_POINT_
#define DATA_POINT_

#include "datautil.h"
#include "dynbuf.h"
#include "nbexp.h"

typedef struct data_point_ {

	double	lat;
	double	lon;
} data_point;

NB_Error	data_point_init(data_util_state* pds, data_point* pdp);
void		data_point_free(data_util_state* pds, data_point* pdp);

tpselt		data_point_to_tps(data_util_state* pds, data_point* pdp);
NB_Error	data_point_from_tps(data_util_state* pds, data_point* pdp, tpselt te);

boolean		data_point_equal(data_util_state* pds, data_point* pdp1, data_point* pdp2);
NB_Error	data_point_copy(data_util_state* pds, data_point* pdp_dest, data_point* pdp_src);

NB_Error	data_point_from_latlon(data_util_state* pds, data_point* pdp, double lat, double lon);

uint32      data_point_get_tps_size(data_util_state* pds, data_point* pdp);
void        data_point_to_buf(data_util_state* pds, data_point* pdp, struct dynbuf *dbp);
NB_Error    data_point_from_binary(data_util_state* pds, data_point* pdp, byte** ppdata, size_t* pdatalen);

#endif

