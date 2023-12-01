use strict;
use warnings;
use File::Basename;

my $file = $ARGV[0] // dirname(__FILE__) . "/in.txt";
open(my $fh, '<', $file) or die "$file: $!";
my @lines = <$fh>;
close $fh;

my @words = qw(one two three four five six seven eight nine);
my %val = map { $words[$_ - 1] => $_ } 1 .. 9;
$val{$_} = $_ for 1 .. 9;
my $any = join '|', keys %val;

my ($p1, $p2) = (0, 0);
for my $line (@lines) {
    my @d = $line =~ /(\d)/g;
    $p1 += $d[0] . $d[-1] if @d;
    my ($first) = $line =~ /($any)/;
    my ($last) = $line =~ /.*($any)/;
    $p2 += $val{$first} . $val{$last};
}
print "$p1\n$p2\n";
