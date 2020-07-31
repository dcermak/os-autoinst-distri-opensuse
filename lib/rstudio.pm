package rstudio;
use testapi;
use strict;
use warnings;
use utils;

our @ISA    = qw(Exporter);
our @EXPORT = qw(rstudio_help_menu rstudio_sin_x_plot rstudio_create_and_test_new_project rstudio_run_profiler rstudio_cleanup_project);

sub rstudio_help_menu {
    my %args         = @_;
    my $rstudio_mode = $args{rstudio_mode} || "server";
    my $prefix       = "rstudio_$rstudio_mode";

    # open the About RStudio menu
    assert_and_click("$prefix-help-menu");
    assert_and_click("$prefix-about-rstudio");
    # and close it again
    assert_and_click("$prefix-about-rstudio-close");
}

sub rstudio_sin_x_plot {
    my %args         = @_;
    my $rstudio_mode = $args{rstudio_mode} || "server";
    my $prefix       = "rstudio_$rstudio_mode";

    # enter a space after both commands, so that the cursor is no longer in the
    # needle match area
    assert_and_click("$prefix-prompt");
    type_string('x = 2.*pi*seq(1, 100)/(100.) ');

    assert_screen("$prefix-x-data-entered");
    wait_screen_change { send_key('ret'); };

    type_string('plot(x, sin(x)) ');
    assert_screen("$prefix-plot-cmd-entered");

    wait_screen_change { send_key('ret'); };

    assert_screen("$prefix-sin-x-plot");
}

sub rstudio_create_and_test_new_project {
    my %args         = @_;
    my $rstudio_mode = $args{rstudio_mode} || "server";
    my $prefix       = "rstudio_$rstudio_mode";

    # open the "New Project" dialog
    assert_and_click("$prefix-file-menu");
    assert_and_click("$prefix-file-menu_new-project");
    assert_and_click("$prefix-don-t-save-current-workspace");

    # create a "New Directory" -> "New Project"
    assert_and_click("$prefix-new-project_new-directory");
    assert_and_click("$prefix-new-project_project-type");

    # enter project name, select ~ as the subdirectory and select "Create a git repository"
    assert_screen("$prefix-create-new-project");
    type_string("test_project");
    assert_and_click("$prefix-create-new-project_browse-subdirectory");
    assert_and_click("$prefix-create-new-project_select-HOME");

    # check whether the "create a git repository" option is unselected
    # if it is, click it to ensure it is
    my $create_git_repo_selected = check_screen("$prefix-create-new-project_create-git-repository", timeout => 10);
    if (defined $create_git_repo_selected) {
        click_lastmatch();
    }
    assert_and_click("$prefix-create-new-project_create-project");

    # open the .gitignore file, enter *~ at the top and save it
    assert_and_click("$prefix-files-tab_select-gitignore");
    # click on the .gitignore tab to select that editor
    assert_and_click("$prefix-gitignore-file");
    type_string("*~");
    wait_still_screen(1);
    send_key('ret');
    assert_screen("$prefix-gitignore-file-unsaved");
    send_key('ctrl-s');
    assert_screen("$prefix-gitignore-file-saved");

    # open the Git tab, stage the .gitignore file and commit it
    assert_and_click("$prefix-project_git-tab");
    assert_and_click("$prefix-project_git-tab_stage-gitignore");
    assert_and_click("$prefix-project_git-tab_commit");
    assert_and_click("$prefix-project_git-commit-window_commit-message");
    type_string("Add .gitignore");
    assert_and_click("$prefix-project_git-commit-window_commit-button");
    assert_and_click("$prefix-project_git-commit-window_commit-close");
    send_key('alt-f4');

    # open commit log and close it again
    assert_and_click("$prefix-project_commit-log-button");
    assert_screen("$prefix-project_commit-history");
    send_key('alt-f4');

    # close the project
    assert_and_click("$prefix-project_current-project-menu");
    assert_and_click("$prefix-project_current-project-menu_close-project");
    check_screen("$prefix-project_close-project_save-window", timeout => 10) && assert_and_click("$prefix-project_close-project_save-window", timeout => 1);
    assert_screen("$prefix-project_no-project-open");
}

# regression test for boo#1172426 and test that installing R modules actually works
sub rstudio_run_profiler {
    my %args         = @_;
    my $rstudio_mode = $args{rstudio_mode} || "server";
    my $prefix       = "rstudio_$rstudio_mode";

    assert_and_click("$prefix-prompt");

    # will have to install gcc first
    type_string("install.packages(\"profvis\")");
    send_key("ret", wait_screen_change => 1);

    # wait for the 'DONE (profvis)' string to appear
    # the installation can take quite a while because it needs to compile a
    # bunch of R modules
    assert_screen("$prefix-profvis_installed", timeout => 600);

    type_string("library(profvis)");
    send_key("ret", wait_screen_change => 1);

    type_string("df = data.frame(v = 1:4, name = letters[1:4])");
    send_key("ret", wait_screen_change => 1);

    type_string("profvis(expr = {sub.test1 <- system.time(for (i in 1:50000) {df[3, 2]})})");
    send_key("ret");

    assert_screen("$prefix-profile_flame-graph_close");
}

sub rstudio_cleanup_project {
    x11_start_program('xterm');
    assert_script_run("rm -rf ~/test_project");
    wait_still_screen(1);
    send_key("alt-f4");

    # try to close all open windows:
    # => hammer alt+F4 and check if we match the generic desktop needle
    send_key_until_needlematch('generic-desktop', "alt-f4");
}
