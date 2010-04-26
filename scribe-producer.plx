#! /usr/bin/perl

use Scribe::Thrift::scribe;
use Thrift::Socket;
use Thrift::FramedTransport;
use Thrift::BinaryProtocol;
use strict;
use warnings;

my $host = 'localhost';
my $port = 1463;
my $cat = $ARGV[0] || 'test';

my $socket = Thrift::Socket->new($host, $port);
my $transport = Thrift::FramedTransport->new($socket);
my $proto = Thrift::BinaryProtocol->new($transport);

my $client = Scribe::Thrift::scribeClient->new($proto, $proto);
my $le = Scribe::Thrift::LogEntry->new({ category => $cat });

$transport->open();

while (my $line = <>) {
    $le->message($line);
    my $result = $client->Log([ $le ]);
    if ($result == Scribe::Thrift::ResultCode::TRY_LATER) {
      print STDERR "TRY_LATER\n";
    }
    elsif ($result != Scribe::Thrift::ResultCode::OK) {
      print STDERR "Unknown result code: $result\n";
    }
  }

$transport->close();
