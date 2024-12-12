#!/usr/bin/perl

our @land;

while(<>) {
    chomp;
    push(@land, [ split // ]);  
}

our $n = @land;
our (%v,@r);
my  $r = 0;

for my $i (0..$n-1) {
    for my $j (0..$n-1) {
        next if $v{$i}->{$j};
        $v{$i}->{$j} = ++$r;
        push(@r,{ r => $r, f => [$i,$j], p => $land[$i]->[$j] });
        get_region($r[-1]);
    }
}

my $sum = 0;

my $f = 0;

$sum += get_perimeter($_) * @{$_->{f}}/2 for @r;

print "part 1: $sum\n";
$sum = 0;
$sum += $_->{e} * @{$_->{f}}/2 for @r;
print "part 2: $sum\n";

sub get_perimeter {
    my $r = shift;
    my $p = 0;
    my @f = @{$r->{f}};
    my (%e1 , %e2 , %e4, %e8);
    while(@f) {
        my ($i, $j) = (shift(@f), shift(@f));
        my $e = get_edges($i,$j,$r->{r});
        $p += bitcount($e);
        next unless $e;
        $e & 1 and push(@{$e1{$j}}, $i);
        $e & 4 and push(@{$e4{$j}}, $i);
        $e & 2 and push(@{$e2{$i}}, $j);
        $e & 8 and push(@{$e8{$i}}, $j);
    }
    my $q = 0;
    my $h = 1;
    for my $t (\%e1 , \%e2 , \%e4, \%e8) {
        while( my ($k,$v) = each %$t ) {
            my @v = sort{$a <=> $b} @$v;
            $q++;
            my $last = shift(@v);
            while(@v) {
                my $next = shift(@v);
                $q++ if $next - $last > 1;
                $last = $next;
            }
        }
        $h = 0;
    }
    $r->{e} = $q;
    return $p
}

sub get_region {
    my $r = shift;
    my @new = @{$r->{f}};
    while(@new) {
        my ($i,$j) = (shift(@new), shift(@new));
        my @n = neighbours($i,$j); 
        while(@n) {
            my ($x,$y) = (shift(@n), shift(@n));
            next if $v{$x}->{$y};
            next if $land[$x]->[$y] ne $r->{p};
            $v{$x}->{$y} = $r->{r};
            push(@{$r->{f}},$x,$y);
            push(@new, $x, $y)
        }
    }
}

sub neighbours {
    my ($i, $j) = @_;
    my @n;
    for( [ $i+1,$j ], [$i-1, $j ], [$i,$j+1], [$i, $j-1] ) {
        next if $_->[0] < 0 || $_->[1] < 0 || $_->[0] >= $n || $_->[1] >= $n;
        push @n, @$_
    }
    return @n
}

sub out_neighbours {
    my ($i, $j) = @_;
    my $e = 0;
    $e += 1 if $j == 0;
    $e += 4 if $j == $n - 1;
    $e += 2 if $i == 0;
    $e += 8 if $i == $n - 1;
    return $e
    
}

sub get_edges {
    my ($p, $q, $r) = @_;
    my @n = neighbours($p,$q);
    my $e = 0;
    while(@n) {
        my ($i, $j) = (shift(@n), shift(@n));
        next if $r == $v{$i}->{$j};
        $e += ($j == $q) ? ( $i < $p ? 2 : 8 ) : ( $j < $q ? 1 : 4 ); 
    }
    return $e + out_neighbours($p,$q)
}

sub bitcount { 
    my $c = 0;
    $c += 1 & ($_[0] >> $_) for 0 .. 3;
    return $c
}


