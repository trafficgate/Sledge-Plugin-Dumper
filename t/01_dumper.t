# $Id$

use strict;
use Test::More 'no_plan';

use IO::Scalar;

use_ok 'Sledge::Plugin::Dumper';

my $foo = [ 'a', 'b', 'c' ];
my $obj = bless { foo => '' }, 'Goo';

package Test::Pages;
use base qw(Sledge::Pages::Base);
use Sledge::Plugin::Dumper;

package Test::Pages::Log;
use base qw(Sledge::Pages::Base);
use Sledge::Plugin::Dumper;
use Sledge::Plugin::Log 't/log.cfg';

package Test::Pages::Log::Name;
use base qw(Sledge::Pages::Base);
use Sledge::Plugin::Dumper to => 'scr', level => 'info';
use Sledge::Plugin::Log 't/log2.cfg';

package main;
{
    my $p = bless {}, 'Test::Pages';
    my $warn;
    local $SIG{__WARN__} = sub { $warn = shift; };
    $p->dumper([ 'goo' ]);
    like $warn, qr/goo/, 'warning';
}

{
    my $p = bless {}, 'Test::Pages::Log';
    $p->invoke_hook('AFTER_INIT');

    local $Sledge::Plugin::Dumper::Indent = 0;
    tie *STDERR, 'IO::Scalar', \my $err;
    $p->log->debug('hoe');
    $p->dumper([ 'goo' ]);
    untie *STDERR;

    like $err, qr/goo/, 'warning';
    like $err, qr/\[debug\] \$VAR1 = \['goo'\];/, 'debug/indent level';
}

{
    my $p = bless {}, 'Test::Pages::Log::Name';
    $p->invoke_hook('AFTER_INIT');

    local $Sledge::Plugin::Dumper::Indent = 0;
    tie *STDERR, 'IO::Scalar', \my $err;
    $p->dumper([ 'goo' ]);
    untie *STDERR;

    like $err, qr/\[info\] \$VAR1 = \['goo'\];/, 'level is info';
    is -s 't/dummy.out', 0, 'size zero';
    unlink 't/dummy.out';
}



