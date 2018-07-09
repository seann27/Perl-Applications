#!/usr/bin/perl

use strict;
use warnings;

use Analyze_DNA ("translate_DNA");

use Bio::Perl;

my $file = './data.fasta';

my @bio_seq_objects = read_all_sequences($file);
my %fastas;
my $counter = 0;

foreach my $seq( @bio_seq_objects ) {
	my $name = $seq->display_id;
	my $sequence = $seq->seq;
	my $first_ten = $seq->subseq(1,10);
	my $translated = translate_DNA($sequence);
	$seq->seq($translated);

	$counter = $counter+1;

	$fastas{"$counter"} = $seq;

	print "($counter) Name: $name | Sequence: $first_ten ...\n";


}

print "Please select the sequences you would like to BLAST by typing the number of the sequence. Please separate multiple entries by a comma: ";

my $user_input = <STDIN>;
chomp($user_input);

my @selections = split(/\s*,\s*/,$user_input);

foreach my $var (@selections) {
	die "Error, your selection of $var is not an entry: Error" if ($var > $counter || $var =~ /\D+/);
	my $name = $fastas{"$var"}->display_id;
	print "\nCurrent Selection: $name\n";
	my $blast = blast_sequence($fastas{"$var"});
	my $output = "./blast_output_peptides_$var-$name.txt";
	write_blast( ">$output", $blast);
}
