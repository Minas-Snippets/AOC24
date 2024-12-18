#!/usr/bin/perl

use strict;

our ($n, @map,%conns) = ( -1 );


while(<>) {
    chomp;
    next if m/^#+$/;
    $n++;
    s/^#(.+)#$/$1/;
    my @line = split //;
    push @map,[ map { m/#/ ? 0 : 1 } split // ];
}

set_bitmaps();
find_dead_ends();

our @n = find_nodes();

unshift(@n,$n,0);
push(@n,0,$n);

find_conns();

my @paths = ( [ $n, 0, 0, 0, { } ] );

my $min = $n * $n * 1_000;

while(@paths) {
    my $p = shift(@paths);
    my ($i, $j, $entry, $cost, $history ) = @$p;
    next if $history->{$i}->{$j};
    next if $cost >= $min;
    $history->{$i}->{$j} = 1;
    my $c = $conns{$i}->{$j};
    while(my ($exit, $next_node) = each(%$c)){
        my $knee = ($entry + $exit) % 3 ? 0 : 1_000;
        my ($p, $q, $next_entry, $toll) = @$next_node;
        my $total = $cost + $knee + $toll;
        if(is_end($p,$q)) {
            $min = $total if $total < $min;
            next
        }
        next if $total >= $min;
        push(@paths, [$p, $q, $next_entry, $total, $history])
    }
    @paths = sort{ $a->[3] <=> $b->[3] } @paths
}

print $min;

sub find_conns {
    for my $k (0 .. @n/2-2) {
        my ($i, $j) = ( $n[2*$k], $n[2*$k +1] );
        my @exits = doors($map[$i]->[$j]);
       
        for my $exit (@exits) {
            my $cost = is_start($i,$j) && $exit == 2 ? 1_000 : 0;
            $map[$i]->[$j] -= $exit;
            my @node = next_node($i,$j,$exit,$cost,$i,$j);
            @node and $conns{$i}->{$j}->{$exit} = [ @node ];
            $map[$i]->[$j] += $exit;
        }
    }
}

sub next_node {
    my ($i,$j, $d, $cost, $x, $y) = @_;

    $cost++;
    my $p = $d & 5  ? $i : ( $d == 2 ? $i-1 : $i+1 );
    my $q = $d & 10 ? $j : ( $d == 1 ? $j-1 : $j+1 );
    my $e = ($d & 5  ? 5 : 10) - $d;
    my $o = \$map[$p]->[$q];
    
    return ( ) if $p == $x && $q == $y;

    return ($p,$q,$e,$cost) if is_end($p,$q) || bitcount($map[$p]->[$q]) > 2;
    return ( ) if is_start($p,$p) || bitcount($map[$p]->[$q]) < 2;

    $cost += $map[$p]->[$q] % 3 ? 0 : 1_000;
    $map[$p]->[$q] -= $e;
    my @next = next_node($p,$q,$map[$p]->[$q],$cost,$x,$y);
    $map[$p]->[$q] += $e;
    
    return @next
}


sub bitcount { 
    my $c = 0;
    $c += 1 & ($_[0] >> $_) for 0 .. 3;
    return $c
}

sub doors {
    my @d;
    for( 1, 2 , 4, 8 ) {
        $_[0] & $_ and push(@d,$_)
    }
    return @d;
}

sub set_bitmaps {
    for my $i (0 .. $n){
        for (0..$n) {
            $map[$i]->[$_] or next;
            $map[$i]->[$_] = 0;
            $_ > 0  && $map[$i]->[$_-1] and $map[$i]->[$_] += 1;
            $i > 0  && $map[$i-1]->[$_] and $map[$i]->[$_] += 2;
            $_ < $n && $map[$i]->[$_+1] and $map[$i]->[$_] += 4;
            $i < $n && $map[$i+1]->[$_] and $map[$i]->[$_] += 8;
        }
    }
}

sub find_dead_ends {
    my @d;
    for my $i (0 .. $n){
        for (0..$n) {
            next if is_term($i,$_);
            next if $_ == 0 && $i == $n;
            next if bitcount($map[$i]->[$_]) != 1;
            push(@d, $i, $_)
        }
    }
    while(@d) {
        my ($i, $j) = ( shift(@d), shift(@d) );
        next if is_term($i,$j);
        my $x = $map[$i]->[$j];
        my $k = $x &  5 ? $i : ( $x == 2 ? $i-1 : $i+1);
        my $l = $x & 10 ? $j : ( $x == 1 ? $j-1 : $j+1);
        $map[$k]->[$l] -= ( $x & 5 ? 5 : 10 ) - $x;
        $map[$i]->[$j]  = 0;
        next if bitcount($map[$k]->[$l]) != 1;
        push(@d,$k,$l);
    }
}

sub find_nodes {
    my @d;
    for my $i (0 .. $n){
        for (0..$n) {
            next if is_term($i,$_) || bitcount($map[$i]->[$_]) < 3;
            push(@d, $i, $_)
        }
    }
    return @d
}

sub is_start { return $_[0] == $n && $_[1] == 0  ? 1 : 0 }

sub is_end   { return $_[0] == 0  && $_[1] == $n ? 1 : 0 }

sub is_term  { return is_start(@_) || is_end(@_)  ? 1 : 0 }
