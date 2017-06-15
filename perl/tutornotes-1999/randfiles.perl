#!/usr/bin/perl -w

# randfiles.perl

# Recurse through a directory (or command-line specified list of
# directories) and all its/their subdirectories and add all the files
# below that directory to a list.  Then, shuffle the list randomly and
# print it to STDOUT, separated by spaces. 

# Useful for music players (like MP3 players) that do not support a
# shuffle function.

# Usage:
# randfiles.perl [directory] [directory] [...]

# With no arguments, randfiles.perl will recurse through the current
# directory and all its subdirectories.

# I like to use randfiles.perl like so:

# % mpg123 `randfiles.perl ~/sounds/mp3`

# Copyright 1997, 1999 by Ben Gertzfield <che@debian.org>
# This work is released under the GNU GPL, version 2 or later.

use DirHandle;			# Clean way of manipulating directories
use Cwd 'chdir';		# Keeps $ENV{'PWD'} in sync with chdir() calls

srand;				# seed random number generator. unnecessary
				# in Perl >= 5.004

my @files = ();			# declare and initialize @files

unless (@ARGV) {		# recurse through current dir if no arguments
    @files = recurse('.');
}

while (@ARGV) {			# otherwise recurse through all arguments
    my $directory = shift @ARGV;

    die "$directory is not a directory!\n" unless -d $directory;

    # Now append the recursive search through $directory to the end of @files
    @files = (@files, recurse($directory));
}

# Shuffle @files randomly into @temp

my @temp;

while (@files) {
    push @temp, splice(@files, rand @files, 1);
}

print (join (' ', @temp), "\n");

# usage:
# @files = recurse($directory)

# Recurses through the specified directory and its subdirectories and
# returns a list of all normal (non-directory) files contained inside
# it. Ignores directories starting with . to avoid recursing through
# . and ..

sub recurse {
  my $directory = shift;
  my $dir = new DirHandle $directory;
  chdir $directory;

  my ($dir_entry, @files, $this_dir);

  while (defined($dir_entry = $dir->read())) {

    if (-f $dir_entry) {	# if we are looking at a normal file..
      push @files, "$ENV{'PWD'}/$dir_entry";
    } elsif (-d $dir_entry) {	# but if it's a dir, recurse through it
      next if $dir_entry =~ /^\./; # unless it's . or .. (or .anything)
      push @files, recurse($dir_entry);
    }

  }

  chdir '..';		
  return @files;
}

__END__
