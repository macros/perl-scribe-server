#
# Autogenerated by Thrift
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#
require 5.6.0;
use strict;
use warnings;
use Thrift;

package Scribe::Thrift::ResultCode;
use constant OK => 0;
use constant TRY_LATER => 1;
package Scribe::Thrift::LogEntry;
use base qw(Class::Accessor);
Scribe::Thrift::LogEntry->mk_accessors( qw( category message ) );

sub new {
  my $classname = shift;
  my $self      = {};
  my $vals      = shift || {};
  $self->{category} = undef;
  $self->{message} = undef;
  if (UNIVERSAL::isa($vals,'HASH')) {
    if (defined $vals->{category}) {
      $self->{category} = $vals->{category};
    }
    if (defined $vals->{message}) {
      $self->{message} = $vals->{message};
    }
  }
  return bless ($self, $classname);
}

sub getName {
  return 'LogEntry';
}

sub read {
  my ($self, $input) = @_;
  my $xfer  = 0;
  my $fname;
  my $ftype = 0;
  my $fid   = 0;
  $xfer += $input->readStructBegin(\$fname);
  while (1) 
  {
    $xfer += $input->readFieldBegin(\$fname, \$ftype, \$fid);
    if ($ftype == TType::STOP) {
      last;
    }
    SWITCH: for($fid)
    {
      /^1$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{category});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^2$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{message});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
        $xfer += $input->skip($ftype);
    }
    $xfer += $input->readFieldEnd();
  }
  $xfer += $input->readStructEnd();
  return $xfer;
}

sub write {
  my ($self, $output) = @_;
  my $xfer   = 0;
  $xfer += $output->writeStructBegin('LogEntry');
  if (defined $self->{category}) {
    $xfer += $output->writeFieldBegin('category', TType::STRING, 1);
    $xfer += $output->writeString($self->{category});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{message}) {
    $xfer += $output->writeFieldBegin('message', TType::STRING, 2);
    $xfer += $output->writeString($self->{message});
    $xfer += $output->writeFieldEnd();
  }
  $xfer += $output->writeFieldStop();
  $xfer += $output->writeStructEnd();
  return $xfer;
}

1;
