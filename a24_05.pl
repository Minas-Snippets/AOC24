#!/usr/bin/perl

my (%r, @u, $s, $t);

while(<>) {
    chomp;
    if(m/\|/) {
        my ($x, $y) = split /\|/;
        $r{$y}->{$x} = 1;
        next
    }
    m/,/  and push(@u,[ split /,/ ]);
}

U: for my $p (@u) {
    my @p = @$p;
    while(@p) {
        my $q = shift @p;
        for(@p) {
            if($r{$q}->{$_}) {
                @p = sort { $r{$a}->{$b} ? 1 : -1 } @$p;
                $t += $p[(@p-1)/2];
                next U
            }
        }
    }
    $s += $p->[(@$p-1)/2]
}

print "part 1: $s\npart 2: $t\n";
