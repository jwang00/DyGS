#!usr/bin/perl
use strict;
use warnings;
use sort "_quicksort";

#example data
#Gene	s1	s2	s3	s4	s5	s6
#g1	1	1	1	1	0	0	
#g11	1	1	1	1	0	0
#g2	0	0	1	1	0	0
#g3	0	0	0	0	0	1
#g4	1	0	1	0	1	0

#input
my $data = $ARGV[0];
my $p1infile = $ARGV[1];
my $p2infile = $ARGV[2];

my %p1;
my %p2;

load_genes(\%p1,$p1infile);
load_genes(\%p2,$p2infile);

# Load genes as hash
sub load_genes{
    my($ref,$infile) = @_;
    open(IIN,$infile) or die $!;
    while(<IIN>){
        s/\r|\n//g;
        next if (/^#/);
        $ref->{$_} = 1;
    }
    close IIN;
}

#organize the data
my (%genes,@sample_name);
open (IN,$data) || die $!;
while (<IN>) {
    s/\r|\n//g;
	if (/^Gene/) {
		my @tmp = split("\t");
		@sample_name = @tmp[1..$#tmp];
	}else {
		my @tmp = split("\t");
		my $g = $tmp[0];
		my @d = @tmp[1..$#tmp];
		foreach my $i (1..$#tmp) {
			my $v = $d[$i-1];
			next if ($v == 0);
			my $s = $sample_name[$i-1];
			$genes{$g}{$s} = 1;
		}
	}
}
close IN;

#do the calculation
open (OUT,">Result_${data}") || die $!;
while (scalar keys %genes) {
    ## Sort genes, if it has most samples linked, then it rank at first 
    my @genes = sort {scalar(keys %{$genes{$b}}) <=> scalar(keys %{$genes{$a}})} keys %genes;

    ## get genes which have the largest linked samples 
    my @max_genes = (shift @genes);
    my $largest_linked_samples = scalar(keys %{$genes{$max_genes[0]}});
    foreach my $g (@genes){
        if(scalar(keys %{$genes{$g}}) == $largest_linked_samples){
            push @max_genes,$g;
        }else{
            last;
        }
    }
    my $max_g = "";
    if(scalar(@max_genes)>1){
        ## There is tie, according to the priority in list p1 and p2, pick up the corresponding one
        my %tmp;
        foreach my $g (@max_genes){
            my $v = 0;
            if(exists($p1{$g})){
                $v+=2;
            }
            if(exists($p2{$g})){
                $v+=1;
            }
            $tmp{$g} = $v;
        }
        my @tmp = sort {$tmp{$b}<=>$tmp{$a}} keys %tmp;
        $max_g = $tmp[0];
    }else{
        $max_g = $max_genes[0];
    }
#	print $max_g,"\n";
    my @linked_samples = sort keys %{$genes{$max_g}};
    print OUT "$max_g: ",join ",",@linked_samples;
    print OUT "\n";

    ## delete some data
    delete $genes{$max_g};
    
    foreach my $g (keys %genes){
        foreach my $s (@linked_samples){
            if(exists($genes{$g}{$s})){
                delete($genes{$g}{$s})
            }
        }
        unless(scalar keys %{$genes{$g}}){
            delete($genes{$g})
        }
    }    
}
close OUT;
