#!/usr/bin/env perl

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

post "/users/sign_in" => sub {
    my $self = shift;
    $self->flash("message" => "OK. You are now in.");
    $self->redirect_to("/");
};

app->start;

__DATA__

@@ home.html.ep
% layout "default";

<h1>Simple App</h1>

<p>Hi guest. Please <a href="<%= user_sign_in_path %>">sign in to set your username.</a></p>

@@ sign_in.html.ep
% layout "default";
<h1>Sign In</h1>

<p>No need to provide password here, just your name.</p>

<form method="post" action="<%= user_sign_in_path %>">
    <p>
        Username: <input type="text" name="username"><br>
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
    </head>
    <body>
    <% if (flash("message")) { %>
        <p class="flash-message"><%= flash("message") %></p>
    <% } %>
    <%= content %>
    </body>
</html>
