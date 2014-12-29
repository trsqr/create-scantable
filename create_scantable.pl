#!/usr/bin/perl

use warnings;

$num_args = $#ARGV + 1;
if ($num_args != 1) {
    print "error: invalid amount of command line parameters\n\n";
    print "Convert kingofsat.net ini file to DVBV5 initial scan file\n";
    print "  Usage: $0 [ini file]\n";
    exit;
}
     
my $filename = $ARGV[0];
open(my $fh, '<:encoding(UTF-8)', $filename)
	or die "Could not open the kingofsat.net ini file '$filename': $!.\n";

print "# automatically generated from kingofsat.net ini file $filename\n";
     
while (my $row = <$fh>) {
	chomp $row;
	my @n = split(',', $row);
	my $number = scalar(@n);
	if ($number == 6) {
		my $error = 0;
		my $delsys = "";
		my $polarization = "";
		my $fec = "";
		my $frequency = "";

		if ('DVB-S' eq $n[4]) {
			$delsys = "DVBS";
		} elsif ('S2' eq $n[4]) {
			$delsys = "DVBS2";
		} else {
			print STDERR "Invalid delivery system on line: $row\n";
			$error = 1;
		}

		if ('H' eq $n[1]) {
			$polarization = "HORIZONTAL";
		} elsif ('V' eq $n[1]) {
			$polarization = "VERTICAL";
		} else {
			print STDERR "Invalid polarization on line: $row\n";
			$error = 1;
		}

		if (length($n[3]) == 2) {
			$fec = substr($n[3], 0, 1) . "/" . substr($n[3], 1);
		} else {
			print STDERR "Invalid FEC on line: $row\n";
			$error = 1;
		}

		my @tmp = split('=', $n[0]);
		if (scalar(@tmp) == 2) {
			$frequency = $tmp[1];
		} else {
			print STDERR "Invalid frequency on line: $row\n";
			$error = 1;
		}
		
		

		if ($error == 0) {
			print "[CHANNEL]\n";
			print "\tDELIVERY_SYSTEM = $delsys\n";
			print "\tFREQUENCY = $frequency" . "000\n";
			print "\tPOLARIZATION = $polarization\n";
			print "\tSYMBOL_RATE = $n[2]" . "000\n";
			print "\tINNER_FEC = $fec\n";
			print "\tINVERSION = AUTO\n";
			print "\n";
		}
	}
}
