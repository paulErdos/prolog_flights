#!/usr/bin/perl -w

				# WHIP -- web hosted IP script
				# FTPs a nicely formatted display
				# of your current IP address to 
				# a server.

				# written 24 Nov 1997, che@debian.org
				# This script is released under the
				# GNU General Public License, version
				# 2 or later.

				# Thanks to Arlon for much-needed
				# suggestions and improvements.
				# Good buck. :)

				# Change the settings below to reflect
				# your setup.

my @devices = qw(ppp0 ppp1 ppp2);	
				# Which devices do we want to check?
				# Change to 'eth0' for ethernet,
				# 'sl0' for slip, et cetera. You may
				# add as many devices as you like,
				# just separate them by spaces.
				# The first device that has an IP
				# is the one we use.

my $upload_server = 'www';	
				# Change 'www' to the name of the server
				# you wish to upload your page to.

my $upload_user = 'username';
				# Change this to your username on the
				# above server.

my $upload_password = 'password';
				# Change this to your password on the
				# upload server.

my $upload_directory = 'public_html';

				# Change the above to the directory in 
				# which you'd like to put the web page.

my $upload_file = 'dynamic.html';

				# Change the above to the filename you'd
				# like to store the file in.

use Net::FTP;
use POSIX;

my $ip;

foreach my $device (@devices) { # The first device in @devices to have
  $ip = get_ip($device);	# a legal IP is assumed to be the one
  last if defined $ip;		# we want.
}

if (not defined $ip) {
  die "Could not get a IP for any of the devices: @devices\n";
}

my $tempname = tmpnam();	# tmpnam() is from the POSIX module
my $date = scalar localtime();

open (TEMP, ">$tempname") or die "Couldn't open temp file $tempname for writing: $!\n";

print TEMP <<EOF;
<html>
<title>$upload_user\'s Dynamic IP Address</title>
<body>
<h1>$upload_user\'s Dynamic IP Address</h1>
<p>My current IP address is <b>$ip</b>
<p>
<a href="telnet://$ip">Access via telnet</a><br>
<a href="http://$ip">Access via web</a><br>
<a href="ftp://$ip">Anonymous ftp</a>

<p>
Yiff!

<hr>

This page was brought to you on $date by <a
href="http://csl.cse.ucsc.edu/~ben/whip/">WHIP, the Web-Hosted IP
script</a>, copyright 1997, 1999 by Ben Gertzfield, &lt;<a
href="mailto:che\@debian.org">che\@debian.org</a>&gt;.

</body>
</html>
EOF

close TEMP;

my $ftp = Net::FTP->new($upload_server);

$ftp->login($upload_user, $upload_password) or die "FTP login as user $upload_user failed.\n";

$ftp->cwd($upload_directory) or die "Could not FTP to dir $upload_directory.\n";

$ftp->ascii();

$ftp->put($tempname, $upload_file) or die "Could not put file $tempname as $upload_file.\n";

$ftp->quit();

unlink $tempname or die "Couldn't delete $tempname: $!\n";

# get_ip: from a device name, run 'ifconfig' and get the IP address of
# that device. Return the IP address you find.

sub get_ip {
  my $device = shift;

  open (IFCONFIG, 'ifconfig |') or die "Couldn't open ifconfig for reading: $!\n";
  
  while (<IFCONFIG>) {
    if (/^$device/) {		# Found the device, so..
      my $line_to_munge = <IFCONFIG>; # Get the next line.
      my ($ip) = $line_to_munge =~ /inet addr:(\d+\.\d+\.\d+\.\d+) /;
      close IFCONFIG;
      return $ip;
    }
  }
  return undef;			# if we get here the device wasn't found
}

__END__
