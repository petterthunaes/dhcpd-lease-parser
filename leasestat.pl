#!/usr/bin/perl

use strict;
use warnings;

use lib "/Users/petter/perl5/lib/perl5";
use Data::Dumper;

my $filename = "test/dhcpd.leases";

my $open = 0;
my $decl = {};
my $ip;

my ($i,$k);

open my $fh, '<', $filename or die "ERR - Could not open file: $!";
while (my $line = <$fh>) {
	chomp($line);
	if ( ! $open && $line =~ /^lease (\d+\.\d+\.\d+\.\d+) \{$/ ) {
		$ip = $1;
		$open = 1;
		$i++;
		next;
	}

	if ( $open ) {
		if ( $line =~ /\}$/ ) {
			$open = 0;
		} else {
			$k++;
			$decl->{$i}->{$ip}->{$k} = $line;
		}
	}
	
}

print Dumper($decl);

exit 0;
