# SUSE's openQA tests
#
# Copyright © 2020 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.
#
# Summary: Firstboot setup of the machinelearning appliance
# Maintainer: Dan Čermák <dcermak@suse.com>

use base "opensusebasetest";
use testapi;
use strict;
use warnings;
use testapi;
use utils;

sub run() {
    my $prefix = "machinelearning-firstboot";

    assert_screen("$prefix-select_locale", timeout => 120);
    send_key("ret", wait_screen_change => 1);

    assert_screen("$prefix-select_keyboard_layout", timeout => 10);
    send_key("ret", wait_screen_change => 1);

    send_key_until_needlematch("$prefix-license_bottom", "spc");
    send_key("ret", wait_screen_change => 1);
    assert_screen("$prefix-license_accept", timeout => 10);
    send_key("ret", wait_screen_change => 1);

    assert_screen("$prefix-select_timezone", timeout => 10);
    send_key("ret", wait_screen_change => 1);

    assert_screen("$prefix-enter_root_password", timeout => 10);
    type_password(wait_still_screen => 5);
    send_key("ret", wait_screen_change => 1);
    assert_screen("$prefix-repeat_root_password", timeout => 10);
    type_password(wait_still_screen => 5);
    send_key("ret", wait_screen_change => 1);

    # login and power the machine off
    assert_screen("linux-login", timeout => 120);
    type_string("root", wait_still_screen => 5);
    send_key("ret", wait_screen_change => 1);

    type_password(wait_still_screen => 5);
    send_key("ret", wait_screen_change => 1);

    zypper_call("ref");

    $testapi::distri->set_standard_prompt('root');
    assert_script_run('setterm -blank 0');

    verify_user_info(user_is_root => 1);

    # Create user account
    assert_script_run("useradd -m $username -c '$realname'");
    assert_script_run("echo $username:$password | chpasswd");

    ensure_serialdev_permissions;

    select_console('user-console');
    verify_user_info;

    select_console('root-console');

    type_string("systemctl poweroff\n");
    assert_shutdown();
}

1;
