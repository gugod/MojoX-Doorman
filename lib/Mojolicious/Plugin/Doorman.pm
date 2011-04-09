package Mojolicious::Plugin::Doorman;

use strict;
use warnings;

use base "Mojolicious::Plugin";

sub register {
    my ($self, $app, $conf) = @_;
    $conf ||= {};

    $app->helper(
        user_sign_in_path => sub { "/users/sign_in" },
        user_sign_out_path => sub { "/users/sign_out" }
    );
}

1;
