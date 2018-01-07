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

    @file     abfilesetparameters.h
*/
/*
    (C) Copyright 2014 by TeleCommunication Systems, Inc.                

    The information contained herein is confidential, proprietary 
    to TeleCommunication Systems, Inc., and considered a trade secret as 
    defined in section 499C of the penal code of the State of     
    California. Use of this information by anyone other than      
    authorized employees of TeleCommunication Systems is granted only    
    under a written non-disclosure agreement, expressly           
    prescribing the scope and manner of such use.                 

---------------------------------------------------------------------------*/

#ifndef ABFILESETPARAMETERS_H
#define ABFILESETPARAMETERS_H


#include "abexp.h"


/*!
    @addtogroup abfilesetparameters
    @{
*/


/*! @struct AB_FileSetParameters
    Opaque data structure that defines the parameters of a file set operation
*/
typedef struct AB_FileSetParameters AB_FileSetParameters;


/*! Create a parameters object for one or more file set server retrieval requests

@param context context instance
@param parameters On success, a newly created AB_FileSetParameters object; NULL otherwise.  A valid object must be destroyed using AB_FileSetParametersDestroy().
@returns NB_Error
*/
AB_DEC NB_Error AB_FileSetParametersCreate(
    NB_Context* context,
    AB_FileSetParameters** parameters
);


/*! Add a request to retrieve a file set from the server

@param parameters An AB_FileSetParameters object
@param fileSetName Name of fileset to retrieve
@returns NB_Error
*/
AB_DEC NB_Error AB_FileSetParametersAddFileSet(
    AB_FileSetParameters* parameters,
    const char* fileSetName
);


/*! Destroy a previously created FileSetParameters object

@param parameters An AB_FileSetParameters object created with AB_FileSetParametersCreate()
@returns NB_Error
*/
AB_DEC NB_Error AB_FileSetParametersDestroy(
    AB_FileSetParameters* parameters
);


/*! @} */

#endif