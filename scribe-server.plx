#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use lib 'gen-perl';
use lib 'lib';

package ScribeHandler;
use Scribe::Thrift::scribe;
use base qw/Scribe::Thrift::scribeIf/;

sub new { bless {}, shift; print "Creating handler\n"; }

sub Log {
  my ($self, $messages) = @_;
  print "in handler\n";
  return "OK";
}

package main;
use Thrift::ServerSocket;
use Thrift::FramedTransportFactory;
use Thrift::SimpleServer;

my $handler = new ScribeHandler;
my $processor = new Scribe::Thrift::scribeProcessor($handler);
my $socket = new Thrift::ServerSocket(1463);
my $transport = new Thrift::FramedTransportFactory();
my $protocol = new Thrift::BinaryProtocolFactory();
my $server = new Thrift::SimpleServer( $processor, $socket, $transport, $protocol);
print "starting server\n";
$server->serve();
