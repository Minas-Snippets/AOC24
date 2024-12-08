#!/usr/bin/perl

our $n = -1;
my %a;

while(<>) {
    $n++;
    push(@{$a{$2}},$n,length($1)) while s/^(\.*)(\w)/$1./
}

my ($sum1, $sum2, %p) = ( 0, 0 );

for my $limit ( 1, 0 ) {
    %p = ( );
    while( my ($k,$v) = each(%a) ) {
        my $c = @$v/2;
        next unless $c > 1;
        for my $i (0 .. $c-2) {
            for my $j ($i+1 ..$c-1) {
                my @a = a((@$v)[2*$i,2*$i+1,2*$j,2*$j+1],$limit);
                for (0 .. @a/2-1) {
                    next if $p{$a[2*$_]}->{$a[2*$_+1]};
                    $limit ? $sum1++ : $sum2++;
                    $p{$a[2*$_]}->{$a[2*$_+1]} = 1
                }
            }
        }
    }
}

print "part 1: $sum1\npart 2: $sum2\n";

sub a {
    my ($v,$w,$x,$y, $limit) = @_;
    my ($dx, $dy) = ($x-$v, $y-$w);
    my @c;
    for my $k ( ($limit ? 1 : 0) .. ($limit ? 1 : $n)) {
        push( @c, t(@$_) ? @$_ : () ) for [$v-$k*$dx, $w-$k*$dy], [$x+$k*$dx, $y+$k*$dy];
    }
    return @c
}

sub t {
    return $_[0] < 0 || $_[0] > $n || $_[1] < 0 || $_[1] > $n ? 0 : 1
}
