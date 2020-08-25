# SUSE's openQA tests
#
# Copyright © 2020 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Run simple image specific checks
# Maintainer: Fabian Vogt <fvogt@suse.de>

use base "opensusebasetest";
use testapi;
use utils;
use strict;
use warnings;

sub run {
    select_console('root-console');

    assert_script_run("transactional-update install emacs-nox");
}

1;
