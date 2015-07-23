package Daioikachan::Client;

use strict;
use warnings;

our $VERSION = "0.01";

use Furl::HTTP;
use Carp;

sub new {
    my ($class, $args) = @_;

    my $ua = Furl::HTTP->new(
        agent   => 'daioikachan-agent',
        timeout => 10,
        defined $args->{ua_options} ? %{$args->{ua_options}} : (),
    );

    my $default_channel = (defined $args->{default_channel} && ($args->{default_channel} ne '')) ? $args->{default_channel} : '#notify';
    my $endpoint = (defined $args->{endpoint} && ($args->{endpoint} ne '')) ? $args->{endpoint} : die 'Undefined endpoint';

    my $headers = $args->{headers};

    return bless {
        ua              => $ua,
        headers         => $headers,
        default_channel => $default_channel,
        endpoint        => $endpoint,
    }, $class;
}

sub notice {
    my ($self, $args) = @_;

    my $message = (defined $args->{message} && ($args->{message} ne '')) ? $args->{message} : die 'Undefined message';

    return $self->_send({
        channel => $args->{channel},
        message => $message,
        type    => 'notice',
    });
}

sub privmsg {
    my ($self, $args) = @_;

    my $message = (defined $args->{message} && ($args->{message} ne '')) ? $args->{message} : die 'Undefined message';

    return $self->_send({
        channel => $args->{channel},
        message => $message,
        type    => 'privmsg',
    });
}

sub _send {
    my ($self, $args) = @_;

    my $channel = (defined $args->{channel} && ($args->{channel} ne '')) ? $args->{channel} : $self->{default_channel};

    return $self->{ua}->post(
        $self->{endpoint} . $args->{type},
        $self->{headers},
        {
            channel => $channel,
            message => $args->{message},
        },
    );
}

1;
__END__

=encoding utf-8

=head1 NAME

Daioikachan::Client - TBD

=head1 SYNOPSIS

    use Daioikachan::Client;

    TBD

=head1 DESCRIPTION

TBD

=head1 LICENSE

Copyright (C) ryopeko.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ryopeko E<lt>ryopeko@gmail.comE<gt>

=cut

