#!/usr/bin/perl

use strict;
use warnings;

use OOP_Protein;

open(my $OUT,'>',"./protein_output.txt");


# Generate protein sequence with fixed length
my $fixed_protein = OOP_Protein->new(size => 50, status => 'fixed', protein_sequence => "");

$fixed_protein->random_protein();

my $fixed_sequence = $fixed_protein->protein_sequence;
my $fixed_status = $fixed_protein->status;

print $OUT "Fixed: $fixed_sequence\n";


# Generate protein sequence with random length
my $random_protein = OOP_Protein->new(size => 50, status => 'random', protein_sequence => "");

$random_protein->random_protein();

my $random_sequence = $random_protein->protein_sequence;
my $random_status = $random_protein->status;

print $OUT "Random: $random_sequence\n";


close $OUT;
