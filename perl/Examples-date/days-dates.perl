#!/usr/bin/perl
# $Id: days-dates.perl,v 1.2 2015-07-16 18:25:12-07 - - $

use strict;
use warnings;
use POSIX qw (strftime);
use Time::Local;

sub weekday(@) {
   my @time = @_;
   qw (Sunday Monday Tuesday Wednesday Thursday Friday Saturday
      ) [$time[6]];
}

sub month(@) {
   my @time = @_;
   qw (January February March April May June
       July August September October November December
      ) [$time[4]];
}

my @now = gmtime ($^T);
for my $year (@ARGV ? @ARGV : $now[5] + 1899 .. $now[5] + 1901) {
   print "year=$year\n";
   for my $month (1..12) {
      my $first = sprintf "%04d-%02d-01", $year, $month;
      my $time = timegm (0, 0, 0, 1, $month - 1, $year - 1900);
      my @time = gmtime ($time);
      printf "%s is %s, %s 1\n",
             $first, weekday (@time), month (@time);
   }
}

