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
 
my $eleccion = $cgi->param('eleccion');
my $input = $cgi->param('input') || "";
$input = normalize_text($input);

print "<p><strong>Palabra clave ingresada: $input</strong></p>\n";

my @columnas = ('name', 'management_type', 'status', 'start_date', 'end_date', 
               'period', 'department', 'province', 'district');
my $index;
for (my $i = 0; $i <= $#columnas; $i++) {
    if ($columnas[$i] eq $eleccion) {
        $index = $i;
        last;
    }
}
$index++;
open(my $in, "<:encoding(UTF-8)", "./data.csv") or die "<h2>Error al abrir el archivo</h2>";

print <<BLOCK;
  <table>
    <tr>
      <th>NOMBRE</th>
      <th>TIPO GESTIÓN</th>
      <th>ESTADO LICENCIAMIENTO</th>
      <th>PERIODO LICENCIAMIENTO</th>
      <th>DEPARTAMENTO / PROVINCIA / DISTRITO</th>
    </tr>
BLOCK

sub normalize_text {
    my $text = shift;
    utf8::decode($text);
    $text = NFD($text);
    $text =~ s/\pM//g;
    return NFC($text);
}
