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

@file     PoiSearch.h
@date     09/08/2011
@author   Sandeep Agrrawal

*/

/*! @{ */
#pragma once
#ifndef __POI_SEARCH_H__
#define __POI_SEARCH_H__


#include "NcdbTypes.h"
#include "SpatialPoiTypes.h"
#include "AutoArray.h"
#include "AutoSharedPtr.h"
#include <map>
#include <assert.h>

//class Map;


namespace Ncdb
{
class Session;
class PoiSearchControlManager;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class NCDB_API PoiSearch
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{
public:
	
	//!	@brief Construct the poi search class and attach the session.
	//! @param[in] Session The database session to access data from.
    PoiSearch(Session &Session, UtfString ctryName = "USA");
	
	//! @brief Destructor
	~PoiSearch(void);
	//!	@brief This API will start a search session for getting point of
	//! interest objects around given location.
	//! @param[in] searchLocation	Coordinate of location around which search shoule be done.
	//! @param[in] radius			extent of search.
	//! @param[in] criteria			Search crireria to select pois, NCDB will copy it
	ReturnCode search( const WorldPoint& searchLocation, float radius, SEARCH_CRITERIA* criteria);

	//! @brief Return next searched group of Pois. It is responsibily of caller to release objects
	//! that are returned in "pois" array as response
	ReturnCode getNextGroup( AutoArray<AutoSharedPtr<SpatialPoi> >& pois, SupportedLanguages languageCode = US_English );

    ReturnCode Search( PoiSearchRequest& searchRequest, AutoArray<AutoSharedPtr<SpatialPoi> >& pois, UtfString country = "USA");

	
	//! @brief This API will return type/sub-type ids and name. It is responsibily of caller to
	//! release objects that are returned in "typeData" array as response
	//!
	//! @param[in]	typeId			If typeId is -1 then main types will be returned
	//!								If typeId is one of the main type-id then sub-types will be returned
	//! @param[in]	languageCode	Language for type name
	//! @param[out] typeInfo		List of type information
    ReturnCode getTypeInformation( AutoArray<AutoSharedPtr<TYPE_DATA> >& typeData, int typeId,
		SupportedLanguages languageCode = US_English );
	
	bool isValid();
    //! Get Internal pointer (for internal test only)
    PoiSearchControlManager*  GetPoiSearchControlManager()
    {
        return m_PoiManager; 
    }
private:
    //! The database to access.
	Session* m_Session;
    PoiSearchControlManager* m_PoiManager;     // for both single and multi maps
};
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


};
#endif // __POI_SEARCH_H__
/*! @} */

