# Haver::Utils::Logger, implements a logging POE session.
# 
# Copyright (C) 2003 Dylan William Hardison.
#
# This module is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This module is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this module; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

# TODO, write POD. Soon.
# XXX The API for this should be made cleaner. XXX

package Haver::Utils::Logger;
use strict;
use warnings;
use Carp;
use POE;

BEGIN {
	no strict 'refs';

	foreach my $c (qw(error raw note debug)) {
		*{$c} = sub {
			$poe_kernel->post('Logger', $c, join('',@_));
		};
	}
}

use Exporter;
use base 'Exporter';

our @EXPORT    = qw(error raw note debug);
our @EXPORT_OK = @EXPORT;

sub create {
	my ($class, $config) = @_;
	POE::Session->create(
		package_states => 
		[
			$class => {
				_start => '_start',
				_stop  => '_stop',
				map { ( $_ => "on_$_" ) } qw(
					error
					raw
					note
					debug
					shutdown
				),
			},
		],
		heap => [],
	);
}

sub _start {
	my ($kernel, $heap) = @_[KERNEL, HEAP];
	print STDERR "Logging started\n";
	$kernel->alias_set('Logger');
}

sub _stop {
	print STDERR "Logging stops\n";
}

sub on_shutdown {
	$_[KERNEL]->alias_remove('Logger');
}
	
sub on_error {
	my ($kernel, $heap, $msg) = @_[KERNEL, HEAP, ARG0];
	print "ERROR: $msg\n";
}

sub on_raw {
	my ($kernel, $heap, $msg) = @_[KERNEL, HEAP, ARG0];
	print "RAW: $msg\n";
}
sub on_note {
	my ($kernel, $heap, $msg) = @_[KERNEL, HEAP, ARG0];
	print "NOTE: $msg\n";
}

sub on_debug {
	my ($kernel, $heap, $msg) = @_[KERNEL, HEAP, ARG0];
	print "DEBUG: $msg\n";
}

1;
