#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use utf8;
use open ':std', ':encoding(UTF-8)';
use Unicode::Normalize;

my $cgi = CGI->new;
$cgi->charset('UTF-8');
print $cgi->header(-type => 'text/html', -charset => 'UTF-8');

print <<HTML;
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="style.css">
    <title>Página de Búsqueda - Universidades licenciadas</title>
  </head>
  <body>
    <div class="site-wrapper">
      <div class="mytitle">
        <b>Resultados de la búsqueda</b>
      </div>
      <div class="content answer">
HTML

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
