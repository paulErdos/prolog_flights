#!/usr/bin/perl -w

# sig.perl -- random Perl signature generator. 
# Written 1995 by Ben Gertzfield <che@debian.org>
# This work is released under the GNU GPL, version 2 or later.

# To use: make a file containing random quotes, one per line, and
# put it in ~/bin/quotes (or change the $quotes_file variable below).
# Then have your mail program call ~/bin/sig.perl (or whatever you
# call the program) before or after it reads your signature.

use strict;			# Very very important! Enforces good
				# coding habits. see 'perldoc strict'

my $quotes_file = "$ENV{HOME}/bin/quotes";

my $footer = 
"Debian GNU/Linux maintainer of Gimp and GTK+ -- http://www.debian.org/
I'm on FurryMUCK as Che, and EFNet/Open Projects IRC as Che_Fox."; 

my ($email, $quote, $letter1, $letter2, $number);

srand;				# Unnecessary in Perl 5.004 or greater;
				# they automatically seed the random
				# number generator.

my @alphabet = ('A' .. 'Z');

# This splice call says: from @alphabet, pick a random number from 0
# up to the number of elements in @alphabet (non-inclusive) and pluck
# out 1 letter corresponding to that random number. Using splice
# makes sure we don't get the same letter twice.

$letter1 = splice (@alphabet, rand @alphabet, 1);
$letter2 = splice (@alphabet, rand @alphabet, 1);

$number = int(rand (20));

open (QUOTES, $quotes_file) or die 
  "Couldn't open quotes file $quotes_file: $!\n";

# The way the below line works is incredibly interesting. $. is the
# current line of QUOTES; rand ($.) will thus return a random number
# between 0 and the current line number.

# If that random number is less than 1, then it will set $quote to the
# current line. So, for the first line, we have a 1/1 chance of setting
# $quote to the current line. For the second, we have a 1/2 chance of
# replacing $quote. And 1/3, 1/4, 1/5, and so on.

# It turns out mathematically that since the last line has a chance
# equal to 1 / the number of lines we've seen of becoming $quote, ALL
# the lines actually have an equal chance of ending up there. How
# cool!

rand ($.) < 1 && ($quote = $_) while <QUOTES>;
close (QUOTES);
chomp $quote;

open (SIG, ">$ENV{HOME}/.signature");
print SIG 
"Brought to you by the letters $letter1 and $letter2 and the number $number.
$quote
$footer\n";
close SIG; 

__END__
