#!/usr/bin/perl

sub DB::DB {}

#use Test::More qw/no_plan/;

#use Devel::CallTrace;

package foo;
sub bar {
  print "bar\n";
  baz();
}

sub baz {
    print "boo\n";
}

foo::bar();
