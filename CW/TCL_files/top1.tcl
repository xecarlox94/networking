
set ns [new Simulator]

set nf [open top1.nam w]
set tf [open top1.tr w]

$ns namtrace-all $nf
$ns trace-all $tf



$ns rtproto DV



$ns color 1 red
$ns color 2 blue

proc finish {} {
    global ns nf

    $ns flush-trace

    close $nf

    exec nam top1.nam &

    exit 0
}


# round trip time function
Agent/Ping instproc recv {from rtt} {
    $self instvar node_
    puts "Round Trip Time ($rtt ms): from node $from to node [$node_ id]"
}


set v 20
set t 100.0



for {set i 0} {$i < $v} {incr i} {
    set n1($i) [$ns node]
    set n2($i) [$ns node]
    set n3($i) [$ns node]
}

for {set j 1} {$j < $v} {incr j} {

    # network 1
    $ns duplex-link $n1(0) $n1($j) 10Mb 1ms RED

    set tcpa($j) [new Agent/TCP]
    $tcpa($j) set class_ 2
    $tcpa($j) set window_ 3
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
    $ns attach-agent $n3($j) $nulla($j)

    $ns connect $udpa($j) $nulla($j)
    $udpa($j) set fid_ 1

    set cbra($j) [new Application/Traffic/CBR]
    $cbra($j) attach-agent $udpa($j)
    $cbra($j) set type_ CBR
    $cbra($j) set packet_size_ 1000
    $cbra($j) set rate_ 0.1mb
    $cbra($j) set random_ true

    $ns at 0.0 "$cbra($j) start"
    $ns at $t "$cbra($j) stop"


    # network 2
    $ns duplex-link $n2(0) $n2($j) 10Mb 1ms RED

    set tcpb($j) [new Agent/TCP]
    $tcpb($j) set class_ 2
    $tcpb($j) set window_ 3
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
    $ns attach-agent $n1($j) $nullb($j)

    $ns connect $udpb($j) $nullb($j)
    $udpb($j) set fid_ 1

    set cbrb($j) [new Application/Traffic/CBR]
    $cbrb($j) attach-agent $udpb($j)
    $cbrb($j) set type_ CBR
    $cbrb($j) set packet_size_ 1000
    $cbrb($j) set rate_ 0.1mb
    $cbrb($j) set random_ true

    $ns at 0.0 "$cbrb($j) start"
    $ns at $t "$cbrb($j) stop"

    # network 3
    $ns duplex-link $n3(0) $n3($j) 10Mb 1ms RED

    set tcpc($j) [new Agent/TCP]
    $tcpc($j) set class_ 2
    $tcpc($j) set window_ 3
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
    $ns attach-agent $n2($j) $nullc($j)

    $ns connect $udpc($j) $nullc($j)
    $udpc($j) set fid_ 1

    set cbrc($j) [new Application/Traffic/CBR]
    $cbrc($j) attach-agent $udpc($j)
    $cbrc($j) set type_ CBR
    $cbrc($j) set packet_size_ 1000
    $cbrc($j) set rate_ 0.1mb
    $cbrc($j) set random_ true

    $ns at 0.0 "$cbrc($j) start"
    $ns at $t "$cbrc($j) stop"


}


set router [$ns node]

$ns duplex-link $router $n1(0) 10Mb 1ms RED
$ns queue-limit $router $n1(0) 15
$ns queue-limit $router $n1(0) 15




$ns duplex-link $router $n2(0) 10Mb 1ms RED
$ns queue-limit $router $n2(0) 15
$ns queue-limit $router $n2(0) 15




$ns duplex-link $router $n3(0) 10Mb 1ms RED
$ns queue-limit $router $n3(0) 15
$ns queue-limit $router $n3(0) 15




set p1 [new Agent/Ping]
$ns attach-agent $n1(1) $p1

set p2 [new Agent/Ping]
$ns attach-agent $n2(1) $p2

set p3 [new Agent/Ping]
$ns attach-agent $n3(1) $p3

$ns connect $p1 $p2
$ns connect $p1 $p3
$ns connect $p2 $p3

$ns at 0.5 "$p1 send"
$ns at 0.5 "$p2 send"
$ns at 0.5 "$p3 send"



$ns at $t "finish"

$ns run
