package Sledge::Plugin::Dumper;
# $Id$
#
# Tatsuhiko Miyagawa <miyagawa@edge.co.jp>
# Livin' On The EDGE, Limited.
#

use strict;
use vars qw($VERSION);
$VERSION = 0.03;

use Data::Dumper;
use vars qw($Indent);
$Indent = 1;			# default is 1

sub import {
    my $class = shift;
    my %args = (level => 'debug', @_); # default level debug
    my $pkg = caller;

    no strict 'refs';
    *{"$pkg\::dumper"} = sub {
	my $self = shift;
	if ($self->can('log')) {
	    local $Data::Dumper::Indent = $Indent;
	    if ($args{to}) {
		$self->log->log_to(
		    name => $args{to},
		    level => $args{level},
		    message => Data::Dumper::Dumper(@_),
		);
	    }
	    else {
		$self->log->debug(Data::Dumper::Dumper(@_));
	    }
	}
	else {
	    my($file, $line) = (caller(1))[1,2];
	    warn Data::Dumper::Dumper(@_), " at $file line $line\n";
	}
    };
}

1;

__END__

=head1 NAME

Sledge::Plugin::Dumper - Data::Dumper wrapper

=head1 SYNOPSIS


  package Test::Pages;
  use Sledge::Plugin::Dumper;

  sub dispatch_foo {
      my $self = shift;
      $self->dumper($something);
  }

  # combination with Plugin::Log
  use Sledge::Plugin::Dumper level => 'warning', to => 'syslog';

=head1 DESCRIPTION

C<Data::Dumper> を use して、 C<warn Dumper> を実行するのがメンドウな
人向けのプラグインです。

=head1 USING WITH LOGGER

Plugin::Log と併用すると、出力先をカスタマイズすることができます。デフォ
ルトは debug レベルですべてのロガーに出力します。

=head1 AUTHOR

Tatsuhiko Miyagawa <miyagawa@edge.co.jp> with Sledge development team.

=head1 SEE ALSO

L<Data::Dumper>, L<Sledge::Plugin::Log>

=cut
