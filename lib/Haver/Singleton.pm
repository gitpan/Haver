# Haver::Singleton
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
package Haver::Singleton;
use strict;
use warnings;

our $VERSION = "0.001";
use base 'Haver::Base';

sub new { die "Never class 'new' on a singleton class! ($_[0])" }

sub instance {
	my $this = shift;
	my $class = ref($this) || $this;
	my @args = @_;

	no strict 'refs';
	my $self = "${class}::__INSTANCE__";
	
	push (@args, @{"${class}::__INSTANCE_ARGS__"});
	
	if (${$self}) {
		return ${$self};
	} else {
		return ${$self} = $this->SUPER::new(@args);
	}

}

sub import {
	my $this = shift;
	my $class = ref($this) || $this;

	no strict 'refs';
	push(@{ "${class}::__INSTANCE_ARGS__" }, @_);
}

1;
