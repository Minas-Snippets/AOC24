#!/usr/bin/perl

my $d;
$d .= $_ while <>;

my ($pos, $id, $n, @d, @e, @f) = (0, 0, substr($d,0,1));

while($d =~ s/^(.)//) {
    if($id % 2) {
        push( @d, ( 0 ) x $1 );
        push( @e, $pos,   $1 );
    } else {
        push(    @d, ( $id/2 + 1 ) x $1 );
        unshift( @f,   $id/2, $pos,  $1 ); 
    }
    $pos += $1;
    $id++
}

my $e = @d - 1;
while($e > $n) {
    $d[$e] or  $e-- and next; 
    $d[$n] and $n++ and next;
    ($d[$n], $d[$e]) = ($d[$e], 0);
    $n++;
    $e++
}

my $sum = 0;

$sum += $_*($d[$_] ? $d[$_] - 1 : 0) for 0 .. @d-1;

print "part 1: $sum\n";

$sum = 0;

my $f = @f/3;
F: for my $f (0 .. @f/3 - 1) {
    for my $e (0 .. @e/2 - 1) {
        next if $e[2*$e + 1] < $f[3*$f + 2];
        last if $e[2*$e] > $f[3*$f + 1];
        $f[3*$f+1]    = $e[2*$e];
        $e[2*$e]     += $f[3*$f+2];
        $e[2*$e + 1] -= $f[3*$f+2];
        $sum += check(\@f,$f);
        next F
   }
   $sum += check(\@f,$f)
}

print "part 2: $sum\n";

sub check {
    my ($a, $i) = @_;
    $i *= 3;
    return $a->[$i] * $a->[$i+2] * ($a->[$i+1] + ($a->[$i+2]-1)/2)
}

