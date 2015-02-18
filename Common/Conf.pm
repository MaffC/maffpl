package Maff::Common::Conf;

use strict;
use Exporter;
use vars qw/$VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS/;

use Carp;
use YAML;

$VERSION = 1.0.0;
@ISA = qw/Exporter/;
@EXPORT = qw//;
@EXPORT_OK = qw/conf_load/;
%EXPORT_TAGS = (all=>[@EXPORT_OK]);

sub conf_load ($);

sub conf_load ($) {
	my $cfile = shift;
	return YAML::LoadFile($cfile) or return;
}

1;
__END__

=pod

=encoding UTF-8

=head1 NAME

Maff::Common::Conf - Functions related to application state preservation and whatnot

=head1 VERSION

1.0.0

=head2 conf_load ($filepath)

Accepts one variable, $filepath, which should be a fully-qualified path to a YAML config file

	my $conf_object = conf_load('/etc/perlapplication/config.yml');

=head1 AUTHOR

Matthew Connelly <matthew@maff.scot>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) Matthew Connelly, 2015

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
