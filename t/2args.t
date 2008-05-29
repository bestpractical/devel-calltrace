#!/usr/bin/perl

# I can't make this go with Test::More because we're hooking the symbol table
use vars qw/@CALLED/;
use Devel::CallTrace '::baz$';

package DB;
sub Devel::CallTrace::called {
    my @args = ($_[0], $DB::sub, $_[1]);
    push @main::CALLED, \@args;
}
package main;


sub bar {
  baz();
}
sub baz {
1;
}

my $return = bar();

package DB;

eval "sub DB::sub  {&\$DB::sub};";

package main;


unless( scalar @CALLED == 1 ) { print "not "};
print "ok 1 - There was one matching call\n";
unless ($return ==1) { print "not "};
print "ok 2\n";

my $second = shift @CALLED;
unless ($second->[0] == '2') { print "not "};
print "ok 3 - Started with a depth of 2 ".$second->[0]."\n";
unless ($second->[1] eq 'main::baz') { print "not "};
print "ok 4 - baz was called second ".$second->[1]."\n";
print "1..4\n";
1;
