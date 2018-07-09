#!/usr/bin/perl

use strict;
use warnings;

use Bio::Perl;
use Bio::SeqIO;

# List of formats
my @formats = ('ab1','abi','alf','ctf','embl','exp','fasta','fastq','gcg','genbank','pir','pln','scf','ztr','ace','game','locuslink','phd','qual','raw','swiss');

my $input_file = $ARGV[0];
my $file_name = $input_file;
my $output_format = $ARGV[1];

die "Error! Filepath does not exist.\n" unless (-e $input_file);

my $format_boolean = 0;

# Check to see if command line argument for format is valid
foreach my $var (@formats) {
	$format_boolean = 1 if ($output_format eq $var);
}

die "Error! Invalid format.\n" if ($format_boolean == 0);

my @inputs = split(/\./,$file_name);

my $input_format = $inputs[-1];

# Create output file name
my $output_file = substr($input_file, 0, index($input_file,'.'));
$output_file = $output_file.".".$output_format;

########## Begin Sequence IO ##################################

open(my $OUT,'>',$output_file);

# Create input sequence object
my $seq_in = Bio::SeqIO->new( -file   => $input_file , -format => $input_format );

# Create output sequence object
my $seq_out = Bio::SeqIO->new( -file   => ">$output_file" , -format => $output_format);

# Write contents from input object to output object
while( my $seq = $seq_in->next_seq() ) {
    $seq_out->write_seq( $seq );
}

close $OUT;






