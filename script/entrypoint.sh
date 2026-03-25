#!/usr/bin/env bash
set -euo pipefail

# Source ROS 2
# shellcheck disable=SC1090
source "/opt/ros/${ROS_DISTRO}/setup.bash"

exec "${@}"
