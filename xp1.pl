#!/usr/bin/perl -w

=head1 		Copyright SQL*TECHNOLOGY 2016

=head1 NOMBRE

xp1.pl - 

=head1 SINOPSIS

   xp1.pl [switches]
      --help         Obtener ayuda
      --debug        Mostrar mensajes de debug (STDERR)
      --trace        Guardar mensajes de debug en xp1.pl.trc
      --sqltech=dir  Directorio de herramientas (SQLTECHHOME)

=head1 DESCRIPCION


=head1 PARAMETROS


=head1 OBSERVACIONES

=head1 VARIABLES

=head1 PROGRAMAS ASOCIADOS

=head1 RCS

 	$Name$
	$Source$
 	$Id$

=cut

use utf8;
use strict;
use warnings;
use English;

use Data::Dumper;
use Getopt::Long ();

use YAML::Syck;
# use YAML;
#use YAML::Tiny;

sub help () {
	my ($pack, $file, $line)=caller();
	system('perldoc -t '.$file);
	exit 1;
}

my ($program)=$0; $program=~s/^.*\/([^\/]+)$/$1/;
	
#
# Recibir parametros
#

my $optctl = {};

Getopt::Long::GetOptions($optctl,
	 '--help'
	,'--debug'
	,'--trace'
	,'--sqltech=s'
	) || help();


if ( defined $optctl->{'help'} ) {
    help();
}

if ( defined $optctl->{'sqltech'} ) {
    $ENV{'SQLTECHHOME'}=$optctl->{'sqltech'};
}

die 'Environment Variable SQLTECHHOME is undefined'
	unless defined $ENV{'SQLTECHHOME'} ;

require $ENV{'SQLTECHHOME'}.'/product/sqltlib/lib_init.pl';

#
# Debug
#
{
my $sDbgCurrentFile='';

$::debug=sub { 1; };
if ( $optctl->{'debug'} ) 
{
	$::debug=sub { my ( $fmt )=shift; printf(STDERR "DBG/${program}: ".$fmt."\n",@_); 1; };
	&{$::debug}("Debug activado");
	$::debugf=1;
}

$optctl->{'trace'} = 1
	if (!defined($optctl->{'debug'}));
if ( $optctl->{'trace'} ) 
{
   # open TRC,  ">", "${program}.trc";
   open TRC,  ">:utf8", "${program}.trc";
	select(TRC); $OUTPUT_AUTOFLUSH=1; select(STDOUT);
	$::debug=sub {
			my ( $fmt )=shift;
			my ($package, $filename, $line) = caller;
			if ("$package:$filename" ne $sDbgCurrentFile)
			{
				print TRC sprintf("En %s:%s\n",$package,$filename);
				$sDbgCurrentFile="$package:$filename";
			}
			print TRC sprintf("[$line]: $fmt\n",@_);
			1;
		};
	&{$::debug}("Debug activado");
	$::debugf=1;
}
}


#
# Init
#

$|=1; # $OUTPUT_AUTOFLUSH=1

my ($rc);

#
# Params
#


#
# Init
#
sub LoadYaml($);
sub ProjReport($);
sub TextOutline($$);

my $sActivFile='Activ01.yaml';
&{$::debug}("sActivFile:[%s]", $sActivFile);


#
# Body
#

my $bTest='';
if ($bTest) {
my $rData= {
	'name' => 'HabCOST'
	,'desc' => 'Habilitación COST'
	,'responsable' => '&US API-UX'
	,'overview' => [
		 { 'id' => 'Customizing_and_Development', 'child' => [
			'Laboratorio_de_COST'
			]}
		,{ 'id' => 'Configurar_listener_en_modalidad_COST', 'child' => [
      	'Eval_impacto_práctico'
			,{ 'id' => 'Paso_a_Prod', 'child' => [
      	    'Coordinar_cambio_de_configuración'
      	   ,'Ejecutar_cambio_de_config'
      	   ,'Soporte_post-paso_prod'
      	   ]}
      	]}
		,'Documentación'
	]
	,'activities' => {
		'Laboratorio_de_COST' => {
			'responsable' => '*&US'
			,'resource' => { 'type' => 'DBA-Senior', 'hours' => 6 }
			}
		,'Eval_impacto_práctico' => {
			'responsable' => '*&US'
			,'resource' => { 'type' => 'DBA-Senior', 'hours' => 4 }
			}
		,'Coordinar_cambio_de_configuración' => {
			'responsable' => '*&US'
			,'resource' => { 'type' => 'DBA-Senior', 'hours' => 4 }
			}
	}
};
&{$::debug}("rData: %s", Dump($rData));

} else {

my $rActivities = LoadYaml($sActivFile);
&{$::debug}("rActivities: %s", Dumper($rActivities));


my $sProjName='project';
$sProjName=$rActivities->{'name'}
	if ($rActivities->{'name'});

my $sProjFile=$sProjName . '.md';

open FILE, ">:utf8", $sProjFile
	or die "No se pudo abrir archivo [$sProjFile] para escritura.";

my $sReport=ProjReport($rActivities);
print FILE $sReport;
close FILE;
	



# my ($hashref, $arrayref, $string) = Load(<<'...');


# 
# # Dump the Perl data structures back into YAML.
# print Dump($string, $arrayref, $hashref);
# 

#
# Close
#

}


close TRC
   if($optctl->{'trace'});

exit;
###############################################################################

sub Funcion
{
	my ($sParam1, $sParam2)=@_;
	my $ret='';
	
	&{$::debug}("Funcion( %s )", join(' ', map( (defined($_)?"[$_]":'<undef>'), @_)));

	# Cuerpo de Funcion
	
	&{$::debug}("Funcion()->[%s]", $ret);
	return $ret;
}


sub ProjReport($)
{
	my ($rProj)=@_;
	my $ret='';
	
	&{$::debug}("ProjReport( %s )", join(' ', map( (defined($_)?"[$_]":'<undef>'), @_)));

	# Cuerpo de Funcion
	my $sTitle=(defined($rProj->{'desc'}))
		?$rProj->{'desc'} : 'Project';

	$ret=sprintf("# %s\n", $sTitle);

	if (defined($rProj->{'outline'})) {
		$ret.="\n# Outline\n";
		$ret.=TextOutline($rProj->{'outline'},0)
	}
	
	
	&{$::debug}("ProjReport()->[%s]", $ret);
	return $ret;
}


sub TextOutline($$)
{
	my ($rOutline, $nLevel)=@_;
	$nLevel=0 unless (defined($nLevel));
	my $ret='';
	
	&{$::debug}("TextOutline( %s )", join(' ', map( (defined($_)?"[$_]":'<undef>'), @_)));

	# Cuerpo de Funcion
	
	foreach my $item (@{$rOutline}) {
		my $sItem = $item;
		if (ref($item) eq "HASH") {
			($sItem) = keys(%{$item});
			$ret.= sprintf("%s* %s\n", ' ' x $nLevel, $sItem);
			$ret.= TextOutline($item->{${sItem}}, $nLevel+1);
		} else {
			$ret.= sprintf("%s* %s\n", ' ' x $nLevel, $sItem);
		}; 
	}

	&{$::debug}("TextOutline()->[%s]", $ret);
	return $ret;
}


sub LoadYaml($)
{
	my ($sFile)=@_;
	my $ret='';
	
	&{$::debug}("LoadYaml( %s )", join(' ', map( (defined($_)?"[$_]":'<undef>'), @_)));

	# Cuerpo de Funcion
	open FILE, "<:utf8", $sFile
		or die "No se pudo abrir archivo [$sFile] para escritura.";
	
	my $text='';
	while(<FILE>) {
		$text.=$_;	
	}
	close FILE;
	
	$ret=Load($text);
	
	&{$::debug}("LoadYaml()->[%s]", $ret);
	return $ret;
}

