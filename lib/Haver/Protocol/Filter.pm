# Haver::Protocol::Filter
# This is a POE filter for the Haver protocol.
# It subclasses POE::Filter::Line.
# 
# Copyright (C) 2003 Bryan Donlan
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

package Haver::Protocol::Filter;
use warnings;
use strict;

use POE;
use base qw(POE::Filter::Line);

our $VERSION = "0.001";

sub get {
	my ( $self, @args ) = @_;
	my $res = $self->SUPER::get(@args);
	for ( @{$res} ) {
		$_ = [ split "\t", $_ ];
		if ( exists $_->[0] ) {
			$_->[0] =~ s/\W//g;
		}
	}
	return $res;
}

sub get_one {
	my ( $self, @args ) = @_;
	my $res = $self->SUPER::get_one(@args);
	for ( @{$res} ) {
		$_ = [ split "\t", $_ ];
		if ( exists $_->[0] ) {
			$_->[0] =~ s/\W//g;
		}
	}
	return $res;
}

sub put {
	my ( $self, $arg ) = @_;
	$arg = [ @{$arg} ];
	for ( @{$arg} ) {
		if ( exists $_->[0] ) {
			$_->[0] =~ s/\W//g;
		}
		$_ = join "\t", @{$_};
	}
	return $self->SUPER::put($arg);
}

1;
