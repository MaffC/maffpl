package Maff::Common::Time;

use strict;
use Exporter;
use vars qw/$VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS/;

use Carp;
use DateTime;
use Date::Format qw/time2str/;

$VERSION = 1.0.0;
@ISA = qw/Exporter/;
@EXPORT = qw//;
@EXPORT_OK = qw/relative_time timefmt2str/;
%EXPORT_TAGS = (all=>[@EXPORT_OK]);

sub relative_time ($;$);
sub timefmt2str ($);

sub relative_time ($;$) {
	my $time_value = shift;
	my $relative_to = shift || DateTime->now()->epoch;
	$relative_to = $relative_to->epoch if ref($relative_to) =~ /DateTime/;
	my $delta = $relative_to - $time_value;
	if($delta < 60) {
		return 'less than a minute ago';
	} elsif($delta < 120) {
		return 'about a minute ago';
	} elsif($delta < (45*60)) {
		return int($delta / 60) . ' minutes ago';
	} elsif($delta < (90*60)||int($delta/3600)==1) {
		return 'about an hour ago';
	} elsif($delta < (24*60*60)) {
		return 'about ' . int($delta / 3600) . ' hours ago';
	} elsif($delta < (48*60*60)) {
		return '1 day ago';
	} else {
		return int($delta / 86400) . ' days ago';
	}
}

sub timefmt2str ($) {
	my $fmt = shift; my $time = time();
	return Date::Format::time2str($fmt,$time);
}

1;
__END__

=pod

=encoding UTF-8

=head1 NAME

Maff::Common::Time - Time-related functions

=head1 VERSION

1.0.0

=head1 SUBROUTINES

=over

=item relative_time ($time [, $relative_to])

Accepts up to two variables.
$time indicates the epoch time to calculate distance from/to.
$relative_to (optional) indicates the epoch time to calculate the distance between it and $time.
If $relative_to is omitted, the current epoch time will be used in its place.

	my $time = 1423169872; #current time for example would be 1423170172
	my $time_string = relative_time($time);
	#$time_string == "5 minutes ago"

	my $time = 1234567890;
	my $relative_to = 1234571490;
	my $time_string = relative_time($time, $relative_to);
	#$time_string == "1 day ago";

=item timefmt2str ($fmt)

Accepts one variable, $fmt, which contains a date/time formatting string as specified in L<strftime(3)>, and returns the result as formatted by L<Date::Format/time2str>

	my $format = '%Y-%m-%d_%H.%M.%S';
	print timefmt2str($format); # prints "2015-02-14_20.18.36"

=back

=head1 AUTHOR

Matthew Connelly <matthew@maff.scot>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) Matthew Connelly, 2015

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
