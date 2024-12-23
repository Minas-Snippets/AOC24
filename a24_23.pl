#!/usr/bin/perl

my %conn;

while(<>) {
    if(m/(\w\w)-(\w\w)/) {
        $conn{$1}->{$2} = 1;
        $conn{$2}->{$1} = 1
    }
}

my %circles;

my @c = sort (keys %conn);

for my $c1 (@c) {
    for my $c2 (@c) {
        next unless $c2 gt $c1;
        next unless $conn{$c1}->{$c2};
        for my $c3 (@c) {
            next unless $c3 gt $c2;
            next unless $conn{$c2}->{$c3};
            next unless $conn{$c1}->{$c3};
            $circles{$c1.$c2.$c3} = 1
        }
    }
}

my $sum = 0;
map{ $sum += m/^t/ || m/^..t/ || m/t.$/ ? 1 : 0 } keys %circles;

print "part 1: $sum\n";

my ($max, @m) = 0;

for my $c (@c) {
    my @d = keys %{$conn{$c}};
    my @a = ( $c );
    for my $d (@d) {
        my $a = 1;
        for (@a) {
            next if $conn{$_}->{$d};
            $a = 0;
            last
        }
        $a and push(@a, $d)
    }
    next unless @a > $m;
    $m = @a;
    @m = sort @a;
}

print "part 2: ".(join(',', @m))."\n"
