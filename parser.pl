#!/usr/bin/perl

use strict;
use warnings;

use lib "/Users/petter/perl5/lib/perl5";
use Data::Dumper;

my $filename = "test/dhcpd.leases";
my ($ip,$i,$decl);

open my $fh, '<', $filename or die "ERR - Could not open file: $!";

while (my $line = <$fh>) {
	$line =~ s/^\s+//;
	$line =~ s/\s+$//;	

	if ( $line =~ /^(\#|'server-duid|failover)/ ) {
		next;
	}
	if ( $line =~ /^lease (\d+\.\d+\.\d+\.\d+) \{$/ ) {
		$ip = $1;
		$i++;
		next;
	}
	if ( $line =~ /\}$/ ) {
		next;
	} else {
		my ($value_name,$value);
		if( $line =~ / (\d) (\d+)\/(\d+)\/(\d+) (\d+\:\d+\:\d+)\;$/ ) {
			$value = "$1 $2-$3-$4 $5";
			$value_name = "$1"	if $line =~ /^(starts|ends|tstp|tsfp|atsfp|cltt) /;
		}
		elsif( $line =~ /^binding state (\w+)\;$/ ) {
			$value = $1;
			$value_name = "binding-state";
		}
		elsif( $line =~ /^next binding state (\w+)\;$/ ) { 
			$value = $1;
			$value_name = "next-binding-state";
		}
		elsif ( $line =~ /^hardware ethernet (.*)\;$/ ) {
			$value = $1;
			$value_name = "hardware-ethernet";
		}
		elsif ( $line =~ /^set (ddns-txt|ddns-fwd-name) = \"(.*)\"\;$/ ) {
			$value_name = "$1";
			$value = $2;
		}
		elsif ( $line =~ /^(client-hostname|uid) \"(.*)\"\;$/ ) {
			$value_name = "$1";
			$value = $2;
		}

		if (defined $value) {
			$decl->{$i}->{$ip}->{$value_name} = $value;
		}
	}	
}

close $fh;

while( my ($key1, $href1) = each( %$decl ) ) {
	print "$key1\n";

	while( my ($key2, $href2 ) = each( %$href1 ) ) {
		print"\t$key2\n";
		
		while( my ( $key3, $val ) = each( %$href2 ) ) {
			print "\t\t$key3 -- $val\n";
		}
	}
}

exit 0;
