package Maff::Common::IO;

use strict;
use Exporter;
use vars qw/$VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS/;

$VERSION = 1.0.0;
@ISA = qw/Exporter/;
@EXPORT = qw//;
@EXPORT_OK = qw/&write_simple &read_one/;
%EXPORT_TAGS = (all=>[@EXPORT_OK]);

sub write_simple ($$){}
sub read_one ($){}
sub validate_path ($){}

sub write_simple ($$) {
	my ($file,$data) = @_;
	validate_path $file or return undef;
	open FH, ">$file" or return undef;
	print FH $data;
	close FH;
	return 1;
}

sub read_one ($) {
	my $file = shift;
	validate_path $file or return undef;
	open FH, "<$file" or return undef;
	my $data = <FH> or return undef;
	close FH;
	return $data;
}

sub validate_path ($) {
	return 1;
}

1;
__END__
