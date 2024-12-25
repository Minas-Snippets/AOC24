#!/usr/bin/perl

my (@block,@locks,@keys);

while(<>) {
    chomp;
    m/^\s*$/ and next;
    push(@block,$_);
    @block == 7 and process_block(\@locks,\@keys,\@block);
}

my $sum = 0;

for my $lock (@locks) {
    for my $key (@keys) {
        $sum += fits($lock,$key)
    }
}

print $sum;

sub fits {
    my ($lock,$key) = @_;
    for (0 .. 4) {
        $lock->[$_] + $key->[$_] > 5 and return 0
    }
    return 1
}

sub process_block {
    my ($locks, $keys, $block) = @_;
    my $set;
    if($block->[0] eq '#####') {
        $set = $locks;
        shift(@$block)
    } else {
        $set = $keys;
        pop(@$block)
    }
    push(@$set, [ ( 0 ) x 5 ] );
    while(@$block) {
        my $line = shift @$block;
        for(0 .. 4) {
            $set->[-1]->[$_]++ if substr($line,$_,1) eq '#'
        }
    }
}
