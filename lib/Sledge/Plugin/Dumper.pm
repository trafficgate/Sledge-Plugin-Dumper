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
