# Haver::Base
# 
# Copyright (C) 2004 Dylan William Hardison
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
package Haver::Base;
use strict;
use warnings;

our $VERSION = "0.001";

use constant DEBUG => 1;

sub new {
	my $this = shift;
	my $me   = @_ == 1 && ref($_[0]) ?  shift : { @_ };
	my $type = ref $me;
	bless $me, ref($this) || $this;

	if ($type eq 'HASH') {
		if (!@_ and exists $me->{'-args'}) {
			@_ = @{ delete $me->{'-args'} };
		}
	}
	
	if (DEBUG) {
		_debug("Creating object: ", $me);
	}

	$me->initialize(@_);

	return $me;
}

sub initialize {undef}
sub finalize   {undef}

sub DESTROY {
	my $me = shift;
	$me->finalize();
	
	if (DEBUG) {
		_debug("Destroying object: ", $me);
	}
}

sub _debug {
	#if ($POE::Kernel::poe_kernel) {
	#	$POE::Kernel::poe_kernel->post('Logger', 'debug', join('',@_));
	#} else {
		print "DEBUG: ", join('', @_), "\n";
	#}
}


1;

