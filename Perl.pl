#!/usr/bin/perl
use strict;
use warnings;

my %vars;

print "Hesap Makinesi Yorumlayıcısına Hoşgeldiniz! (Çıkmak için 'exit' yazın)\n";

while (1) {
    print "> ";
    chomp(my $input = <STDIN>);
    last if $input eq 'exit';

    if ($input =~ /^\s*([a-z]\w*)\s*=\s*(.+)$/) {
        my ($var, $expr) = ($1, $2);
        $expr =~ s/\b([a-z]\w*)\b/(exists $vars{$1} ? $vars{$1} : 0)/ge;
        my $result = eval $expr;
        if ($@) {
            print "Hata: $@\n";
        } else {
            $vars{$var} = $result;
            print "$var tanımlandı: $result\n";
        }
    }
    else {
        $input =~ s/\b([a-z]\w*)\b/(exists $vars{$1} ? $vars{$1} : 0)/ge;
        my $result = eval $input;
        if ($@) {
            print "Hata: $@\n";
        } else {
            print "Sonuç: $result\n";
        }
    }
}
