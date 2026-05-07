#!/usr/bin/env bash

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/host/run/user/$UID/bus"
export ELECTRON_OZONE_PLATFORM_HINT=auto
exec /usr/bin/code "$@"
