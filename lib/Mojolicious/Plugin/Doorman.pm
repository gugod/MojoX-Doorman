package Mojolicious::Plugin::Doorman;

use strict;
use warnings;

use base "Mojolicious::Plugin";

sub register {
    my ($self, $app, $conf) = @_;
    $conf ||= {};

    my %helpers = (
        current_user => sub {
            my $self = shift;
            my $doorman = $self->req->env->{'doorman.users.authentication'};

            return $doorman->is_sign_in;
        },
        user_sign_in_path  => sub {
            my $self = shift;
            my $doorman = $self->req->env->{'doorman.users.authentication'};

            return $doorman->sign_in_path;
        },
        user_sign_out_path => sub {
            my $self = shift;
            my $doorman = $self->req->env->{'doorman.users.authentication'};

            return $doorman->sign_out_path;
        }
    );

    while(my ($k, $v) = each %helpers) {
        $app->renderer->add_helper($k, $v);
    }
}

1;
