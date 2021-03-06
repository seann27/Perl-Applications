#!/usr/bin/perl

use strict;
use warnings;

use RestrictionEnzyme;

my $enzyme = RestrictionEnzyme->new(name => 'test_Name', manufacturer => 'test_manufacturer', recognition_sequence => 'AAGCT');
my $DNA = 'AGAGATCGTGCTGCAGCGCTAGCTGCAAGCTCGACTGGCGCGGCGCCAAGCTATAGCTAGCTG';

my @fragments = $enzyme->cut_dna($DNA);

foreach my $var (@fragments) {
	print "$var\n";
}
