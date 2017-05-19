#!usr/bin/perl

use strict;
use warnings;

my ($file) = @ARGV;

my (@samples,%genes,@genes,%sample_all);
open (SMP,$file) || die $!;  
while (<SMP>) {
	s/\r|\n//g;
	next if /^Gene/;
	next if /^#/;
	my @tmp = split("\t");
	$genes{$tmp[0]} = 1;
	my $smps = $tmp[5];
	my @smps = split(",",$smps);
	foreach my $s (@smps) {
		$sample_all{$s} = 1;
	}
}
foreach my $g (keys %genes) {
	push @genes,$g;
}

#open (OUT,">Sample_Unique_$file") || die $!;
foreach my $smp (keys %sample_all) {
	push @samples,$smp;
#	print OUT $smp,"\n";
}
#close OUT;

#print "gene:",scalar @genes,"\n";
#print "sample:",scalar @samples,"\n";

my %data; ###in order to unique genes and combine samples
open (SMP,$file) || die $!; 
while (<SMP>) {
	s/\r|\n//g;
	next if /^Gene/;
	my @tmp = split("\t");
	my $gene = $tmp[0];
	my $smps = $tmp[5];
	#print $smps,"\n";
	$data{$gene}{$smps} = 1;
}
close SMP;

open (OUT,">Matrix_$file") || die $!;
print OUT join("\t",("Gene",@samples))."\n";
foreach my $g (keys %data) {
	my %smps = %{$data{$g}};
	my %samples;	
	foreach my $ss (keys %smps) {
		my @smps = split(",",$ss);
		foreach my $s1 (@smps) {
			#print $s1,"\n";
			$samples{$s1} = 1;
		}
	}
	my @v;
	foreach my $sm (@samples) {
		if (defined $samples{$sm}) {
			push @v,"1";
		}
		else {push @v,"0";}
	}
	print OUT join("\t",($g,@v))."\n";
}
close SMP;
close OUT;
