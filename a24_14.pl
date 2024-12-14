#!/usr/bin/perl

# Call this program with command line parameters in this order:
# InputFileName NumberOfColumns NumberOfRows NumberOfIterations

our ($f, $m, $n, $k) = @ARGV;

my @q = (0,0,0,0);
my @robots;
my @velocities;

open(my $infile,'<',$f);
while(<$infile>){
    m/p=(\d+),(\d+)\s+v=(-?\d+),(-?\d+)/ or next;
    my ($x,$y,$v,$w) = ($1,$2,$3,$4);
    push(@robots, $x, $y);
    push(@velocities, $v, $w);
}
close($infile);

my @orig = @robots;

step(\@robots,\@velocities) for 1..$k;

for (0 .. @robots/2 -1) {
    my ($x, $y) = ( $robots[2*$_], $robots[2*$_+1] );
    ($x == ($m-1)/2) || ($y == ($n-1)/2) and next;
    my $q = 0;
    $x > ($m-1)/2 and $q++;
    $y > ($n-1)/2 and $q += 2;
    $q[$q]++;    
}

my $prod = $q[0];
$prod *= $q[$_] for 1..3;
print "part 1: $prod\n";

@robots = @orig;
my ($p, $period) = (0,0);
do {
    step(\@robots,\@velocities);
    $p = a_eq(\@orig, \@robots);
    $period++;
} until($p);

@robots = @orig;

my $html_file_number = 1;
my $html_file_name   = 'a24_14_01.html';
my $html_top         = qq(<!DOCTYPE "HTML">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<html>
<head>
    <title>a24_14</title>
</head>
<body>);

open(my $html, '>',$html_file_name);
my ($w, $h) = (3*$m, 3*$n);
print $html $html_top;


for my $step (1 .. $period) {
    unless($step % 300) {
        print $html qq(
</body>
</html>);
        close($html);
        $html_file_number++;
        if($html_file_number < 10) {
            $html_file_name   =~ s/(a24_14_0)\d/$1$html_file_number/
        } else {
            $html_file_name   =~ s/(a24_14_)\d+/$1$html_file_number/;
        }
        open($html, '>',$html_file_name);
        print $html $html_top;
    }

    step(\@robots,\@velocities); 
    
    print $html qq(
    <p>
        Step $step<br>
        <svg width="$w" height="$h" viewbox="0 0 $m $n">);
    for(0 .. @robots/2-1) {
        my ($x, $y) = ( $robots[2*$_], $robots[2*$_+1] );
        print $html qq(
            <rect x="$x" y="$y" width="1" height="1" fill="green"/>);
    }
    print $html qq(
        </svg>
    </p>)
}
print $html qq(
</body>
</html>);

close($html);

sub step {
    my ($r, $v) = @_;
    for (0 .. @$r/2 -1) {
        my ($x, $y) = ( 
            ($r->[2*$_]   + $v->[2*$_]  ) % $m, 
            ($r->[2*$_+1] + $v->[2*$_+1]) % $n );
        $r->[2*$_]   = $x;
        $r->[2*$_+1] = $y
    }
}

sub a_eq {
    my ($a,$b) = @_;
    for(0 .. @$a-1) {
        $a->[$_] != $b->[$_] and return 0
    }
    return 1
}
