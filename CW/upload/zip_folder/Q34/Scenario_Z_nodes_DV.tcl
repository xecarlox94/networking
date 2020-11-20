
set ns [new Simulator]


set tf [open Scenario_Z_nodes_DV.tr w]


$ns trace-all $tf



$ns rtproto DV



$ns color 1 red
$ns color 2 blue

proc finish {} {
    global ns nf

    $ns flush-trace


    exit 0
}


# round trip time function
Agent/Ping instproc recv {from rtt} {
    $self instvar node_
    puts "Round Trip Time ($rtt ms): from node $from to node [$node_ id]"
}


set v 90
set t 10.0



for {set i 0} {$i < $v} {incr i} {
    set n1($i) [$ns node]
    set n2($i) [$ns node]
}


$n1(0) shape square
$n2(0) shape square

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
    $ns attach-agent $n2($j) $nulla($j)

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


}


set router [$ns node]

$router shape square


$ns duplex-link $router $n1(0) 10Mb 1ms RED
$ns queue-limit $router $n1(0) 15
$ns queue-limit $router $n1(0) 15




$ns duplex-link $router $n2(0) 10Mb 1ms RED
$ns queue-limit $router $n2(0) 15
$ns queue-limit $router $n2(0) 15





set p1 [new Agent/Ping]
$ns attach-agent $n1(1) $p1

set p2 [new Agent/Ping]
$ns attach-agent $n2(1) $p2

$ns connect $p1 $p2

$ns at 0.5 "$p1 send"
$ns at 0.5 "$p2 send"



$ns at $t "finish"

$ns run
