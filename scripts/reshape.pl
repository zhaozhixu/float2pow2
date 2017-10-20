#! /usr/bin/perl

use warnings;
use strict;

$^I = ".bak";

my $filename_data;
my $fh_data;
my $last_ARGV = "";
my @lines;
my $line;
my @words;

while (<>) {
  # if (-d $ARGV || not $ARGV =~ /\.txt$/) {
  if (-d $ARGV) {
    close ARGV;
    next;
  }
  if ($last_ARGV ne $ARGV) {
    close $fh_data if $last_ARGV ne "";
    $filename_data = "${ARGV}_float_convert";
    open $fh_data, "< $filename_data" or die "No file named $filename_data. ($!)";
    $last_ARGV = $ARGV;
    chomp (@lines = <$fh_data>);
  }

  @words = split /(?<=\s)(?=[-+]|\d)/, $_;
  # @words = /()/
  foreach (@words) {
    if (/[-+]?\d+\.?((\d)*e?[-+]?\d+)?/) {
      $line = shift @lines;
      s/[-+]?\d+\.?((\d)*e?[-+]?\d+)?/$line/;
    }
    print;
  }
}
