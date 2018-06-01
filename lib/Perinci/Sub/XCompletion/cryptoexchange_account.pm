package Perinci::Sub::XCompletion::cryptoexchange_account;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::ger;

use Complete::Util qw(complete_array_elem);

our %SPEC;

$SPEC{gen_completion} = {
    v => 1.1,
};
sub gen_completion {
    require PERLANCAR::Module::List;

    my %fargs = @_;

    # XXX only show supported exchange (where corresponding
    # App::cryp::Exchange::* is found) or grab from config

    # XXX grab account from config

    sub {
        my %cargs = @_;
        my $word    = $cargs{word} // '';
        my $cmdline = $cargs{cmdline};
        my $r       = $cargs{r};

        return undef unless $cmdline;

        my %exchanges;

        # grep exchange and account names from config
        {
            # force reading config file
            $r->{read_config} = 1;

            my $res = $cmdline->parse_argv($r);
            for my $s (keys %{ $r->{_config_section_read_order} // {} }) {
                next unless $s =~ m!\Aexchange\s*/\s*(.+?)(?:\s*/\s*(.+))?\z!;
                $exchanges{$1} //= {default=>1};
                $exchanges{$1}{$2} = 1 if defined $2;
            }
        }

        # grep exchange from App::cryp::Exchange::* modules
        {
            my $mods = PERLANCAR::Module::List::list_modules(
                "App::cryp::Exchange::", {list_modules=>1});
            for my $k (keys %$mods) {
                $k =~ s/^App::cryp::Exchange:://;
                $k =~ s/_/-/g;
                $exchanges{$k} //= {default=>1};
            }
        }

        my @ary = map {
            my $xch = $_;
            map { "$xch/$_" } sort keys %{$exchanges{$xch}};
        } sort keys %exchanges;

        complete_array_elem(
            word => $word,
            array => \@ary,
        );
    };
}

1;
# ABSTRACT: Generate completion for cryptoexchange code/name/safename

=cut
