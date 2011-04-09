#!/usr/bin/env plackup -I ../lib -R ../lib

##!/usr/bin/env perl

use Mojolicious::Lite;

plugin "doorman";

get "/" => sub {
    my $self = shift;
    $self->render("home");
};

get "/users/sign_in" => sub {
    my $self = shift;
    $self->render("sign_in");
};

get "/users/sign_out" => sub {
    my $self = shift;
    $self->flash("message" => "Farewell");
    $self->redirect_to("/");
};

post "/users/sign_in" => sub {
    my $self = shift;
    $self->flash("message" => "OK. You are now in.");
    $self->redirect_to("/");
};


{
    use Plack::Builder;
    use Plack::Request;

    sub my_simple_authenticator {
        my ($mw, $env) = @_;
        my $req = Plack::Request->new($env);
        return $req->param("username");
    }
}

builder {
    enable "Session";
    enable "DoormanAuthentication", authenticator => \&my_simple_authenticator;
    app->start;
}

__DATA__

@@ home.html.ep
% layout "default";
% title "Simple App";

<p>
% if (current_user) {
Hi <%= $self->current_user %>. Please <a href="<%= user_sign_out_path %>">sign out</a></p>
% } else {
Hi Guest. Please <a href="<%= user_sign_in_path %>">sign in.</a>
% }
</p>

@@ sign_in.html.ep
% layout "default";
% title "Simple App >> Sign In";

<p>No need to provide password here, just your name.</p>

<form method="post" action="<%= user_sign_in_path %>">
    <p>
        Username: <input type="text" name="username" autofocus><br>
        <input type="submit" value="Set my username">
    </p>
</form>

@@ layouts/default.html.ep
<!doctype html>
<html>
    <head>
    <style>
        .flash-message {
            color: #030; background: #cfc; border: 2px solid #595;
            padding: 5px; border-radius: 5px;
        }
    </style>
    <title><%= title %></title>
    </head>
    <body>
    <h1><%= title %></h1>
    <% if (flash("message")) { %>
        <p class="flash-message"><%= flash("message") %></p>
    <% } %>
    <%= content %>
    </body>
</html>
