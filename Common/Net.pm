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

sub scp_upload (@){}

sub scp_upload (@) {
	my %args = @_;
	$error = "no file given to upload" and return undef unless length $args{file};
	$error = "no hostname provided" and return undef unless length $args{host};
	$error = "no ssh port provided" and return undef unless length $args{port};
	$error = "no ssh username provided" and return undef unless length $args{user};
	$error = "no ssh key provided" and return undef unless length $args{key};
	$error = "no remote path provided" and return undef unless length $args{remote_path};
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
	$error = "upload failed: ".$ssh->error and return undef unless $ssh->scp_put("$args{file}", $args{remote_path}.$args{file}->basename);
	$ssh->disconnect;
	return 1;
}

1;
__END__
