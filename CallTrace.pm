=head1 NAME

Devel::CallTrace - See what your code's doing


=head1 SYNOPSIS

#!/usr/bin/perl

use Devel::CallTrace;
package foo;

sub bar {
  print "bar\n";
  baz();
}

sub baz {
    print "boo\n";
}


foo::bar();

=cut

package Devel::CallTrace;
use warnings;
use strict;
no strict 'refs';

our $DEPTH = 0;


BEGIN { $^P |= 0x01 };


package DB;

our $CALL_DEPTH;

sub sub {
    local $DB::CALL_DEPTH;
    $DB::CALL_DEPTH++;
    warn " " x $DB::CALL_DEPTH . $DB::sub ."\n";
    return(&{$DB::sub}(@_));
}



=head1 TODO

doesn't do the right thign with return values

=cut
1;
