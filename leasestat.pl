#!/usr/bin/perl

use strict;
use warnings;

use lib "/Users/petter/perl5/lib/perl5";
use Data::Dumper;

my $filename = "test/dhcpd.leases.new";

my $open = 0;
my $decl; 

open my $fh, '<', $filename or die "ERR - Could not open file: $!";

my ($ip,$i,$k);

while (my $line = <$fh>) {

	if ( $line =~ /^(server-duid|failover)/ ) {
		next;
	}

	$line =~ s/^\s+//;
	$line =~ s/\s+$//;	

	if ( $line =~ /^lease (\d+\.\d+\.\d+\.\d+) \{$/ ) {
		$ip = $1;
		$i++;
		next;
	}
	if ( $line =~ /\}$/ ) {
		next;
	} else {
		my ($value_name,$value);
		if ( $line =~ /^starts (\d) (\d+)\/(\d+)\/(\d+) (\d+\:\d+\:\d+)\;$/ ) {
			$value_name = "starts";
			$value = "$1 $2-$3-$4 $5";
		} 
       
       if( $line =~ / (\d) (\d+)\/(\d+)\/(\d+) (\d+\:\d+\:\d+)\;$/ ) {
       	$value = "$1 $2-$3-$4 $5";
        $value_name = "$1"	if $line =~ /^(ends|tstp|tsfp|atsfp|cltt) /;
       }
       elsif( $line =~ /^binding state (\w+)\;$/ ){ 
       	$value = $1;
       	$value_name = "binding-state";
       }
              elsif( $line =~ /^next binding state (\w+)\;$/ ){ 
       	$value = $1;
       	$value_name = "next-binding-state";
       }
       
       elsif ( $line =~ /^hardware ethernet (.*)\;$/ ) {
       	$value_name = "hardware-ethernet";
            $value = $1;
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

for my $k1 ( sort keys %$decl ) {
	print "$k1\n";
	for my $k2 ( sort keys %{$decl->{$k1}} ) {
		print "\t$k2\n";
		for my $k3 ( sort keys %{$decl->{$k1}->{$k2}} ) {
			print "\t\t$k3 -- " . $decl->{$k1}->{$k2}->{$k3} . "\n";
		}
	}

}

exit 0;
