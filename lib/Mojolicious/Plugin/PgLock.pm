package Mojolicious::Plugin::PgLock;
use Mojo::Base 'Mojolicious::Plugin';

use Mojolicious::Plugin::PgLock::Sentinel;

our $VERSION = "0.01";

sub register {
    my( $plugin, $app, $conf ) =  @_;
    $app->helper( get_lock => \&get_lock  );
}

sub get_lock {
    my $self = shift;
    my $params = @_ % 2 ? $_[0] : { @_ };
    $params->{app} = $self->app;
    $params->{db}  = $self->app->pg->db;
    $params->{name} //= ( caller(1) )[0];
    my $sentinel = Mojolicious::Plugin::PgLock::Sentinel->new($params);
    return $sentinel->lock;
}

1;

__END__

=encoding utf-8

=head1 NAME

Mojolicious::Plugin::PgLock -  get_lock helper for Mojolicious application

=head1 SYNOPSIS

  $app->plugin('PgLock');

  if ( my $lock = $app->get_lock ) {
    # make something exclusively
  }

=head1 DESCRIPTION

Mojolicious::Plugin::PgLock implements get_lock helper


=head1 HELPERS
L<Mojolicious::Plugin::PgLock> implements the following helper.


=head2 get_lock

  my $lock = $app->get_lock
      or die "another process is running";

  # use a name and try to get a shared lock
  my $shared_lock = $app->get_lock( name => 'mySharedLock', shared => 1 );

  # use explicit id and wait until a lock is granted
  my $lock = $app->get_lock( id => 9874738, wait => 1 );

E<get_lock> helper uses one of 'pg_try_advisory_lock', 'pg_advisory_lock',
and their shared siblings to get an exclusive or shared lock.
The E<id> parameter is used as argument for these functions. If E<id>
is not defined then it is calculated as CRC32 hash from E<name> parameter.
If E<name> is not defined then PACKAGE of the caller is used as E<name>.
It allows to use E<get_helper> without parameters in Mojolicious::Command modules.

E<get_lock> helper returns a sentinel vairable which holds the lock while it is alive.


=head1 LICENSE

Copyright (C) Alexander Onokhov E<lt>onokhov@cpan.orgE<gt>.

This library is free software; you can redistribute it and/or modify
it under the MIT license terms.

=head1 AUTHOR

Copyright (C) Alexander Onokhov E<lt>onokhov@cpan.orgE<gt>.

=cut
