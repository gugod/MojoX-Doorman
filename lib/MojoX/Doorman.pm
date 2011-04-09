package MojoX::Doorman;
use strict;
use warnings;
our $VERSION = '0.01';

1;
__END__

=head1 NAME

MojoX::Doorman - Take care of all your authentication needs

=head1 SYNOPSIS

    # Enable the plugin in your app.
    sub startup {
        my $self = shift;
        $self->plugin('doorman');
        ...
    }

    ## Also need to modify the last part in script/myapp
    builder {
        enable "Session";
        enable "DoormanAuthenticaton", authenticator => \&my_authenticator;
        Mojolicious::Command->start;
    }

    # Some view helpers will be there to help.
    <form method="post" action="<%= user_sign_in_path %>">
    </form>

    <a href="<%= user_sign_out_path %>">Sign Out</a>


=head1 DESCRIPTION

MojoX::Doorman is a Mojolicious plugin that makes it easier
to wrie Mojo apps without dealing much of authentication code.
The authentication backends come from L<Doorman>.

=head1 SETUP

Doorman is based on PSGI, which means, MojoX::Doorman will require you
to use PSGI Server for your Mojo app.

There are some tweaks you need to do in your app code in order
to enable it.

First, you need to modify your server script. For instance, the
last line of C<script/myapp> usually looks like this:

    Mojolicious::Commands->start;

Change that to:

    use Plack::Builder;
    builder {
        enable "Session";
        enable "DoormanOpenID";
        Mojolicious::Commands->start;
    }

You may enable multiple Doorman authentication middlewares there. See C<Doorman> for
more detail info.

If you are using C<Mojolicious::Lite>, the very last line of your app should be:

    app->start;

Change that to

    use Plack::Builder;
    builder {
        enable "Session";
        enable "DoormanOpenID";
        app->start;
    }

Finally, enable the plugin in C<startup> method:

    sub startup {
        my $self = shift;
        $self->plugin('doorman');
        ...
    }

For C<Mojolicious::Lite> apps, that's just:

    plugin "doorman";

The plugin provides many view helpers to interact with the middleware.

=head1 VIEW HELPERS

The plugin provides several helper methods in the view.

=head2 C<user_sign_in_path>

Returns a string that is the path for sign-in request.
Whenever there is a POST request on this path, Doorman will
be the first one to respond.

Your app code should also have a route to this path,
in which, for example, it sets a flash message and redirects
to homepage.

=head2 C<user_sign_out_path>

Returns a string that is the path for sign-out request,
which should be a GET request on this path. Relevant
session entries or cookies will be removed.

After that, it is your turn to customize a sign out
page. Your app code should also have a route to this path
which simply renders the farewell message page.

=head1 AUTHOR

Kang-min Liu E<lt>gugod@gugod.orgE<gt>

=head1 SEE ALSO

L<Doorman>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the MIT license.

=cut
