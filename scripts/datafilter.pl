#! /usr/bin/perl

use warnings;
use strict;

# Extract all float numbers in given files. Compute their absolute
# values, sort them, select a portion, and save them in new files
# with subfix '_float'.
# Author: Zhao Zhixu

my $portion = shift @ARGV;
my $filename;
while ($filename = shift @ARGV) {
  next if -d $filename;
  # next if not $filename =~ /\.txt$/;

  open INFILE, "< $filename" or die "No file named $filename. ($!)";
  print "Preprocessing file \"$filename\"...";

  my @floats = ([], []);        # for original and abs values
  while (<INFILE>) {
    my @words = split /\s+/, $_;

    foreach (@words) {
      if (/([-+]?\d+\.?((\d)*e?[-+]?\d+)?)/) {
        push @{$floats[0]}, $1;
        push @{$floats[1]}, abs($1);
      }
    }
  }
  my $n = @{$floats[0]};
  if ($n == 0) {
    print "\nNo float number in file \"$filename\"\n";
    next;
  }

  my @order = sort {$floats[1]->[$a]<=>$floats[1]->[$b]} 0..$#{$floats[0]};
  # my $n_bezero = $portion/100 * $n;
  for(0..($portion/100 * $n - 1)) {
    $floats[0]->[$order[$_]] = 0;
  }
  # my @outputs;
  # foreach (@order) {
  #   push @outputs, $floats[0]->[$_];
  # }
  # splice @outputs, 0, $portion/100 * $n, (split / /, "0 "x($portion/100 * $n));

  open OUTFILE, ">${filename}_float" or die "Can't open file ${filename}_float. ($!)";

  print OUTFILE join "\n", @{$floats[0]};
  print "done\n";
  print "${filename}: max = ${floats[0]->[$order[-1]]}, min = ${floats[0]->[$order[0]]}\n";
  # print "Preprocess outputs saved in \"${filename}_float\"\n";

  close OUTFILE;
  close INFILE;
}
