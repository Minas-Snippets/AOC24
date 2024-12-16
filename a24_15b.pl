#!/usr/bin/perl

my ($n,$x,$y,@map) = (-1);
my %direction = ( '<' => 1, '^' => 2, '>' => 4, 'v' => 8 );

our $boxes = 0;
our @moves;
our $d = 0;

while(<>) {
    chomp;
    my @l = split //;
    if(m/#/) {
        $n++;
        m/@/ and ($y, $x) = ($n, 2*$-[0]);
        push @map,[];
        my $line = $map[$n];
        for(@l) {
            if(m/#/) {
                push(@$line, -1,-1);
                next;
            }
            if(m/O/) {
                $boxes++;
                push(@$line, 2*$boxes-1,2*$boxes);
                next;
            }
            push(@$line,0,0)
        }
    }
    m/[<>^v]/ and push @moves, map{ $direction{$_} } @l
}


while (@moves) {    
    my $move = shift(@moves);
    
    my @fields = ( $move & 5 ) ? 
        ( map{ $map[$y]->[$_] } (($move == 1 ? 0 : $x+1) .. ($move == 1 ? $x-1 : 2*$n ))  ) :
        ( map{ $map[$_]->[$x] } (($move == 2 ? 0 : $y+1) .. ($move == 2 ? $y-1 : $n )) ); 
    my $z =  $move & 5 ? \$x   : \$y;
    $move & 3 and @fields = reverse(@fields);

    next if $fields[0] < 0;

    if ($fields[0] == 0) {
        robot_move($move, $z);
        next
    }
    if($move & 5) {
        my ($block, $void) = (0, 0);
        for my $i (1 .. @fields-1) {
            !$block && $fields[$i] == -1 and $block = $i;
            !$void  && $fields[$i] ==  0 and $void  = $i;
        }
        next unless $void && $void < $block;
        splice(@fields,$void,1);
        unshift(@fields,0);

        $move == 1 and @fields = reverse(@fields);
        my $start = $move == 1 ? 0 : $x+1;
        splice(@{$map[$y]},$start,scalar(@fields),@fields);
        robot_move($move, $z);
        next
    } 

    my $row  = $move == 2 ? $y-1 : $y+1;
    my $next = $map[$row]->[$x];
    next if $next < 0;
    if($next == 0) {
        robot_move($move, $z);
        next
    }
    my @boxes = $next % 2 ? ( $x, $x + 1) : ( $x - 1, $x );
    next unless boxes_movable(\@map, $move, $row, @boxes);
    move_boxes(\@map, $move, $row, @boxes);
    robot_move($move, $z)
}

my $sum = 0;
for my $i (1 .. $n-1) {
    for (2 .. 2*$n - 2) {
        $map[$i]->[$_] > 0 or next;
        $map[$i]->[$_] % 2 or next;
        $sum += $i * 100 + $_
    }
}

print $sum."\n";

sub boxes_movable {
    my ($map, $move, $row, @boxes) = @_;
    my $next_row = $move == 2 ? $row-1 : $row+1;
    my @next_boxes;
    my $moved = 1;
    for(0 .. @boxes/2-1) {
        my $left  = $boxes[2*$_];
        my $right = $left + 1;
        my ($p,$q) = ($map->[$next_row]->[$left], $map->[$next_row]->[$right]);
        $p < 0 || $q < 0 and return 0;
        $p || $q or next;
        if($p) {
            if($p % 2) {
                push(@next_boxes, $left, $right);
                next
            }
            push(@next_boxes, $left-1, $left);
        }
        $q and push(@next_boxes, $right, $right + 1);    }
    if(@next_boxes) {
        clean_array(\@next_boxes);
        $moved = boxes_movable($map, $move, $next_row, @next_boxes)
    }
    return $moved
}

sub move_boxes {
    my ($map, $move, $row, @boxes) = @_;
    my $next_row = $move == 2 ? $row-1 : $row+1;
    my @next_boxes;
    for(0 .. @boxes/2-1) {
        my $left  = $boxes[2*$_];
        my $right = $left + 1;
        my ($p,$q) = ($map->[$next_row]->[$left], $map->[$next_row]->[$right]);
        next unless $p || $q;
        if($p) {
            if($p % 2) {
                push(@next_boxes, $left, $right);
                next
            }
            push(@next_boxes, $left - 1, $left);
        }
        $q or next;
        push(@next_boxes, $right, $right + 1)
    }
    if(@next_boxes) {
        clean_array(\@next_boxes);
        move_boxes($map, $move, $next_row, @next_boxes);
    }
    for(@boxes) {
        $map->[$next_row]->[$_] = $map->[$row]->[$_];
        $map->[$row]->[$_] = 0
    }
}

sub clean_array {

# Failing to think of using this function actually cost me hours!

    my $l = shift;
    my %l = map{ $_ => 1 } @$l;
    @$l = sort{ $a <=> $b } keys %l 
}

sub robot_move {
    my ($m, $z) = @_;
    $$z   = ($m & 12) ? ($$z + 1) : ($$z - 1);
}
