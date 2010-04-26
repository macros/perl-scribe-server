#!/usr/bin/perl

use strict;
use warnings;

use Net::Stomp;
use Log::Dispatch::Scribe;
use Data::Dumper;
use JSON;

my %options = (
    'debug'               => 0,
    'stomp_username'    => 'guest',
    'stomp_password'    => 'guest',
    'stomp_server'      => '10.8.2.221',
    'stomp_port'        => '61613',
    'stomp_destination' => "scribe-test",
    'stomp_key'         => 'wikia.purges',
    );

my $stomp = Net::Stomp->new( {hostname => $options{'stomp_server'},
                              port     => $options{'stomp_port'},
                             });

$stomp->connect( { login    => $options{stomp_username},
                   passcode => $options{stomp_password},
                   prefetch => 1 },);

$stomp->subscribe( {destination => $options{'stomp_destination'},
                    'auto-delete' => 'true', 'durable' => 'false',
                    'ack'=>'client',
                    exchange => 'amq.topic',
                    routing_key => $options{'stomp_key'}},
                   id => 1);

my $scribe = Log::Dispatch::Scribe->new(
                                        name       => 'scribe',
                                        min_level  => 'info',
                                        host       => 'liftium-test',
                                        port       => 1463,
                                        default_category => 'purge',
                                        retry_plan_a => 'buffer',
                                        retry_plan_b => 'wait_forever',
                                      );

while(1) {
  my $frame = $stomp->receive_frame;
  my $obj = from_json($frame->body, {utf8 => 1});

  my %msg = ( 'time' => $obj->{time},
              'url'  => $obj->{url} );

  $scribe->log( level => 'info', message => to_json(\%msg, {utf8 => 1}) );
  $stomp->ack({frame=>$frame});
}
