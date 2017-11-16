use strict;
use warnings;
package App::2base;
# ABSTRACT: Comand-line utility for converting bases
# VERSION
use base 'App::Cmd::Simple';
use utf8;
use charnames qw();
use open qw( :encoding(UTF-8) :std );
use Module::Load qw(load);
use Getopt::Long::Descriptive;

use utf8;
use Math::BaseCnv;

=pod

=encoding utf8

=head1 NAME

2base - Command-line utility for converting bases

=head1 SYNOPSIS

    $ 2base 16 16
    10

=head1 OPTIONS

=head2 version / v

Shows the current version number

    % highlight --version

=head2 help / h

Shows a brief help message

    % highlight --help

=cut

sub usage_desc { "2base %o <base> [number ...]" }

sub opt_spec {
    return (
        [ 'thousands|t'  => "Use ISO thousands prefixes instead of binary ones" ],
        [ 'delimiters|d' => "Use delimiters for bigger numbers"                 ],
        [ 'version|v'    => "show version number"                               ],
        [ 'help|h'       => "display a usage message"                           ],
    );
}

sub validate_args {
    my ($self, $opt, $args) = @_;

    if ($opt->{'help'} || !$args) {
        my ($opt, $usage) = describe_options(
            usage_desc(),
            $self->opt_spec(),
        );
        print $usage;
        print "\n";
        print "For more detailed help see 'perldoc 2base'\n";

        print "\n";
        exit;
    }
    elsif ($opt->{'version'}) {
        print $App::2base::VERSION, "\n";
        exit;
    }

    if (!@$args && !$opt->{'awesome'}) {
        $self->usage_error(
            "No arguments given!\n" .
            "What do you want me to do?\n"
        );
    }

    return;
}

use Data::Dumper;
sub execute {
    my ($self, $opt, $args) = @_;

    my $base = shift @$args;

    my %power_of = ( K => 1, M => 2, G => 3, T => 4 );
    my $suffix_base = $opt->{thousands} ? 1000 : 1024;

    my $readarg = @$args ? sub { shift @$args } : sub { <STDIN> };
    while (defined ($_ = $readarg->())) {
        chomp;
        s/[,_']//g;
        unless (/%/) {
            $_ .= s/^0b//  ? '%2'
                : s/^0x//  ? '%16'
                : s/^0o?// ? '%8'
                :            '%10'
        }

        s/(.*?)([KMGT])/$1*($suffix_base**$power_of{$2})/gie;
        s/(.*?)(?=%\d+)/$1/ge;

        $_ = length if s/%1$//;
        my $num = reverse cnv((split /%/) => $base);
           $num =~ s/(...)(?=.)/$1,/g  if $opt->{delimiters} && $base == 10;
           $num =~ s/(....)(?=.)/$1_/g if $opt->{delimiters} && $base =~ /^(2|8|16)$/;
        print scalar reverse($num), "\n";
    }

    return;
}

1;

__END__

=head1 GIT REPOSITORY

L<http://github.com/athreef/App-2base>

=head1 SEE ALSO

L<The Perl Home Page|http://www.perl.org/>

=head1 AUTHOR

Ahmad Fatoum C<< <athreef@cpan.org> >>, L<http://a3f.at>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2017 Ahmad Fatoum

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
