use base "x11test";
use strict;
use warnings;
use testapi;
use utils;

sub run() {
    assert_screen("generic-desktop");

    x11_start_program('xterm');
    assert_script_run("gsettings set org.gnome.desktop.interface monospace-font-name 'Sans 10'");
    send_key_until_needlematch('generic-desktop', "alt-f4");

    x11_start_program('emacs', target_match => 'emacs_main-window-sans-10');
    # switch buffer key-chord: C-x b
    send_key('ctrl-x', wait_screen_change => 1);
    send_key('b',      wait_screen_change => 1);
    # switch to the *scratch* buffer, use auto-completion
    type_string('scratch');
    wait_screen_change { send_key("tab"); };
    wait_screen_change { send_key("ret"); };

    assert_screen("emacs_scratch-buffer-open");

    type_string("(set-frame-font \"Cantarell 14\" nil t)");
    # ensure that we are at the end of the line
    wait_screen_change { send_key("ctrl-e"); };
    # execute the last lisp expression via C-x C-e
    wait_screen_change { send_key("ctrl-x"); send_key("ctrl-e"); };
    assert_screen("emacs_scratch-buffer-cantarell-14");

    wait_screen_change { send_key("ctrl-x"); send_key("ctrl-c"); };

    assert_screen("generic-desktop");
}

sub test_flags() {
    return {fatal => 0};
}

1;
