use base "x11test";
use strict;
use warnings;
use testapi;
use utils;

sub run() {
    ensure_installed('emacs-x11 emacs-nox');
    x11_start_program('emacs', target_match => 'emacs_main-window');

    assert_and_click('emacs_main-window_tools-menu-click');
    assert_and_click('emacs_main-window_tools-menu_calendar-click');

    assert_screen("emacs_calendar-buffer");

    send_key("q", wait_screen_change => 1);

    assert_screen("emacs_main-window");

    wait_screen_change { send_key("ctrl-x"); send_key("b"); };

    wait_screen_change { type_string("Calen"); send_key("tab"); send_key("ret"); };

    assert_screen("emacs_calendar-buffer");

    wait_screen_change { send_key("ctrl-x"); send_key("ctrl-c"); };
}

sub test_flags {
    return {milestone => 1, fatal => 1};
}

1;
