#!perl
use strict;
use warnings;

use Encode;
use Pod::Usage;
use File::Spec;
use FindBin::libs;
use Getopt::Long qw(:config posix_default no_ignore_case bundling auto_help);

use Text::Md2Inao;

GetOptions(
  \my %options, qw/
  builder=s
/) or pod2usage(-2);

my $infile  = $ARGV[0]
    or pod2usage(-1);

open my $fh, '<:utf8', $infile or die $!;
my $text = do { local $/; <$fh> };
close $fh;

my $p = Text::Md2Inao->new({
    default_list           => 'disc',
    max_list_length        => 63,
    max_inline_list_length => 55,
});

# TOOD: load dymamically
if ($options{builder} eq 'den') {
    use Text::Md2Inao::Builder::Den;
    my $builder = Text::Md2Inao::Builder::Den->new;
    $p->builder($builder);
}

print encode_utf8 $p->parse($text);

__END__

=head1 NAME

md2inao.pl - markdown to inao converter

=head1 SYNOPSIS

    md2inao.pl your_markdown_text.md > inao_format.txt

=cut
