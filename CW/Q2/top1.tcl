set ns [new Simulator]

$ns color 1 red
$ns color 2 blue

set nf [open top1.nam w]
set tf [open top1.r w]

$ns namtrace-all $nf
$ns trace-all $tf



$ns rtproto LS

proc finish {} {
    global ns nf

    $ns flush-trace

    close $nf

    exec nam top1.nam &

    exit 0
}


# seeting UDP communication


set v 20
set t 1.0



for {set i 0} {$i < $v} {incr i} {
    set n1($i) [$ns node]
    set n2($i) [$ns node]
    set n3($i) [$ns node]
}

for {set j 1} {$j < $v} {incr j} {

    # network 1
    $ns duplex-link $n1(0) $n1($j) 1Mb 1ms RED

    set tcpa($j) [new Agent/TCP]
    $tcpa($j) set class_ 2
    $ns attach-agent $n1($j) $tcpa($j)

    set sinka($j) [new Agent/TCPSink]
    $ns attach-agent $n1(0) $sinka($j)
    $ns connect $tcpa($j) $sinka($j)
    $tcpa($j) set fid_ 2

    set ftpa($j) [new Application/FTP]
    $ftpa($j) attach-agent $tcpa($j)
    $ftpa($j) set type_ FTP

    $ns at 0.0 "$ftpa($j) start"
    $ns at $t "$ftpa($j) stop"



    set udpa($j) [new Agent/UDP]
    $ns attach-agent $n1(0) $udpa($j)

    set nulla($j) [new Agent/Null]
    $ns attach-agent $n1($j) $nulla($j)

    $ns connect $udpa($j) $nulla($j)
    $udpa($j) set fid_ 1

    set cbra($j) [new Application/Traffic/CBR]
    $cbra($j) attach-agent $udpa($j)
    $cbra($j) set type_ CBR
    $cbra($j) set packet_size_ 1000
    $cbra($j) set rate_ 1mb
    $cbra($j) set random_ true

    $ns at 0.0 "$cbra($j) start"
    $ns at $t "$cbra($j) stop"


    # network 2
    $ns duplex-link $n2(0) $n2($j) 1Mb 15ms RED

    set tcpb($j) [new Agent/TCP]
    $tcpb($j) set class_ 2
    $ns attach-agent $n2($j) $tcpb($j)

    set sinkb($j) [new Agent/TCPSink]
    $ns attach-agent $n2(0) $sinkb($j)
    $ns connect $tcpb($j) $sinkb($j)
    $tcpb($j) set fid_ 2

    set ftpb($j) [new Application/FTP]
    $ftpb($j) attach-agent $tcpb($j)
    $ftpb($j) set type_ FTP

    $ns at 0.0 "$ftpb($j) start"
    $ns at $t "$ftpb($j) stop"



    set udpb($j) [new Agent/UDP]
    $ns attach-agent $n2(0) $udpb($j)

    set nullb($j) [new Agent/Null]
    $ns attach-agent $n2($j) $nullb($j)

    $ns connect $udpb($j) $nullb($j)
    $udpb($j) set fid_ 1

    set cbrb($j) [new Application/Traffic/CBR]
    $cbrb($j) attach-agent $udpb($j)
    $cbrb($j) set type_ CBR
    $cbrb($j) set packet_size_ 1000
    $cbrb($j) set rate_ 1mb
    $cbrb($j) set random_ true

    $ns at 0.0 "$cbrb($j) start"
    $ns at $t "$cbrb($j) stop"

    # network 3
    $ns duplex-link $n3(0) $n3($j) 1Mb 15ms RED

    set tcpc($j) [new Agent/TCP]
    $tcpc($j) set class_ 2
    $ns attach-agent $n3($j) $tcpc($j)

    set sinkc($j) [new Agent/TCPSink]
    $ns attach-agent $n3(0) $sinkc($j)
    $ns connect $tcpc($j) $sinkc($j)
    $tcpc($j) set fid_ 2

    set ftpc($j) [new Application/FTP]
    $ftpc($j) attach-agent $tcpc($j)
    $ftpc($j) set type_ FTP

    $ns at 0.0 "$ftpc($j) start"
    $ns at $t "$ftpc($j) stop"



    set udpc($j) [new Agent/UDP]
    $ns attach-agent $n3(0) $udpc($j)

    set nullc($j) [new Agent/Null]
    $ns attach-agent $n3($j) $nullc($j)

    $ns connect $udpc($j) $nullc($j)
    $udpc($j) set fid_ 1

    set cbrc($j) [new Application/Traffic/CBR]
    $cbrc($j) attach-agent $udpc($j)
    $cbrc($j) set type_ CBR
    $cbrc($j) set packet_size_ 1000
    $cbrc($j) set rate_ 1mb
    $cbrc($j) set random_ true

    $ns at 0.0 "$cbrc($j) start"
    $ns at $t "$cbrc($j) stop"


}

set server [$ns node]

$ns duplex-link $server $n1(0) 1Mb 10ms RED
$ns duplex-link-op $server $n1(0) orient right

set tcpr1 [new Agent/TCP]
$tcpr1 set class_ 2
$ns attach-agent $n1(0) $tcpr1

set sinkr1 [new Agent/TCPSink]
$ns attach-agent $server $sinkr1
$ns connect $tcpr1 $sinkr1
$tcpr1 set fid_ 2

set ftpr1 [new Application/FTP]
$ftpr1 attach-agent $tcpr1
$ftpr1 set type_ FTP

$ns at 0.0 "$ftpr1 start"
$ns at $t "$ftpr1 stop"



set udpr1 [new Agent/UDP]
$ns attach-agent $server $udpr1

set nullr1 [new Agent/Null]
$ns attach-agent $n1(0) $nullr1
$ns connect $udpr1 $nullr1
$udpr1 set fid_ 1

set cbrr1 [new Application/Traffic/CBR]
$cbrr1 attach-agent $udpr1
$cbrr1 set type_ CBR
$cbrr1 set packet_size_ 1000
$cbrr1 set rate_ 1mb
$cbrr1 set random_ true

$ns at 0.0 "$cbrr1 start"
$ns at $t "$cbrr1 stop"




$ns duplex-link $server $n2(0) 1Mb 10ms RED
$ns duplex-link-op $server $n2(0) orient left


set tcpr2 [new Agent/TCP]
$tcpr2 set class_ 2
$ns attach-agent $n2(0) $tcpr2

set sinkr2 [new Agent/TCPSink]
$ns attach-agent $server $sinkr2
$ns connect $tcpr2 $sinkr2
$tcpr2 set fid_ 2

set ftpr2 [new Application/FTP]
$ftpr2 attach-agent $tcpr2
$ftpr2 set type_ FTP

$ns at 0.0 "$ftpr2 start"
$ns at $t "$ftpr2 stop"



set udpr2 [new Agent/UDP]
$ns attach-agent $server $udpr2

set nullr2 [new Agent/Null]
$ns attach-agent $n2(0) $nullr2
$ns connect $udpr2 $nullr2
$udpr2 set fid_ 1

set cbrr2 [new Application/Traffic/CBR]
$cbrr2 attach-agent $udpr2
$cbrr2 set type_ CBR
$cbrr2 set packet_size_ 1000
$cbrr2 set rate_ 1mb
$cbrr2 set random_ true

$ns at 0.0 "$cbrr2 start"
$ns at $t "$cbrr2 stop"


$ns duplex-link $server $n3(0) 1Mb 10ms RED
$ns duplex-link-op $server $n3(0) orient up



set tcpr3 [new Agent/TCP]
$tcpr3 set class_ 2
$ns attach-agent $n3(0) $tcpr3

set sinkr3 [new Agent/TCPSink]
$ns attach-agent $server $sinkr3
$ns connect $tcpr3 $sinkr3
$tcpr3 set fid_ 2

set ftpr3 [new Application/FTP]
$ftpr3 attach-agent $tcpr3
$ftpr3 set type_ FTP

$ns at 0.0 "$ftpr3 start"
$ns at $t "$ftpr3 stop"



set udpr3 [new Agent/UDP]
$ns attach-agent $server $udpr3

set nullr3 [new Agent/Null]
$ns attach-agent $n3(0) $nullr3
$ns connect $udpr3 $nullr3
$udpr3 set fid_ 1

set cbrr3 [new Application/Traffic/CBR]
$cbrr3 attach-agent $udpr3
$cbrr3 set type_ CBR
$cbrr3 set packet_size_ 1000
$cbrr3 set rate_ 1mb
$cbrr3 set random_ true

$ns at 0.0 "$cbrr3 start"
$ns at $t "$cbrr3 stop"


$ns at $t "finish"

$ns run
