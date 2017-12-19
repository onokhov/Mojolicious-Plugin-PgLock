# NAME

Mojolicious::Plugin::PgLock -  get_lock helper for Mojolicious application

# SYNOPSIS

  $app->plugin('PgLock');

  if ( my $lock = $app->get_lock ) {
    # make something exclusively
  }

# DESCRIPTION

Mojolicious::Plugin::PgLock implements get_lock helper.

# LICENSE

Copyright (C) Alexander Onokhov <onokhov@cpan.org>.

This library is free software; you can redistribute it and/or modify
it under the MIT License terms.

# AUTHOR

Alexander Onokhov <onokhov@cpan.org>

