#!/usr/bin/perl

my ($n,$x,$y,@map,@moves) = (-1);
my %direction = ( '<' => 1, '^' => 2, '>' => 4, 'v' => 8 );

while(<>) {
    chomp;
    my @l = split //;
    if(m/#/) {
        $n++;
        m/@/ and ($y, $x) = ($n, $-[0]); 
        push @map, [ map{ m/#/ ? 2 : ( m/O/ ? 1 : 0 ) } @l ];
    }
    m/[<>^v]/ and push @moves, map{ $direction{$_} } @l
}

for my $move (@moves) {
    my @fields = ( $move & 5 ) ? 
        ( map{ $map[$y]->[$_] } (($move == 1 ? 0 : $x+1) .. ($move == 1 ? $x-1 : $n ))  ) :
        ( map{ $map[$_]->[$x] } (($move == 2 ? 0 : $y+1) .. ($move == 2 ? $y-1 : $n )) ); 
    my $z =  $move & 5 ? \$x   : \$y;
    $move & 3 and @fields = reverse(@fields);
    $fields[0] == 2 and next;
    unless($fields[0]) {
        robot_move($move, $z);
        next
    }
    my ($block, $void) = (0, 0);
    for my $i (1 .. @fields-1) {
        !$block && $fields[$i] == 2 and $block = $i;
        !$void  && $fields[$i] == 0 and $void  = $i;
    }
    next if !$void || $void > $block;
    
    $fields[$_] = 1 for 1 .. $void;
    $fields[0]  = 0;

    $move & 3 and @fields = reverse(@fields);
    for my $i (0 .. @fields-1) {
        my $start = $move & 3 ? 0 : ( $move == 4 ? $x+1 : $y+1 );
        my $p = $move & 5  ? $start + $i : $x;
        my $q = $move & 10 ? $start + $i : $y;
        $map[$q]->[$p] = $fields[$i]
    }
    robot_move($move, $z);
}

my $sum = 0;
for my $i (0 .. $n) {
    $sum += ($map[$i]->[$_] == 1 ? (100*$i + $_) : 0) for 0 .. $n;
}

print $sum."\n";

sub robot_move {
    my ($m, $z) = @_;
    $$z   = ($m & 12) ? ($$z + 1) : ($$z - 1);
}
