#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use Text::CSV;

my $cgi = CGI->new;
print $cgi->header('text/html; charset=UTF-8');


my $data = 'DataUNI.csv';
open(my $fh, '<', $data) or die "No se pudo abrir el archivo '$data' $!";

my $csv = Text::CSV->new({ binary => 1, sep_char => ',' });
my @columnas = @{ $csv->getline($fh) };

my $columna = $cgi->Param('columna');
my $termino = $cgi->Param('termino');
my $index;

for (my $i = 0; $i < @columnas; $i++){
    if($columnas[$i] eq $columna){
        $index = $i;
    }
}

while (my @fila = $csv->getline($fh)){
    if ($fila[$index]=~/\Q$termino\E/i){
        print "<tr>";
        print "<td>$_</td>" for @fila;
        print "</tr>";
    }
}