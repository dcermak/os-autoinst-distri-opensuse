use base "opensusebasetest";
use strict;
use warnings;
use testapi;
use power_action_utils 'power_action';
use utils;

sub run {
    my ($self) = @_;

    select_console('root-console');
    zypper_call('in i3 i3lock i3status lightdm xorg-x11-server');

    systemctl('set-default graphical.target');
    power_action('reboot', textmode => 1);

    # lightdm is the displaymanager used by xfce, so we will leverage that
    set_var('DESKTOP', 'xfce');
    $self->wait_boot(textmode => 0, nologin => 1);
}

sub test_flags {
    return {fatal => 1, milestone => 1};
}

1;
