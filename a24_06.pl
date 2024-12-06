#!/usr/bin/perl

my ($x, $y, $p, $q) = (0, -1);

our ($n, %o) = (-1);

while(<>) {
    $n++;
    if(s/^([^\^]*)\^/$1X/) {
        ($p,$q) = (length($1),$n);
        $f{$p}->{$q} = 1
    }
    while(s/^([^#]*)#/$1X/) {
        $o{length($1)}->{$n} = 1
    }
}

print "part 1: ".leaves($p, $q)."\n";

my $sum = 0;

for my $i (0..$n) {
    for my $j (0..$n) {
        next if $o{$i}->{$j};
        $o{$i}->{$j} = 1;
        $sum++ if(leaves($p,$q) < 0);
        delete($o{$i}->{$j})
    }
}

print "part 2: $sum\n";

sub out {
    return $_[0] < 0 || $_[0] > $n || $_[1] < 0 || $_[1] > $n ? 1 : 0
}

sub leaves {
    my ($p, $q) = @_;
    my ($x, $y) = (0, -1);
    my %f = ( );
    $f{$p}->{$q} = 4;
    if($o{$p}->{$q-1}) {
        $f{$p}->{$q} = 2;
        ($x, $y) = (1,0);
    }
    my $out;
    do {
        while($o{$p+$x}->{$q+$y} && !out($p+$x,$q+$y)) {
            ($x, $y) = (-$y, $x)
        }
        my $b = $x ? ($x < 0 ? 1 : 2 ) : ($y < 0 ? 4 : 8);
        $p += $x;
        $q += $y;
        $out = out($p,$q);
        if(!$out) {
            if($f{$p}->{$q}) {
                return -1 if $b & $f{$p}->{$q};
                $f{$p}->{$q} = $f{$p}->{$q} | $b
            } else {
                $f{$p}->{$q} = $b
            }
        }
    } until($out);
    my $sum = 0;
    while(my ($k, $v) = each(%f)) {
        $sum += keys(%$v)
    }
    return $sum
}
