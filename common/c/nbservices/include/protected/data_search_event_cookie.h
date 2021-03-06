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

/*!--------------------------------------------------------------------------

    @file     data_search_event_cookie.h

    Interface for Search Event Cookie TPS element.

*/
/*
    (C) Copyright 2010 by Networks In Motion, Inc.

    The information contained herein is confidential, proprietary
    to Networks In Motion, Inc., and considered a trade secret as
    defined in section 499C of the penal code of the State of
    California. Use of this information by anyone other than
    authorized employees of Networks In Motion is granted only
    under a written non-disclosure agreement, expressly
    prescribing the scope and manner of such use.

---------------------------------------------------------------------------*/

/*! @{ */

#ifndef DATA_SEARCH_EVENT_COOKIE_H
#define DATA_SEARCH_EVENT_COOKIE_H

#include "datautil.h"
#include "data_string.h"
#include "data_blob.h"
#include "nbexp.h"
#include "dynbuf.h"

typedef struct data_search_event_cookie_
{
    //Attributes
    data_string     provider_id;
    data_blob       state;

} data_search_event_cookie;

NB_DEC NB_Error    data_search_event_cookie_init(data_util_state* pds, data_search_event_cookie* psec);
NB_DEC void        data_search_event_cookie_free(data_util_state* pds, data_search_event_cookie* psec);
NB_DEC NB_Error    data_search_event_cookie_from_tps(data_util_state* pds, data_search_event_cookie* psec, tpselt te);
NB_DEC boolean     data_search_event_cookie_equal(data_util_state* pds, data_search_event_cookie* psec1, data_search_event_cookie* psec2);
NB_DEC NB_Error    data_search_event_cookie_copy(data_util_state* pds, data_search_event_cookie* psec_dest, data_search_event_cookie* psec_src);
NB_DEC tpselt      data_search_event_cookie_to_tps(data_util_state* pds, data_search_event_cookie* psec);
NB_DEC uint32      data_search_event_cookie_get_tps_size(data_util_state* pds, data_search_event_cookie* psec);

NB_DEC void data_search_event_cookie_to_buf(data_util_state* pds, data_search_event_cookie* psec, struct dynbuf* pdb);

NB_DEC NB_Error data_search_event_cookie_from_binary(data_util_state* pds, data_search_event_cookie* psec, byte** pdata, size_t* pdatalen);

#endif // DATA_SEARCH_EVENT_COOKIE_H

/*! @} */
