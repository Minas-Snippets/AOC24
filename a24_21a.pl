#!/usr/bin/perl

our @numeric     = ( 7, 8, 9, 4, 5, 6 , 1, 2, 3, 'X', 0, 'A' );
our %num_pos     = map{ $numeric[$_] => $_ } 0 .. $#numeric;
our @directional = ( -1, 2, 0, 1, 8, 4 ); # SPACE UP ACTIVATE LEFT DOWN RIGHT
our %dir_pos     = map{ $directional[$_] => $_ } 0 .. $#directional;

our %num_moves;
our %dir_moves;

get_num_moves();
get_dir_moves();



my $test = '029A';
my $sum = 0;
qw ( 029A 980A 179A 456A 379A );

$sum += complexity($_) for qw ( 805A
983A
149A
413A
582A );

print "$sum\n";


sub complexity {
    my $test = shift;

    my $num = $test;
    $num =~ s/\D//g;
    $num =~ s/^0*//g;
    return $num * get_moves($test);
}

sub get_moves {
    my $s = shift;
    my @s1 = num2dir($s);
    my @s2;
    for my $n (1..2) {
        push(@s2, dir2dir($_)) for @s1;
        @s1 = @s2;
        @s2 = ( );
    }
    my $l = length($s1[0]);
    for(@s1) {
        my $m = length($_);
        $l = $m if $m < $l
    }
    return $l
}

sub num2dir {
    my $s = shift;
    my @n = split(//, $s);
    my $last = 'A';
    my @output;
    for my $q (0 .. $#n) {
        my $next = $n[$q];
        my $o = $num_moves{$last}->{$next};
        unless(@output) {
            push(@output, @$o)
        } else {
            my $k = @output - 1;
            for my $i (0 .. $k) {
                if(@$o > 1) {
                    push(@output, $output[$i].$o->[1]) if @$o > 1;
                }
                $output[$i] .= $o->[0];
            }
        }
        $last = $next
    }
     return @output
}

sub dir2dir {
    my $s = shift;
    my @n = split(//, $s);
    my $last = '0';
    my @output;
    for my $q (0 .. $#n) {
        my $next = $n[$q];
        my $o = $dir_moves{$last}->{$next};
        unless(@output) {
            push(@output, @$o)
        } else {
            my $k = @output - 1;
            for my $i (0 .. $k) {
                if(@$o > 1) {
                    push(@output, $output[$i].$o->[1])
                }
                $output[$i] .= $o->[0];
            }
        }
        $last = $next
    }
    return @output
}

sub get_num_moves {
    for my $from (@numeric) {
        for my $to (@numeric) {
            my $from_pos = $num_pos{$from};
            my $to_pos   = $num_pos{$to};
            my $from_x   = $num_pos{$from} % 3;
            my $from_y   = int($num_pos{$from}/3);
            my $to_x     = $num_pos{$to} % 3;
            my $to_y     = int($num_pos{$to}/3);
            my $dx       = $to_x - $from_x;
            my $dy       = $to_y - $from_y;

            my $s1 =
                ($dx > 0 ? '4' x  $dx : '' ) .
                ($dx < 0 ? '1' x -$dx : '' ) .
                ($dy < 0 ? '2' x -$dy : '' ) .
                ($dy > 0 ? '8' x  $dy : '' ) . '0';
            my $s2 =
                ($dy < 0 ? '2' x -$dy : '' ) .
                ($dy > 0 ? '8' x  $dy : '' ) .
                ($dx > 0 ? '4' x  $dx : '' ) .
                ($dx < 0 ? '1' x -$dx : '' ) . '0';
            my @s;
            if($from_y == 3 && $to_x == 0) {
                @s = ( $s2 )
            } elsif($from_x == 0 && $to_y == 3 ) {
                @s = ( $s1 )
            } else {
                @s = $s1 ne $s2 ? ($s1, $s2) : ($s1)
            }
            $num_moves{$from}->{$to} = [ @s ]
        }
    }
}

sub get_dir_moves {
    for my $from (@directional) {
        next if $from < 0;
        for my $to (@directional) {
            next if $to < 0;
            my $from_pos = $dir_pos{$from};
            my $to_pos   = $dir_pos{$to};
            my $from_x   = $dir_pos{$from} % 3;
            my $from_y   = int($dir_pos{$from}/3);
            my $to_x     = $dir_pos{$to} % 3;
            my $to_y     = int($dir_pos{$to}/3);
            my $dx       = $to_x - $from_x;
            my $dy       = $to_y - $from_y;

            my $s1 =
                ($dx > 0 ? '4' x  $dx : '' ) .
                ($dx < 0 ? '1' x -$dx : '' ) .
                ($dy > 0 ? '8' x  $dy : '' ) .
                ($dy < 0 ? '2' x -$dy : '' ) . '0';
            my $s2 =
                ($dy > 0 ? '8' x  $dy : '' ) .
                ($dy < 0 ? '2' x -$dy : '' ) .
                ($dx > 0 ? '4' x  $dx : '' ) .
                ($dx < 0 ? '1' x -$dx : '' ) . '0';
            my @s;
            if($from_y == 0 && $to_x == 0) {
                @s = ( $s2 )
            } elsif($from_x == 0 && $to_y == 0 ) {
                @s = ( $s1 )
            } else {
                @s = $s1 ne $s2 ? ($s1, $s2) : ( $s1 )
            }


            $dir_moves{$from}->{$to} = [ @s ];
        }
    }
}

sub conv {
    my $output = shift;
    $output =~ s/2/^/g;
    $output =~ s/0/A/g;
    $output =~ s/1/</g;
    $output =~ s/8/v/g;
    $output =~ s/4/>/g;
    return $output
}
