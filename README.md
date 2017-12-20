# NAME

Mojolicious::Plugin::PgLock - postgres advisory locks for Mojolicious application

# SYNOPSIS

  my $pg = Mojo::Pg->new('postgresql://...');
  $app->plugin( PgLock => { pg => $pg } );

  if ( my $lock = $app->get_lock ) {
    # make something exclusively
  }

# DESCRIPTION

Mojolicious::Plugin::PgLock implements get_lock helper. It is a shugar for
L<postgres advisory lock functions|https://www.postgresql.org/docs/current/static/functions-admin.html#FUNCTIONS-ADVISORY-LOCKS>.

# HELPERS

L<Mojolicious::Plugin::PgLock> implements the following helper.

## get_lock

```
  my $lock = $app->get_lock
      or die "another process is running";

  # use a name and try to get a shared lock
  my $shared_lock = $app->get_lock( name => 'mySharedLock', shared => 1 );

  # use explicit id and wait until a lock is granted
  my $lock = $app->get_lock( id => 9874738, wait => 1 );
```

`get_lock` helper uses one of postgres advisory lock function `pg_try_advisory_lock`,
 `pg_advisory_lock`, `pg_advisory_lock_shared`, `pg_advisory_lock_shared`
to get an exclusive or shared lock depending on parameters.

`get_lock` helper returns a L<Mojolicious::Plugin::PgLock::Sentinel> object which holds
the lock while it is alive.

### id

`id` parameter is used as integer key argument in postgres advisory lock function call.
Default value for `id` is CRC32 hash of `name` parameter.

### name

`name` is used for `id` calculation only if `id` is not set.
Default value for `name` is ```(caller(2))[0]```. It allows to use `get_helper`
without parameters in L<Mojolicious::Commands> modules

### shared

`shared` parameter chose shared or exclusive lock. Default is false.

### wait

If `wait` is true then function will wait until a lock is granted.


# LICENSE

Copyright (C) Alexander Onokhov <onokhov@cpan.org>.

This library is free software; you can redistribute it and/or modify
it under the MIT license terms.

# AUTHOR

Copyright (C) Alexander Onokhov <onokhov@cpan.org>.

