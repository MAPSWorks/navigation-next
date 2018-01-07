/* 
 * Copyright (C) 2015 The Qt Company Ltd.
 * Contact: http://www.qt.io/licensing/
 * 
 * This file is part of the plugins of the Qt Toolkit.
 * 
 * $QT_BEGIN_LICENSE:BSD$
 * You may use this file under the terms of the BSD license as follows:
 * 
 * "Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 * * Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in
 * the documentation and/or other materials provided with the
 * distribution.
 * * Neither the name of The Qt Company Ltd nor the names of its
 * contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 * 
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
 * 
 * $QT_END_LICENSE$
 */

#ifndef HARDWARE_INTEGRATION_SERVER_PROTOCOL_H
#define HARDWARE_INTEGRATION_SERVER_PROTOCOL_H

#ifdef  __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stddef.h>
#include "wayland-server.h"

struct wl_client;
struct wl_resource;

struct qt_hardware_integration;

extern const struct wl_interface qt_hardware_integration_interface;

#define QT_HARDWARE_INTEGRATION_CLIENT_BACKEND	0
#define QT_HARDWARE_INTEGRATION_SERVER_BACKEND	1

#define QT_HARDWARE_INTEGRATION_CLIENT_BACKEND_SINCE_VERSION	1
#define QT_HARDWARE_INTEGRATION_SERVER_BACKEND_SINCE_VERSION	1

static inline void
qt_hardware_integration_send_client_backend(struct wl_resource *resource_, const char *name)
{
	wl_resource_post_event(resource_, QT_HARDWARE_INTEGRATION_CLIENT_BACKEND, name);
}

static inline void
qt_hardware_integration_send_server_backend(struct wl_resource *resource_, const char *name)
{
	wl_resource_post_event(resource_, QT_HARDWARE_INTEGRATION_SERVER_BACKEND, name);
}

#ifdef  __cplusplus
}
#endif

#endif