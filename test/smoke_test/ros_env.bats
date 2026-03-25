#!/usr/bin/env bats

setup() {
    load "${BATS_TEST_DIRNAME}/test_helper"
}

# -------------------- ROS environment --------------------

@test "ROS_DISTRO is set" {
    assert [ -n "${ROS_DISTRO}" ]
}

@test "ROS 2 setup.bash exists" {
    assert [ -f "/opt/ros/${ROS_DISTRO}/setup.bash" ]
}

@test "ROS 2 setup.bash can be sourced" {
    run bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash"
    assert_success
}

# -------------------- SICK packages --------------------

@test "sick_safetyscanners2_interfaces is installed" {
    run dpkg -l ros-${ROS_DISTRO}-sick-safetyscanners2-interfaces
    assert_success
}

@test "sick_safetyscanners_base is installed" {
    run dpkg -l ros-${ROS_DISTRO}-sick-safetyscanners-base
    assert_success
}

# -------------------- System --------------------

@test "entrypoint.sh exists and is executable" {
    assert [ -x "/entrypoint.sh" ]
}
