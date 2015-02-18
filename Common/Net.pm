package Maff::Common::Net;

use strict;
use Exporter;
use vars qw/$VERSION @ISA @EXPORT @EXPORT_OK $error/;

use Net::SSH2;
use POSIX;
use Try::Tiny;

$VERSION = 1.0.0;
@ISA = qw/Exporter/;
@EXPORT = qw//;
@EXPORT_OK = qw/scp_upload/;
$error = undef;

sub scp_upload (@);

sub scp_upload (@) {
	my %args = @_;
	$error = "no file given to upload" and return undef unless length $args{file};
	$error = "no hostname provided" and return undef unless length $args{host};
	$error = "no ssh username provided" and return undef unless length $args{user};
	$error = "no ssh key provided" and return undef unless length $args{key};
	$error = "no remote path provided" and return undef unless length $args{path};
	$args{path} .= "/" if $args{path} !~ /\/$/;
	$args{port} = 22 unless defined $args{port} and length $args{port};
	my $ssh = Net::SSH2->new();
	try {
		$ssh->connect($args{host},$args{port},Timeout => 3);
	} catch {
		$error = "exception in ssh connect: $_";
		return undef;
	};
	$error = "ssh connect failed: ".$ssh->error and return undef if $ssh->error;
	$ssh->auth_publickey($args{user},"$args{key}.pub",$args{key});
	$error = "ssh auth failed: ".$ssh->error and return undef unless $ssh->auth_ok;
	$error = "upload failed: ".$ssh->error and return undef unless $ssh->scp_put("$args{file}", $args{path}.$args{file}->basename);
	$ssh->disconnect;
	return 1;
}

1;
__END__

=pod

=encoding UTF-8

=head1 NAME

Maff::Common::Net - Network-related functions

=head1 VERSION

1.0.0

=head1 SUBROUTINES

=over

=item scp_upload (%hash)

Accepts a hash of arguments:

	file => L<Path::Class::File> object representing the file to be uploaded
	host => FQDN of remote host to connect to
	port => SSH port number for remote host
	user => remote username for authentication
	key  => SSH key file for authentication. Expects the public key to be stored as $key.pub
	path => absolute path of directory to upload file to

Upon error, I<$Maff::Common::Net::error> will be set to the last error encountered, and the call will return L<undef|perlfunc/undef>

	scp_upload(
		file => $myfile,
		host => 'localhost',
		port => 22,
		user => 'joebloggs',
		key  => "$ENV{HOME}/.ssh/id_rsa",
		path => '/usr/local/www'
	);

=back

=head1 AUTHOR

Matthew Connelly <matthew@maff.scot>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) Matthew Connelly, 2015

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
