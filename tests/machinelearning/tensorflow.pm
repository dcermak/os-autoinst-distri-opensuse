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

use base "consoletest";
use testapi;
use strict;
use warnings;
use testapi;
use utils;

sub run() {
    select_console("root-console");

    assert_script_run('python3 -c "import tensorflow as tf; from tensorflow import keras; print(tf.__version__)"');
}

1;
