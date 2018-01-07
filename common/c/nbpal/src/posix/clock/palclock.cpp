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

/*--------------------------------------------------------------------------

(C) Copyright 2012 by TeleCommunication Systems

The information contained herein is confidential, proprietary
to Networks In Motion, Inc., and considered a trade secret as
defined in section 499C of the penal code of the State of
California. Use of this information by anyone other than
authorized employees of Networks In Motion is granted only
under a written non-disclosure agreement, expressly
prescribing the scope and manner of such use.

---------------------------------------------------------------------------*/
#include <sys/time.h>
#include <time.h>
#include "paltypes.h"
#include "palclock.h"
#include "palstdlib.h"

#define GPS_TO_UNIX_OFFSET 315964800
#define NMSEC_PER_SEC      1000
#define NUSEC_PER_MSEC     1000
#define NNSEC_PER_MSEC     1000000

PAL_DEF nb_gpsTime
PAL_ClockGetGPSTime()
{
    return time(NULL) - GPS_TO_UNIX_OFFSET;
}

PAL_DEF nb_unixTime
PAL_ClockGetUnixTime()
{
    return time(NULL);
}

PAL_DEF PAL_Error
PAL_ClockGetDateTime(PAL_ClockDateTime* pDateTime)
{
    struct timeval tv;
    struct tm currentTime;

    /* Ensure that we have a valid pointer to copy date/time into */
    if(!pDateTime)
    {
        return PAL_ErrBadParam;
    }

    /* Get the local date/time from the system */
    if (gettimeofday(&tv, NULL) != 0)
    {
        return PAL_Failed;
    }

    if (localtime_r(&tv.tv_sec, &currentTime) == NULL)
    {
        return PAL_Failed;
    }

    /* Copy the date/time to the PAL_TimeDateTime structure */
    pDateTime->year             = currentTime.tm_year + 1900;   /*  tm_year : year since 1900 */
    pDateTime->month            = currentTime.tm_mon + 1;       /*  tm_mon : 0 - 11 */
    pDateTime->day              = currentTime.tm_mday;
    pDateTime->dayOfWeek        = currentTime.tm_wday;
    pDateTime->hour             = currentTime.tm_hour;
    pDateTime->minute           = currentTime.tm_min;
    pDateTime->second           = currentTime.tm_sec;
    pDateTime->milliseconds     = (tv.tv_usec / 1000);
    pDateTime->daylightSaving   = currentTime.tm_isdst;

    time_t localTimeT = mktime(&currentTime);
    struct tm* gmTime = gmtime(&localTimeT);                        /* Get the GM Time (UTC) from the local time */
    time_t gmTimeT = mktime(gmTime);                                /* Convert gm time to time_t (allows calculations)*/

    pDateTime->timezone = difftime(localTimeT, gmTimeT) / 3600;    /* get the difference and divide to 1 hour, to get the time zone */

    return PAL_Ok;
}
PAL_DEF uint32
PAL_ClockGetTimeMs()
{
    // This function will get the absolute elapsed wall-clock.
    // It won't be affected by changes in the system time-of-day clock.
    struct timespec time;
    if (clock_gettime(CLOCK_MONOTONIC, &time) != 0)
    {
        // This case could not happen.
        nsl_assert(FALSE);
        return 0;
    }
    return (time.tv_sec * NMSEC_PER_SEC) + (time.tv_nsec / NNSEC_PER_MSEC);
}
