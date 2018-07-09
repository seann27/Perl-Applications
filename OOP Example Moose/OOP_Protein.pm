package OOP_Protein;

use strict;
use warnings;

use Moose;

=pod

=head1 DESCRIPTION

This script creates a protein object which has the ability to generate a random protein sequence of a specified length. If the random option is chosen, the length of the sequence will be between 0 and the specified length. If the option is not chosen, the length will remain fixed.

=cut

has size => ( is => 'rw' );
has status => ( is => 'rw' );
has protein_sequence => ( is => 'rw' );

my @peptides = ('A','R','N','D','C','E','Q','G','H','I','L','K','M','F','P','S','T','W','Y','V');

sub random_protein {
	my ($self) = (@_);

	my $status = $self->status;
	my $length = $self->size;

	if (defined $length) {
	}
	else {
		die "Error! No length argument detected!";
	}
	
	

	if ($status eq "random")
	{
		$length = int(rand $length);	
	}

	my @sequence = ('M');
	for (my $i=0; $i<$length-1; $i++) {
		my $protein = int(rand @peptides);
		push (@sequence, $peptides[$protein]);
		}
	my $protein_sequence = join('',@sequence);
	$self->protein_sequence("$protein_sequence");
	return $self;
}

1;
