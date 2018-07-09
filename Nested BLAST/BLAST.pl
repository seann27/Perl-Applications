#!/usr/bin/perl

use strict;
use warnings;

use Bio::Perl;
use Bio::Tools::Run::RemoteBlast;
use Bio::SearchIO;

print "Please enter an accession number from the GenPept database you would like to run the nested BLAST on: ";

our $accession = <STDIN>;
# Obtain user entered accession
chomp ($accession);

our $original_acc = $accession;

print "The primary BLAST will be performed on Accession $accession.\n";

our $filename;

# Create factory object for remote BLAST
our $factory = Bio::Tools::Run::RemoteBlast->new( -prog => 'blastp' , -data => 'nr' , -expect => '1e-10' , -readmethod => 'SearchIO' );

# BLAST submethod which uses accession number and file status (whether it is primary or secondary search) as parameters.
# Generates a BLAST output file and sets global filename variable to filepath of output file
sub BLAST {
	my ($accession, $status) = (@_);
	my $db = 'genpept';
	my $seq_object = get_sequence($db, $accession);
	$factory->submit_blast( $seq_object );

	while ( my @rids = $factory->each_rid ) {
	    foreach my $rid ( @rids ) {
		my $result = $factory->retrieve_blast( $rid );
		if( ref( $result )) {
			my $output = $result->next_result();
			$filename = $output->query_name()."_$status.out";
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

# Submethod to return the first top non-self hit object. Compares against global accession value.
sub get_top_hit {
	my $searchio = Bio::SearchIO->new(-format => "blast", -file => "$filename");
	my $result = $searchio->next_result;
	my $hit = $result->next_hit;
	my $acc = $hit->accession();
	while ($acc =~ m/$accession/) {
		$hit = $result->next_hit;
		$acc = $hit->accession();
	}
	return $hit;
}

# Retrieves and prints attributes associated with hit object
sub get_hit_attributes {
	my ($hit_obj) = (@_);
	my $acc = $hit_obj->accession();
	my $name = $hit_obj->name();
	my $description = $hit_obj->description();
	my $bits = $hit_obj->bits();
	my $E_value = $hit_obj->significance();
	my $length = $hit_obj->length;

	print "ACCESSION: $acc\n";
	print "NAME: $name\n";
	print "DESCRIPTION: $description\n";
	print "SCORE: $bits\n";
	print "E VALUE: $E_value\n";
	print "LENGTH: $length\n";
}

# Prints a statement if the top non-self hit of the secondary BLAST search is the same as the original user entered accession number
sub cross_check_original_sequence {
	my ($acc) = (@_);
	if ($acc =~ m/$original_acc/) {
	print "\n*******************************************************************************************************************************************\n";
	print "NOTE: The top non-self hit for the secondary BLAST search is the sequence that the user originally entered at the beginning of the program.\n";
	print "*******************************************************************************************************************************************\n\n";
	}
}

# BLAST primary accession number
BLAST($accession, "PRIMARY");
my $first_hit = get_top_hit();
# Set global accession variable to top non-self hit accession
$accession = $first_hit->accession();

print "###########################################################\n\n";
print "The top hit from the primary blast is Accession $accession\n\n";
print "###########################################################\n\nSubmitting secondary BLAST for top hit...\n\n";

# BLAST secondary accession number
BLAST($accession, "SECONDARY");
my $second_hit = get_top_hit();

# Print attributes of top non-self hit of second BLAST search
print "\nHere are the properties for the top non-self hit for the second BLAST search:\n";
cross_check_original_sequence($second_hit->accession());
get_hit_attributes($second_hit);


