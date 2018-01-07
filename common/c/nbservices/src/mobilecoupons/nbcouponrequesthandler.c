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

    @file     nbcouponrequesthandler.c
*/
/*
    (C) Copyright 2011 by TeleCommunication Systems, Inc.             

    The information contained herein is confidential, proprietary 
    to TeleCommunication Systems, Inc., and considered a trade secret as 
    defined in section 499C of the penal code of the State of     
    California. Use of this information by anyone other than      
    authorized employees of TeleCommunication Systems, Inc. is granted only    
    under a written non-disclosure agreement, expressly           
    prescribing the scope and manner of such use.                 

---------------------------------------------------------------------------*/

/*! @{ */

#include "nbcouponrequesthandler.h"
#include "nbcouponrequestparametersprivate.h"
#include "nbcouponrequestinformationprivate.h"
#include "nbmobilecouponsprivate.h"
#include "nbcontextprotected.h"
#include "cslnetwork.h"
#include "nbutilityprotected.h"
#include "data_coupon_query.h"

typedef struct CouponRequestHandler_Query
{
    NB_NetworkQuery           networkQuery;
    NB_CouponRequestHandler*  pThis;
} CouponRequestHandler_Query;


struct NB_CouponRequestHandler
{
    NB_Context*                 context;
    NB_RequestHandlerCallback   callback;
    boolean                     inProgress;
    CouponRequestHandler_Query  query;
    tpselt                      tpsReply;
    data_coupon_query           lastQuery;
};

static void CouponRequestHandler_NetworkCallback(NB_NetworkQuery* query, NB_NetworkResponse* response);
static void CouponRequestHandler_NetworkProgressCallback(NB_NetworkQuery* query, boolean up, uint32 have, uint32 total);

NB_DEF NB_Error
NB_CouponRequestHandlerCreate(NB_Context* context, NB_RequestHandlerCallback* callback,
                             NB_CouponRequestHandler** handler)
{
    NB_CouponRequestHandler* pThis = NULL;

    if (context == NULL || handler == NULL)
    {
        return NE_INVAL;
    }

    pThis = nsl_malloc(sizeof(NB_CouponRequestHandler));
    if (pThis == NULL)
    {
        return NE_NOMEM;
    }
    nsl_memset(pThis, 0, sizeof(NB_CouponRequestHandler));

    pThis->context = context;
    if (callback != NULL)
    {
        pThis->callback.callback = callback->callback;
        pThis->callback.callbackData = callback->callbackData;
    }

    pThis->query.pThis = pThis;
    pThis->query.networkQuery.action = CouponRequestHandler_NetworkCallback;
    pThis->query.networkQuery.progress = CouponRequestHandler_NetworkProgressCallback;
    pThis->query.networkQuery.qflags = TN_QF_DEFLATE;
    pThis->query.networkQuery.failFlags = TN_FF_CLOSE_ANY;
    nsl_strlcpy(pThis->query.networkQuery.target, NB_ContextGetTargetMapping(pThis->context, COUPONS_SERVLET), sizeof(pThis->query.networkQuery.target));
    pThis->query.networkQuery.targetlen = -1;

    data_coupon_query_init(NB_ContextGetDataState(pThis->context), &pThis->lastQuery);

    *handler = pThis;

    return NE_OK;
}

NB_DEF NB_Error
NB_CouponRequestHandlerDestroy(NB_CouponRequestHandler* handler)
{
    if (handler == NULL)
    {
        return NE_INVAL;
    }

    if (handler->inProgress)
    {
        NB_CouponRequestHandlerCancelRequest(handler);
    }

    te_dealloc(handler->query.networkQuery.query);

    data_coupon_query_free(NB_ContextGetDataState(handler->context), &handler->lastQuery);
    nsl_free(handler);

    return NE_OK;
}

NB_DEF NB_Error
NB_CouponRequestHandlerStartRequest(NB_CouponRequestHandler* handler, NB_CouponRequestParameters* parameters)
{
    NB_Error err = NE_OK;
    if (handler == NULL || parameters == NULL)
    {
        return NE_INVAL;
    }
    if (handler->inProgress)
    {
        return NE_BUSY;
    }

    te_dealloc(handler->query.networkQuery.query);

    data_coupon_query_free(NB_ContextGetDataState(handler->context), &handler->lastQuery);
    data_coupon_query_init(NB_ContextGetDataState(handler->context), &handler->lastQuery);
    err = NB_CouponRequestParametersCopyQuery(parameters, &handler->lastQuery);
    if (err != NE_OK)
    {
        return err;
    }

    handler->query.networkQuery.query = NB_CouponRequestParametersToTPSQuery(parameters);
    if (handler->query.networkQuery.query == NULL)
    {
        return NE_NOMEM;
    }

    handler->inProgress = TRUE;
    CSL_NetworkRequest(NB_ContextGetNetwork(handler->context), &handler->query.networkQuery);

    return err;
}

NB_DEF NB_Error
NB_CouponRequestHandlerCancelRequest(NB_CouponRequestHandler* handler)
{
    if (handler == NULL)
    {
        return NE_INVAL;
    }
    if (!handler->inProgress)
    {
        return NE_UNEXPECTED;
    }

    CSL_NetworkCancel(NB_ContextGetNetwork(handler->context), &handler->query.networkQuery);

    return NE_OK;
}

NB_DEF nb_boolean
NB_CouponRequestHandlerIsRequestInProgress(NB_CouponRequestHandler* handler)
{
    if (handler != NULL)
    {
        return handler->inProgress;
    }
    return FALSE;
}

NB_DEF NB_Error
NB_CouponRequestHandlerGetInformation(NB_CouponRequestHandler* handler, NB_CouponRequestInformation** information)
{
    if (handler == NULL || information == NULL)
    {
        return NE_INVAL;
    }
    if (handler->tpsReply == NULL)
    {
        return NE_UNEXPECTED;
    }

    return NB_CouponRequestInformationCreate(handler->context, handler->tpsReply, &handler->lastQuery, information);
}

void
CouponRequestHandler_NetworkCallback(NB_NetworkQuery* query, NB_NetworkResponse* response)
{
    NB_CouponRequestHandler* pThis = NULL;
    NB_NetworkRequestStatus status = NB_NetworkRequestStatus_Failed;
    NB_Error replyError = NE_OK;

    if (query == NULL || (pThis = ((CouponRequestHandler_Query*)query)->pThis) == NULL)
    {
        return;
    }
    if (response != NULL)
    {
        replyError = GetErrorCode(pThis->context, response);
        status = TranslateNetStatus(response->status);
    }

    pThis->inProgress = FALSE;
    query->query = NULL;

    if (pThis->callback.callback != NULL)
    {
        // Make reply available for duration of callback
        pThis->tpsReply = (response != NULL) ? response->reply : NULL;
        (pThis->callback.callback)(pThis, status, replyError, FALSE, 100, pThis->callback.callbackData);
        pThis->tpsReply = NULL;
    }
}

void
CouponRequestHandler_NetworkProgressCallback(NB_NetworkQuery* query, boolean up, uint32 have, uint32 total)
{
    NB_CouponRequestHandler* pThis = (query != NULL) ? ((CouponRequestHandler_Query*)query)->pThis : NULL;

    if (pThis != NULL && pThis->callback.callback != NULL)
    {
        int percent = (have * 100) / total;
        (pThis->callback.callback)(pThis, NB_NetworkRequestStatus_Progress, NE_OK, up, percent, pThis->callback.callbackData);
    }
}

/*! @} */