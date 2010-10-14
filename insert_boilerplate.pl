#!/usr/bin/env perl

# I, Andrew H. Armenia, hereby release the text of this script,
# a program to insert copyright notices into source code, 
# into the public domain.
# Oct 13, 2010

use strict;
use warnings;

use File::Copy;

# The boilerplate defined below gets inserted between lines containing
# /* <bp> */ and /* </bp> */. Anything between those lines
# will get clobbered and replaced by the boilerplate.
# Works for C and anything where you can comment the rest of a line...
# (e.g # /* <bp> */).

my $boilerplate = <<EOF
/*
 * copyright notice, or whatever goes here.
 */
EOF
;

for my $arg (@ARGV) {
    my $inname = $arg.".bak";
    my $outname = $arg;
    copy($outname,$inname);
    open my $input, "<", $inname or die "failed to open input $inname: $!";
    open my $output, ">", $outname or die "failed to open output $outname: $!";

    my $mode = 0;

    while (<$input>) {
        if (/\/\* <bp> \*\//) {
            print $output $_;
            print $output $boilerplate;
            $mode = 1;
        }

        if (/\/\* <\/bp> \*\//) {
            $mode = 0;
        }

        if ($mode == 0) {
            print $output $_;
        }
    }

}
