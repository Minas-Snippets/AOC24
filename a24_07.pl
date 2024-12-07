#!/usr/bin/perl

my @e;

while(<>) {
    chomp;
    push @e, [ split ];
    $e[-1]->[0] =~ s/://
}

my ($sum1,$sum2) = (0, 0);
for(@e) {
    $sum1 += solves1(@$_);
    $sum2 += solves2(@$_);
}

print "$sum1 $sum2\n";

sub solves1 {
    my $e = shift;
    if(@_ == 2) {
        return $e if $_[0] + $_[1] == $e || $_[0] * $_[1] == $e;
        return 0
    }
    my $f = pop;
    my $g = $e/$f;
    return $g != int($g) ? (solves1($e-$f, @_) ? $e : 0) : (solves1($e-$f, @_) ? $e : (solves1($g, @_) ? $e : 0))
}

sub solves2 {
    my $e = shift;
    if(@_ == 2) {
        return $e if $_[0] + $_[1] == $e || $_[0] * $_[1] == $e || $_[0] . $_[1] eq $e;
        return 0
    }
    my $f = pop;
    return $e if length($f) < length($e) && (substr($e,-length($f)) eq $f) && solves2(substr($e,0,length($e)-length($f)), @_);
    my $g = $e/$f;
    return $g != int($g) ? (solves2($e-$f, @_) ? $e : 0) : (solves2($e-$f, @_) ? $e : (solves2($g, @_) ? $e : 0))
}
