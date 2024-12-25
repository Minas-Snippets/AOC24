#!/usr/bin/perl

our $dim = 71;

our @field;
push(@field, [ ( 0 ) x $dim ]) for 1 .. $dim;

my $limit = 1024;

our @later;

while(<>) {
    $limit--;
    chomp;
    my ($x,$y) = split /,/;
    if($limit >= 0) {
        $field[$x]->[$y] = -1;
    } else {
        push(@later,$x,$y);
    }
}
$field[0]->[0] = 1;

print "part 1: ".(length_exit() - 1)."\n";
reset_field();

my ($upper, $lower) = (@later/2,1);

while($upper > $lower) {
    my $mid = int(($upper+$lower)/2);
    reset_field();
    drop_blocks($mid,\@later);
    my $r = length_exit();
    unless($r) {
        $upper = $mid;
        $lower = $mid if $mid - 1 == $lower
    } else {
        $lower = $mid + 1 == $upper ? $upper : $mid
    }
}
$upper--;
print "part 2: ".$later[2*$upper].",".$later[2*$upper+1]."\n";


sub drop_blocks {
    my ($n, $b) = @_;
    for my $i (0..$n-1) {
        my ($x,$y) = ($b->[2*$i],$b->[2*$i+1]);
        next if $field[$x]->[$y];
        $field[$x]->[$y] = -2
    }
}

sub reset_field {
    for my $i (0..$dim-1) {
        for (0..$dim-1) {
            next if $field[$i]->[$_] == -1;
            $field[$i]->[$_] = 0
        }
    }
    $field[0]->[0] = 1;
}

sub length_exit {
    my $update;
    do {
        $update = 0;
        for my $x (0 .. $dim-1) {
            for my $y (0 .. $dim-1) {
                next if $field[$x]->[$y] < 0;
                my $v = neighbours_min($x,$y);
                defined($v) or next;
                next if $field[$x]->[$y] && $field[$x]->[$y] <= $v + 1;
                $field[$x]->[$y] = $v + 1;
                $update++
            }
        }
    } while($update);

    return $field[$dim-1]->[$dim-1];
}

sub neighbours_min {
    my ($x, $y) = @_;
    my @v;
    for(neighbours($x,$y)) {
        my ($i,$j) = @$_;
        next if $field[$i]->[$j] <= 0;
        push(@v,$field[$i]->[$j])
    }
    my $m = min(@v);
    return $m
}

sub neighbours {
    my ($x, $y) = @_;
    my @n;
    $x > 0 and push(@n,[$x-1,$y]);
    $y > 0 and push(@n,[$x,$y-1]);
    $x < $dim-1 and push(@n,[$x+1,$y]);
    $y < $dim-1 and push(@n,[$x,$y+1]);
    return @n
}

sub min {
    return undef unless @_;
    my $min = $_[0];
    for(1 .. @_-1) {
        next if $_[$_] >= $min;
        $min = $_[$_]
    }
    return $min
}
