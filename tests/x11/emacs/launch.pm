use base "x11test";
use strict;
use warnings;
use testapi;
use utils;

sub run() {
    x11_start_program('emacs', target_match => 'emacs_main-window');

    wait_screen_change { send_key("ctrl-x"); send_key("ctrl-f"); };
    type_string('test.txt');
    send_key('ret', wait_screen_change => 1);

    my $test_txt_contents = 'contents for test.txt';

    assert_screen('emacs_test-file-open');
    wait_screen_change { type_string($test_txt_contents); };

    # save
    send_key('ctrl-x', wait_screen_change => 1);
    send_key('ctrl-s', wait_screen_change => 1);

    # quit
    wait_screen_change { send_key('ctrl-x'); send_key('ctrl-c'); };

    assert_screen('generic-desktop');

    x11_start_program('xterm');
    assert_script_run('[[ $(cat test.txt) = "' . $test_txt_contents . '" ]]');
    send_key_until_needlematch('generic-desktop', "alt-f4");
}

sub test_flags {
    return {fatal => 1};
}

1;
