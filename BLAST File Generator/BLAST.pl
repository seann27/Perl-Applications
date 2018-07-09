#!/usr/bin/perl

use strict;
use warnings;

use Bio::Perl;
use Bio::Tools::Run::RemoteBlast;

my $acc = $ARGV[0];
my $EValue = $ARGV[1];

die "Error! Invalid E-value detected.\n" unless ($EValue =~ /^\de-?\d+$/);

# Create factory object for remote BLAST
our $factory = Bio::Tools::Run::RemoteBlast->new( -prog => "blastp" , -data => "nr" , -expect => "$EValue" , -readmethod => "SearchIO" );
our $filename;

# BLAST submethod which uses accession number as parameter.
# Generates a BLAST output file and sets global filename variable to filepath of output file
sub BLAST {
	my ($accession) = (@_);
	my $db = 'genpept';
	my $seq_object = get_sequence($db, $accession);
	print "Submitting BLAST for $accession . . .\n";
	$factory->submit_blast( $seq_object );

	while ( my @rids = $factory->each_rid ) {
	    foreach my $rid ( @rids ) {
		my $result = $factory->retrieve_blast( $rid );
		if( ref( $result )) {
			my $output = $result->next_result();
			$filename = $output->query_name()."_QUERY.out";
			$factory->save_output( $filename );
			$factory->remove_rid( $rid );
			print "\n\tGot ",$output->query_name(),"\n\n";
			}
		elsif( $result<0 ) {
			print "error\n";
			$factory->remove_rid( $rid );
			}
		else {
			print ".";
			sleep 5;
			}	
		}
	}

	print "done\n\n";
}

# Submethod to store all hit objects in array.
sub get_hits {
	print "Grabbing all hits from blast file . . .\n";	
	my @hits;	
	my $searchio = Bio::SearchIO->new(-format => "blast", -file => "$filename");
	my $result = $searchio->next_result;
	while (my $hit = $result->next_hit) {
	push @hits,$hit;
	}
	print "\nHits retrieved.\n\n";
	return @hits;
}

# Writes hit attributes to file, including sequencing information fetched from database.
sub write_hit_attributes {		
	my ($hit_obj) = (@_);
	my $acc = $hit_obj->accession();
	my $name = $hit_obj->name();
	my $description = $hit_obj->description();
	my $bits = $hit_obj->bits();
	my $E_value = $hit_obj->significance();
	my $length = $hit_obj->length;

	my $db = 'genpept';
	my $seq_object = get_sequence($db,$acc);
	my $sequence = $seq_object->seq;

	my $filename = "SEQUENCE_".$acc.".out";
	print "Creating $filename file . . .\n";
	open(my $OUT,">",$filename);

	print $OUT ">$acc | ";
	print $OUT "$name | ";
	print $OUT "$description\n";
	print $OUT ">Score (bits): $bits\n";
	print $OUT ">E-value: $E_value\n";
	print $OUT ">Length: $length\n";
	print $OUT ">Sequence:\n$sequence\n";
	
	close $OUT;
	print "$filename complete.\n\n";
}

BLAST($acc);
my @hits = get_hits();
if (@hits) {
	foreach my $hit (@hits) {
		write_hit_attributes($hit);
	}
} else {
	print "No hits satisfied the parameters you entered! Goodbye!\n";
}
