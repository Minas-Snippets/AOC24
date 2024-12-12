#!/usr/bin/perl

# today we don't have much input data so,
# we just read the input numbers from the command line
                
my %r;
my %a = map { $_ => 1 } @ARGV;
my %b;
my $n = 75;
my $m = $n/5;

my $c = 0;
for my $i ( 1 .. $m ) {
    $c = $c ? 0 : 1;
    my ($h, $o) = $c ? (\%a, \%b) : (\%b, \%a);
    
    my @a = keys(%$h);
    for my $x (@a) {
        my $k = $h->{$x};
        my @y = $r{$x} ? @{$r{$x}} : g($x);
        $r{$x} = [ @y ] unless $r{$x};
        $o->{$_} += $k for @y
    }
    %$h = ( )
}

                
my  $sum =  0;
$sum += $_ for values %b;

print "$sum\n";


sub f {
    my $x = shift;
    return ( 1 ) unless $x;
    my $l = length($x);
    unless($l & 1) {
        my @frag = ( substr($x,0,$l/2), substr($x,-$l/2));
        $frag[$_] =~ s/^0*(.*)(.)$/$1$2/ for 0..1;
        return @frag
    }
    return ( $x * 2024 )
}

sub g {
    my @a = f($_[0]);
    my @b = map{ f($_) } @a;
    @a = map{ f($_) } @b;
    @b = map{ f($_) } @a;
    return ( map{ f($_) } @b )
}

