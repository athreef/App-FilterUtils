use strict;
use warnings;
package App::FilterUtils::filter_example_echo;
# ABSTRACT: Echo back input
# VERSION
use base 'App::Cmd::Simple';
use utf8;
use charnames qw();
use open qw( :encoding(UTF-8) :std );

use Getopt::Long::Descriptive;

use utf8;

=pod

=encoding utf8

=head1 NAME

filter_example_echo - echo back input

=head1 SYNOPSIS

    $ filter_example_echo Hello
    Hello

=head1 OPTIONS

=head2 version / v

Shows the current version number

    $ filter_example_echo --version

=head2 help / h

Shows a brief help message

    $ filter_example_echo --help

=cut

sub usage_desc { "filter_example_echo %o [-n] [word ...]" }

sub opt_spec {
    return (
        [ 'no-newline|n' => "No new-line at end"                                ],
        [ 'version|v'    => "show version number"                               ],
        [ 'help|h'       => "display a usage message"                           ],
    );
}

sub validate_args {
    my ($self, $opt, $args) = @_;

    if ($opt->{'help'}) {
        my ($opt, $usage) = describe_options(
            usage_desc(),
           #$self->usage_desc(),
            $self->opt_spec(),
        );
        print $usage;
        print "\n";
        print "For more detailed help see 'perldoc App::FilterUtils::filter_example_echo'\n";

        print "\n";
        exit;
    }
    elsif ($opt->{'version'}) {
        print $App::FilterUtils::filter_example_echo::VERSION, "\n";
        exit;
    }

    #if (!@$args && !$opt->{'no-newline'}) {
    #    $self->usage_error(
    #        "No arguments given!\n" .
    #        "What do you want me to do?\n"
    #    );
    #}

    return;
}

sub execute {
    my ($self, $opt, $args) = @_;

    my $readarg = @$args ? sub { shift @$args } : sub { <STDIN> };
    while (defined ($_ = $readarg->())) {
        chomp;
        print $_;
        print "\n" unless $opt->{'no-newline'};
    }

    return;
}

1;

__END__

=head1 GIT REPOSITORY

L<http://github.com/athreef/App-FilterUtils>

=head1 SEE ALSO

L<The Perl Home Page|http://www.perl.org/>

=head1 AUTHOR

Ahmad Fatoum C<< <athreef@cpan.org> >>, L<http://a3f.at>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2017 Ahmad Fatoum

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
