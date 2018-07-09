package Analyze_DNA;

use strict;
use warnings;

use Exporter 'import';
our @EXPORT_OK = ('translate_DNA');

=pod

This package uses a global hash to store codons with their respective amino acids. The method "translate_DNA" takes an input string of DNA and separates it into an array of three letter substrings which are the codons. The method then returns a peptide sequence after parsing through the input string. The method will not return a translated sequence unless a start codon is found. Errors will be returned if there is an invalid character in the input string, if no start codon is detected, and if no stop codon is detected.

=cut

# Generate codon library
our %library = ( I => "ATT|ATC|ATA", L => "CTT|CTC|CTA|CTG|TTA|TTG", V => "GTT|GTC|GTA|GTG", F => "TTT|TTC", M => "ATG", C => "TGT|TGC", A => "GCT|GCC|GCA|GCG", G => "GGT|GGC|GGA|GGG", P => "CCT|CCC|CCA|CCG", T => "ACT|ACC|ACA|ACG", S => "TCT|TCC|TCA|TCG|AGT|AGC", Y => "TAT|TAC", W => "TGG", Q => "CAA|CAG", N => "AAT|AAC", H => "CAT|CAC", E => "GAA|GAG", D => "GAT|GAC", K => "AAA|AAG", R => "CGT|CGC|CGA|CGG|AGA|AGG", stop => "TAA|TAG|TGA");

# Switch keys to point to peptides
our %codons = reverse %library;

sub translate_DNA {
	my ($sequence) = (@_);
	# Terminates program if residue is invalid
	if ($sequence !~ m/^(A|T|C|G)*$/) {
		die("Error! Invalid character detected in your sequence. Program will now terminate.\n");
	}
	my @nucleotides;
	push @nucleotides, substr($sequence,0,3,"") while length($sequence);
	my $translate = 0;
	my @translation;
	foreach my $residue (@nucleotides) {
		foreach my $key (keys %codons) {
			if ($residue =~ m/$key/) {
				# Turns on/off translation once start/stop codons are found				
				if ($codons{$key} eq "M") {
					$translate = 1;
				}elsif ($codons{$key} eq "stop") {
					$translate = 0;
				}
				# Adds peptides to translated sequence
				if ($translate == 1) {
					push @translation, $codons{$key};
				}
			}
		}
	}
	
	my $size = @translation;
	print "Error! No start codon detected!\n" if ($size == 0);
	print "Warning! No stop codon detected!\n" if ($translate == 1);
	my $translation = join ('', @translation);
	return $translation;
}

1;



