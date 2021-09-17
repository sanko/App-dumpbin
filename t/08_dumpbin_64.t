use strict;
use Test::More 0.98;
use lib '../lib';
use Path::Tiny;
#
my $libpath
    = Path::Tiny->new(__FILE__)->absolute->parent->child( 'bin', 'hello-world-x64.dll' )->absolute;
my $dumpbin = $^X . ' '
    . Path::Tiny->new(__FILE__)->absolute->parent->parent->child( 'script', 'dumpbin' )->absolute;

# Cribbed from FFI::ExtractSymbols::Windows v0.05
my @symbols;
foreach my $line (`$dumpbin /exports $libpath`) {

    # we do not differentiate between code and data
    # with dumpbin extracts
    if ( $line =~ /[0-9]+\s+[0-9]+\s+[0-9a-fA-F]+\s+([^\s]*)\s*$/ ) {
        push @symbols, $1;
    }
}
is_deeply [qw[DllMain MessageBoxThread]], [ sort @symbols ],
    'exports found: DllMain, MessageBoxThread';
done_testing;
