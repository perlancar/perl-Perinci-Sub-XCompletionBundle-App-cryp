package Perinci::Sub::XCompletion::cryptoexchange_account;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Complete::Util qw(complete_array_elem);

our %SPEC;

$SPEC{gen_completion} = {
    v => 1.1,
};
sub gen_completion {
    require CryptoExchange::Catalog;

    my %fargs = @_;

    my $cat = CryptoExchange::Catalog->new;

    # XXX only show supported exchange (where corresponding
    # App::cryp::Exchange::* is found) or grab from config

    # XXX grab account from config

    sub {
        my %cargs = @_;
        complete_array_elem(
            %cargs,
            array=>[grep {defined} map {($_->{code}, $_->{name}, $_->{safename})} $cat->all_data]);
    };
}

1;
# ABSTRACT: Generate completion for cryptoexchange code/name/safename

=cut
