package Thrift::FramedTransportFactory;
use strict;
use warnings;
use base qw/Thrift::TransportFactory/;

use Thrift::FramedTransport;

sub getTransport {
    my ($self, $trans) = @_;
    return Thrift::FramedTransport->new($trans);
}

1;
