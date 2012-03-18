#!/usr/bin/perl

use strict;
use warnings;

use lib "/Users/petter/perl5/lib/perl5";
use Data::Dumper;

my $filename = "test/dhcpd.leases";

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
        if ( $line =~ /^ends (\d) (\d+)\/(\d+)\/(\d+) (\d+\:\d+\:\d+)\;$/ ) {
            $value_name = "ends"; 
            $value = "$1 $2-$3-$4 $5"; 
        }
        if ( $line =~ /^tstp (\d) (\d+)\/(\d+)\/(\d+) (\d+\:\d+\:\d+)\;$/ ) {
            $value_name = "tstp"; 
            $value = "$1 $2-$3-$4 $5"; 
        }
        if ( $line =~ /^tsfp (\d) (\d+)\/(\d+)\/(\d+) (\d+\:\d+\:\d+)\;$/ ) {
            $value_name = "tsfp"; 
            $value = "$1 $2-$3-$4 $5"; 
        }
        if ( $line =~ /^atsfp (\d) (\d+)\/(\d+)\/(\d+) (\d+\:\d+\:\d+)\;$/ ) {
            $value_name = "atsfp"; 
            $value = "$1 $2-$3-$4 $5"; 
        }
        if ( $line =~ /^cltt (\d) (\d+)\/(\d+)\/(\d+) (\d+\:\d+\:\d+)\;$/ ) {
            $value_name = "cltt"; 
            $value = "$1 $2-$3-$4 $5"; 
        }
        if ( $line =~ /^binding state (\w+)\;$/ ) {
			$value_name = "binding-state";
			$value = $1;
        }
        if ( $line =~ /^next binding state (\w+)\;$/ ) {
			$value_name = "next-binding-state";
            $value = $1;
        }
        if ( $line =~ /^hardware ethernet (.*)\;$/ ) {
			$value_name = "hardware-ethernet";
            $value = $1;
        }
        if ( $line =~ /^set ddns-txt = \"(.*)\"\;$/ ) {
			$value_name = "ddns-txt";
            $value = $1;
        }
        if ( $line =~ /^set ddns-fwd-name = \"(.*)\"\;$/ ) {
			$value_name = "ddns-name";
            $value = $1;
        }
        if ( $line =~ /^client-hostname \"(.*)\"\;$/ ) {
			$value_name = "hostname";
            $value = $1;
        }
		if ( $line =~ /^uid \"(.*)\"\;/ ) {
			$value_name = "uid";
            $value = $1;
		}
		if (defined $value) {
			$decl->{$i}->{$ip}->{$value_name} = $value;
		}
	}
	
}

for my $k1 ( sort keys %$decl ) {
	print "$k1\n";
	for my $k2 ( sort keys %{$decl->{$k1}} ) {
		print "\t$k2\n";
		for my $k3 ( sort keys %{$decl->{$k1}->{$k2}} ) {
			print "\t\t$k3 -- " . $decl->{$k1}->{$k2}->{$k3} . "\n";
		}
	}

}

#print Dumper($decl);

exit 0;
