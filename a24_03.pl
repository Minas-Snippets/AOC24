#!/usr/bin/perl

my $t;

$t .= $_ while <>;

my $s = $t;

# part 1

print f($t);

# part 2

my @q = split /don't\(\)/,$s;

my $p = f(shift(@q));

for (@q) {
    my @a = split /do\(\)/, $_, 2;
    $p += f( $a[1] )
}

print "\n$p\n";

sub f {
    my $n;
    while($_[0] =~ s/mul\((\d+),(\d+)\)//) { $n += $1 * $2 }
    return $n
}
