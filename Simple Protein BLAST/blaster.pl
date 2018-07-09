#!/usr/bin/perl

use strict;
use warnings;

use Bio::Perl;
use Bio::Tools::Run::RemoteBlast;
use Bio::SearchIO;

# Create algorithm requirements
my %blast_programs = ( blastp => "protein", blastn => "dna", blastx => "dna", tblastn => "protein", tblastx => "dna" );

my $algorithm = $ARGV[0];
my $query = $ARGV[1];
my $accession = $ARGV[2];

die "Error! Invalid algorithm entered.\n" unless (exists $blast_programs{$algorithm});
die "Error! Query does not match algorithm entered.\n" if ($query ne $blast_programs{$algorithm});

# Determine appropriate database and grab sequence
my $db = 'genbank' if ($query eq 'dna');
$db = 'genpept' if ($query eq 'protein');
my $sequence_object = get_sequence($db, $accession);

# Create factory and blast sequence
my $factory = Bio::Tools::Run::RemoteBlast->new(-prog => "$algorithm", -data => 'nr', => -expect => '1e-10', readmethod => 'SearchIO'); 

$factory->submit_blast($sequence_object);

while ( my @rids = $factory->each_rid ) {
	foreach my $rid ( @rids ) {
		my $result = $factory->retrieve_blast( $rid );
		if( ref( $result )) {
			my $output = $result->next_result();
			my $filename = $output->query_name()."_$algorithm.out";
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
