=head1 NAME

Devel::CallTrace - See what your code's doing


=head1 SYNOPSIS

#!/usr/bin/perl

package foo;
sub bar {
  print "bar\n";
  baz();
}

sub baz {
    print "boo\n";
}

INIT { Devel::CallTrace::trace_functions('.*'); }

foo::bar();

=cut

package Devel::CallTrace;
use warnings;
use strict;
no strict 'refs';

our $DEPTH = 0;


use Scalar::Util;
my %traced;                    # don't initialize me here, won't be
                                # set till later.


=head2 trace_functions REGEX




=cut
sub trace_functions {
  # Config is often readonly.
  %traced = ( 'Config::' => 1,
           'attributes::' => 1 );
  trace_class('::',@_);
}

 
sub trace_class {
  my ($class,$regex) = @_;
  no strict 'refs';
      return if exists $traced{$class};
       $traced{$class}++;
  for my $i ( keys %{$class} ) {
    if ($i =~ /::$/) {
      trace_class( $i, $regex );
    } else {
      # trace functions
      my $func = "$class$i";
      next unless $func =~ $regex;
      my $orig = \&{$func};
      *{"$func"} =
    Scalar::Util::set_prototype(
        sub {
            $Devel::CallTrace::DEPTH++;
            print STDERR ( ' ' x $Devel::CallTrace::DEPTH ) . "> $func\n";
            $orig->(@_);
            print STDERR ( ' ' x $Devel::CallTrace::DEPTH ) . "< $func\n";
            $Devel::CallTrace::DEPTH--;
        },
         prototype($func)
    );


    }
  }
}


