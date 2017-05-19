#!usr/bin/perl

use strict;
use warnings;

my ($file) = @ARGV;

#my $sum = 0;
#print $sum,"\n";

open (OUT,">Freq_Matrix.txt") || die $!;
open (SMP,$file) || die $!;
while (<SMP>) {
	# print $_,"\n";
	s/\r|\n//g;
	next if /^Gene/;
	my @gene = split("\t");
	# print scalar @gene,"\n";
	my @genedata = @gene[1..$#gene];
	my $sum = sum(@genedata);
	# print $sum,"\n";
	#foreach my $genedata (@genedata) {
		#$sum = $sum + $genedata;
		#}
	# print join("\t",($gene[0],$sum))."\n";
	my $length = scalar @genedata;
	my $freq = $sum/$length;
	my $perc = $freq*100;
	print OUT join("\t",($gene[0],$sum,$freq,$perc))."\n";
}

close OUT;
close SMP;

sub sum {
	my @data=@_;
	my $sum=0;
	foreach (@data) {
		$sum+=$_;
	}
	return $sum;
}