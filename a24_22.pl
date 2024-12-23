#!/usr/bin/perl

 
my $sum = 0;

my @c;

while(<>) {
    chomp;
    push(@c, [ p($_) ]);
    $sum += pop(@{$c[-1]});
}

print "$sum\n";

my @d;
my %f;
$sum = 0;

for my $c (@c) {
    my %e;
    for my $k (4 .. @$c-1) {
        my $l = 9 + $c->[$k] - $c->[$k-1] +
            (9 + $c->[$k-1] - $c->[$k-2]) * 20   +
            (9 + $c->[$k-2] - $c->[$k-3]) * 20 * 20 + 
            (9 + $c->[$k-3] - $c->[$k-4]) * 20 * 20 * 20;
        %e{$l} and next;
        $e{$l} = 1;
        $f{$l} += $c->[$k];
        $f{$l} <= $sum and next;
        $sum = $f{$l}
    }
}

print "$sum\n";

sub mix { ($_[0] ^ $_[1]) % 16_777_216 }

sub next_secret {
    my $x = shift;
    $x = mix($x, $x*64);
    $x = mix($x, int($x/32));
    $x = mix($x, $x*2048);
    return $x
}

sub p {
    my $x = shift;
    my $e = $x % 10;
    my @p = ( $e );
    for(1..2_000) {
        $x = next_secret($x);
        $e = $x % 10;
        push(@p, $e)
    }
    push(@p, $x);
    return @p
}
