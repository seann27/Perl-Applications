package OS_RestrictionEnzyme;

use strict;
use warnings;

=pod

=head1 DESCRIPTION

This script creates a restriction enzyme object with attributes such as name, manufacturer, and recognition site. The properties of the object are defined in a {} method along with the permissions associated with the attributes. The cut_dna() method splits a DNA sequence into fragments at points in the string that equal the restriction site virtually "cutting" the sequence. This methods returns an array of fragments.

=cut

{
	my %attribute_properties = (
		name => ['unknown','read.write'] ,
		manufacturer => ['unknown','read.write'] ,
		recognition_sequence => ['unknown','read.write'] ,
	);

	sub all_attributes {
		return keys %attribute_properties;
	}

	sub permissions {
		my( $self, $attrib) = (@_);
		return $attribute_properties{$attrib}[1];
	}
}

sub new {
	my ( $class, %attributes ) = (@_);
	my $self = bless {},$class;
	foreach my $attrib ( $self->all_attributes() )	{
		my $arg = $attrib;
		$self->{$attrib} = $attributes{$arg};
	}

	return $self;
}

sub cut_dna {
	my ($self, $DNA) = (@_);
	my $digest = $self->{recognition_sequence};
	my @fragments = split ($digest,$DNA);
	foreach my $frag (@fragments) {
		if ($frag ne $fragments[-1]) {
			$frag = $frag.$digest;
		}
	}
	return @fragments;

}

1;
