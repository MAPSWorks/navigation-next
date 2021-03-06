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

    @file     data_metadata_source_query.h
*/
/*
    (C) Copyright 2011 by TeleCommunications Systems, Inc.

    The information contained herein is confidential, proprietary
    to TeleCommunication Systems, Inc., and considered a trade secret as
    defined in section 499C of the penal code of the State of
    California. Use of this information by anyone other than
    authorized employees of Networks In Motion is granted only
    under a written non-disclosure agreement, expressly
    prescribing the scope and manner of such use.
---------------------------------------------------------------------------*/

#ifndef DATA_METADATA_SOURCE_QUERY_H
#define DATA_METADATA_SOURCE_QUERY_H

/*! @{ */

#include "datautil.h"
#include "data_string.h"

typedef struct data_metadata_source_query_
{
    /* Child Elements */
    CSL_Vector*     vec_wanted_content;     /*!< Request specific type of data (junction models,
                                                 realistic road signs, city models, map tiles, etc.) */
    nb_boolean      want_extended_maps;     /*!< If present, the client can handle extended map tile
                                                 configurations in the reply */
    nb_boolean      want_shared_maps;       /*!< If present, the client can handle
                                                 extended maps configurations that
                                                 include want-extended-maps
                                                 functionality as well as the new
                                                 tile-store-template in the
                                                 url-args-template included with
                                                 the reply. */
    nb_boolean      want_unified_maps;      /*!< If present, the client can handle
                                                 the unified map tile
                                                 configurations in the reply. */
    CSL_Vector*     vec_want_extapp_contents;   /*!< Specifies wanted ext app content */
    /* Attributes */
    data_string     language;           /*!< The current language setting of the device. */
    uint32          screen_width;       /*!< The screen width of the device, specified in pixels.*/
    uint32          screen_height;      /*!< The screen height of the device, specified in pixels.*/
    uint32          screen_resolution;  /*!< The resolution of the screen, specified in DPI */
    uint64          time_stamp;         /*!< Time stamp of last received
                                             metadata-source-reply.*/
} data_metadata_source_query;

NB_Error    data_metadata_source_query_init(data_util_state* state, data_metadata_source_query* metadataSourceQuery);
void        data_metadata_source_query_free(data_util_state* state, data_metadata_source_query* metadataSourceQuery);

tpselt      data_metadata_source_query_to_tps(data_util_state* state, data_metadata_source_query* metadataSourceQuery);

NB_Error    data_metadata_source_query_add_wanted_content(data_util_state* state, data_metadata_source_query* metadataSourceQuery, const char* country, const char* dataset_id, const char* type);

NB_Error    data_metadata_source_query_add_extapp_content(data_util_state* state, data_metadata_source_query* metadataSourceQuery, const char* appCode);

/*! @} */

#endif
