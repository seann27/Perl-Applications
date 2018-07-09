package RestrictionEnzyme;

use Moose;

=pod

=head1 DESCRIPTION

This script creates a restriction enzyme object with attributes such as name, manufacturer, and recognition site. The cut_dna() method splits a DNA sequence into fragments at points in the string that equal the restriction site virtually "cutting" the sequence. This methods returns an array of fragments.

=cut

has name => ( is => 'rw' );
has manufacturer => ( is => 'rw' );
has recognition_sequence => ( is => 'rw' );

sub cut_dna {
	my ($self, $DNA) = (@_);
	my $digest = $self->recognition_sequence;
	my @fragments = split ($digest,$DNA);
	foreach my $frag (@fragments) {
		if ($frag ne $fragments[-1]) {
			$frag = $frag.$digest;
		}
	}
	return @fragments;

}

1;
