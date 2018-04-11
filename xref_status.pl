#!/usr/bin/perl
 
system('nc  -w1 -u 127.0.0.1 30002 <<EOF | grep -a DONGLE | sort -t, -k4,5 -r >./XRF_dongle.txt
pu
EOF'); 
use Getopt::Std;
use Time::Local;
 
 
getopts("vL:U:R:S:D:F:");
 
my $logFile;
my $htmlFile;
my $logSTATUSFile;

if ( $opt_S ) {
  $logSTATUSFile = $opt_S;
}
else {
  $logSTATUSFile = './XRF_STATUS.txt';
}
if ( $opt_S ) {
  $logSTATUSFile = $opt_F;
}
else {
  $logdongleSTATUSFile = './XRF_dongle.txt';
}
 
if ( $opt_L ) {
  $logFile = $opt_L;
}
else {
  $logFile = '/var/log/dextra_reflect.log';
}
 
if ( $opt_U ) {
  $htmlFileUser = $opt_U;
}
else {
   $htmlFileUser = './xref_userstatus.htm';
}
 
if ( $opt_R ) {
  $htmlFileRpt = $opt_R;
}
else {
  $htmlFileRpt = './xref_rptstatus.htm';
}

if ( $opt_D ) {
  $htmlFileRpt = $opt_D;
}
else {
  $htmlFileDongle = './xref_dongle.htm';
}
 
if ( $opt_v ) {
  print "xref_status.pl v0.12b by DG9BEW & DG1HT\n";
  print "dExtra Log: $logFile\n";
  print "HTML Output: $htmlFile\n";
}
my $f = 0; 
my $r = 0; 
my $i = 0;
my $j = 0;
my @lhlist;
my @rptlist;
open(LOG, $logFile) or die "can't open $logFile: $!";
while (<LOG>) {
  chomp;
  if ( m/^([0-9]{6}) at ([0-9:]{7,8}):START user: streamID=[0-9]{1,3},[0-9]{1,3}, my=([a-zA-Z0-9 ]{7}[a-fh-zA-FH-Z0-9 ]), sfx=([a-zA-Z0-9 ]{3,4}), ur=([a-zA-Z0-9 \/]{8}), rpt1=([a-zA-Z0-9 ]{8}), rpt2=([a-zA-Z0-9 ]{8}), [0-9]{1,4} bytes fromIP=([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}), src=([a-zA-Z0-9 ]{10})$/ ) {
   print "$_\n" if ($opt_v);
   (my $date, my $timestamp, my $mycall, my $suffix, my $yourcall, my $rpt1, my $rpt2, my $fromIP, my $src) = /^([0-9]{6}) at ([0-9:]{7,8}):START user: streamID=[0-9]{1,3},[0-9]{1,3}, my=([a-zA-Z0-9 ]{8}), sfx=([a-zA-Z0-9 ]{3,4}), ur=([a-zA-Z0-9 \/]{8}), rpt1=([a-zA-Z0-9 ]{8}), rpt2=([a-zA-Z0-9 ]{8}), [0-9]{1,4} bytes fromIP=([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}), src=([a-zA-Z0-9 ]{10})$/;
   print "$mycall\n" if ($opt_v);
   $_ = $timestamp;
   (my $hours, my $minutes, my $seconds) = /^([0-9]{1,2}):([0-9]{2}):([0-9]{2})$/;
   $_ = $date;
   (my $month, my $day, my $year) = /^([0-9]{2})([0-9]{2})([0-9]{2})$/;
   $hours =~ s/^0([1-9])/\1/;
   $minutes =~ s/^0//;
   $seconds =~ s/^0//;
   $month =~ s/^0//;
   $month--;
   $day =~ s/^0//;
   $year =~ s/^0//;
   $time = timelocal($seconds, $minutes, $hours, $day, $month, $year);
   $mycall =~ s/ *$//;
   $suffix =~ s/ *$//;
   $yourcall =~ s/ *$//;
   $rpt1 =~ s/ *$//;
   $rpt2 =~ s/ *$//;
   $src =~ s/ *$//;
   $lhlist[$i]{time} = $time;
   $lhlist[$i]{mycall} = $mycall;
   $lhlist[$i]{suffix} = $suffix;
   $lhlist[$i]{yourcall} = $yourcall;
$lhlist[$i]{rpt1} = $rpt1;
$lhlist[$i]{rpt2} = $rpt2;
   $lhlist[$i]{fromIP} = $fromIP;
   $lhlist[$i]{src} = $src;
   print scalar localtime($lhlist[$i]{time}) if ($opt_v);
   print " $lhlist[$i]{mycall}\n" if ($opt_v);
   $i++;
   
  }
}
 
 
open (HTMLOUT, ">$htmlFileUser") or die("Kann $htmlFileUser nicht oeffnen: $!\n");
print HTMLOUT "<center><h5>XRF005 User List  > Last 30 
<table width=100% height=100 border=1>
  <tr bgcolor=#FFFF00>
   <th><center><FONT SIZE=3>Nr.</th>
   <th><center><FONT SIZE=3>MyCall</th>
   <th><center><FONT SIZE=3>Suffix</th>
   <th><center><FONT SIZE=3>YourCall</th>
   <th><center><FONT SIZE=3>Source</th>
   <th><center><FONT SIZE=3>Last Heard</th>
  </tr>";

my @printedCall;
my $cntPrinted = 1;

while ( $i >= 1 && $cntPrinted <= 30 ) {
  $i--;
  print "$i $lhlist[$i]{mycall}\n" if ($opt_v);
  if ( !(grep /$lhlist[$i]{mycall}/, @printedCall) ) {
  
if ($f <= 0){ 
print HTMLOUT "<tr><td><center><FONT SIZE=2>$cntPrinted</td>";
}
if ($f >= 1){ 
print HTMLOUT "<tr bgcolor=#FFFFF0><td><center><FONT SIZE=2>$cntPrinted</td>
"}
    print HTMLOUT "<td><center><FONT SIZE=3>$lhlist[$i]{mycall}</td>"; # REF-Modul
   print HTMLOUT "<td>.<FONT SIZE=3> $lhlist[$i]{suffix}</td>";
   print HTMLOUT "<td><center><FONT SIZE=3>$lhlist[$i]{yourcall}</td>";
   print HTMLOUT "<td><center><FONT SIZE=3>$lhlist[$i]{src}</td>";
 #  print HTMLOUT "<td><center><FONT SIZE=3>$lhlist[$i]{rpt1}</td>";
 #  print HTMLOUT "<td><center><FONT SIZE=3>$lhlist[$i]{rpt2}</td>";
   print HTMLOUT "<td><FONT SIZE=3>";
   {
     use integer;
     my $vorSekunden = time() - $lhlist[$i]{time};
     my $tage = $vorSekunden / 86400;
     my $std = ( $vorSekunden - ($tage * 86400)) / 3600;
     my $min = ( $vorSekunden - ($tage * 86400) - ($std * 3600)) / 60;
     my $sek = ( $vorSekunden - ($tage * 86400) - ($std * 3600)) % 60;
     if ( $tage > 0 ) { print HTMLOUT "$tage d "; }
     if ( $std > 0 ) { print HTMLOUT "$std h "; }
     if ( $min > 0 ) { print HTMLOUT "$min m "; }
     if ( $sek > 0 ) { print HTMLOUT "$sek s"; }
   }
   # print HTMLOUT scalar localtime($lhlist[$i]{time});
   print HTMLOUT "</td>\n";
   $cntPrinted++;
$f++;
if ($f >= 2){ $f=0
}
   push(@printedCall, $lhlist[$i]{mycall});
  }
}
print HTMLOUT "<table>\n";


close (HTMLOUT);


 
# B,DM0HMB  ,C,141.22.12.147,063009,16:52:59

open(LOG, $logSTATUSFile) or die "can't open $logSTATUSFile: $!";
open (HTMLOUT, ">$htmlFileRpt") or die("Kann $htmlFileRpt nicht oeffnen: $!\n");

print HTMLOUT "<center><h5>XRF005 Repeaters</h5></center>
<table width=100% height=100 border=1>
  <tr bgcolor=#FFFF00>
   <th><center><font size=3>Nr.</font></center></th>
   <th><center><font size=3>Repeater</font></center></th>
   <th><center><font size=3>Modul</font></center></th>
   <th><center><font size=3>Linked since</font></center></th>
   <th><center><font size=3>XModul</font></center></th>
  </tr>\n";


my $nummer=0;
my @dataline;
while (<LOG>) {
  chomp;
  (my $reflector_module, my $repeater, my $repeater_module, my $ip, my $datum, my $zeit) = split (/,/);
  $datum =~ s/([0-9][0-9])([0-9][0-9])([0-9][0-9])/$1 $2 $3/;
  (my $monat, my $tag, my $jahr) = split(/ /, $datum);
  (my $stunde, my $minute, my $sekunde) = split(/:/, $zeit);
  my $zeit_epoch = timelocal($sekunde, $minute, $stunde, $tag, $monat-1, $jahr+100);
  my $vorSekunden = sprintf "%07d", time() - $zeit_epoch;
  $dataline[$nummer] = "$vorSekunden $reflector_module $repeater $repeater_module";
  $nummer++;
}

my @dataline_sorted = sort @dataline;
$nummer = 1;

foreach my $zeile (@dataline_sorted) {
	(my $vorSekunden, my $reflector_module, my $repeater, my $repeater_module) = split(/ +/,$zeile);
	if ( $nummer%2 == 1 ) {
      print HTMLOUT "  <tr>\n";
    } else {
      print HTMLOUT "  <tr bgcolor=#FFFFF0>\n";
    }
	print HTMLOUT "    <td><center><font size=2>$nummer</font></center></td>\n";
	print HTMLOUT "    <td><center><font size=3>$repeater</font></center></td>\n";
	print HTMLOUT "    <td><center><font size=3>$repeater_module</font></center></td>\n";
	print HTMLOUT "    <td>";
    {
      use integer;
      my $tage = $vorSekunden / 86400;
      my $std = ( $vorSekunden - ($tage * 86400)) / 3600;
      my $min = ( $vorSekunden - ($tage * 86400) - ($std * 3600)) / 60;
      my $sek = ( $vorSekunden - ($tage * 86400) - ($std * 3600)) % 60;
      if ( $tage > 0 ) { print HTMLOUT "$tage d "; }
      if ( $std > 0 ) { print HTMLOUT "$std h "; }
      if ( $min > 0 ) { print HTMLOUT "$min m "; }
      if ( $sek > 0 ) { print HTMLOUT "$sek s"; }
    }
	print HTMLOUT "</td>\n";
	print HTMLOUT "    <td align=center>$reflector_module</font></center></td>\n";
	print HTMLOUT "  </tr>\n";
	$nummer++;
}

print HTMLOUT "</table>\n";

close (HTMLOUT);






#___________________________________________________
# DG1HT   ,87.150.246.99,DONGLE,070209,11:25:25,notMuted
open(LOG, $logdongleSTATUSFile) or die "can't open $logdongleSTATUSFile: $!";
open (HTMLOUT, ">$htmlFileDongle") or die("Kann $htmlFileDongle nicht oeffnen: $!\n");

print HTMLOUT "<center><h5>XRF005 Dongle User</h5></center>
<table width=100% height=100 border=1>
  <tr bgcolor=#FFFF00>
   <th><center><font size=3>Nr.</font></center></th>
   <th><center><font size=3>Dongle User</font></center></th>
   <th><center><font size=3>Linked since</font></center></th>
  </tr>\n";


my $nummer=0;
my @dataline;
while (<LOG>) {
  chomp;
  (my $call, my $ip, my $dongle ,my $datum, my $zeit ,my $Mute) = split (/,/);
  $datum =~ s/([0-9][0-9])([0-9][0-9])([0-9][0-9])/$1 $2 $3/;
  (my $monat, my $tag, my $jahr) = split(/ /, $datum);
  (my $stunde, my $minute, my $sekunde) = split(/:/, $zeit);
  my $zeit_epoch = timelocal($sekunde, $minute, $stunde, $tag, $monat-1, $jahr+100);
  my $vorSekunden = sprintf "%07d", time() - $zeit_epoch;
  $dataline[$nummer] = "$vorSekunden $call $ip $dongle";
  $nummer++;
}

my @dataline_sorted = sort @dataline;
$nummer = 1;

foreach my $zeile (@dataline_sorted) {
	(my $vorSekunden, my $call, my $ip, my $dongle) = split(/ +/,$zeile);
	if ( $nummer%2 == 1 ) {
      print HTMLOUT "  <tr>\n";
    } else {
      print HTMLOUT "  <tr bgcolor=#FFFFF0>\n";
    }
	print HTMLOUT "    <td><center><font size=2>$nummer</font></center></td>\n";
	print HTMLOUT "    <td><center><font size=3>$call</font></center></td>\n";
	print HTMLOUT "    <td>";
    {
      use integer;
      my $tage = $vorSekunden / 86400;
      my $std = ( $vorSekunden - ($tage * 86400)) / 3600;
      my $min = ( $vorSekunden - ($tage * 86400) - ($std * 3600)) / 60;
      my $sek = ( $vorSekunden - ($tage * 86400) - ($std * 3600)) % 60;
      if ( $tage > 0 ) { print HTMLOUT "$tage d "; }
      if ( $std > 0 ) { print HTMLOUT "$std h "; }
      if ( $min > 0 ) { print HTMLOUT "$min m "; }
      if ( $sek > 0 ) { print HTMLOUT "$sek s"; }
    }
	print HTMLOUT "</td>\n";
	print HTMLOUT "  </tr>\n";
	$nummer++;
}

print HTMLOUT "</table>\n";

close (HTMLOUT);
