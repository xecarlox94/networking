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
    $ns duplex-link $n1(0) $n1($j) 1Mb 1ms DropTail

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
    $ns duplex-link $n2(0) $n2($j) 1Mb 15ms DropTail

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

    # network 1
    $ns duplex-link $n3(0) $n3($j) 1Mb 15ms DropTail

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



$ns at $t "finish"

$ns run
