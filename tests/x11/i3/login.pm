use base "opensusebasetest";
use strict;
use warnings;
use testapi;
use utils;
use x11utils 'handle_login';

sub run {
    # login first
    set_var('DESKTOP', 'xfce');
    handle_login();

    assert_screen('i3_first-config');

    wait_screen_change{ send_key('ret'); };
    send_key('down');

    assert_screen('i3_first-config-alt-selected');
    wait_screen_change{ send_key('ret'); };

    assert_screen('i3_desktop');

    # launch a terminal
    send_key('alt-ret');
    assert_screen('i3_terminal');

    send_key('alt-shift-q');
    assert_screen('i3_desktop');

    # logout
    send_key('alt-shift-e');
    assert_and_click('i3_logout-nagbar_press_exit');

    # ensure that we're back in the login manager, but log back in as otherwise
    # the test fails in the post hook
    assert_screen('displaymanager');
}

1;
