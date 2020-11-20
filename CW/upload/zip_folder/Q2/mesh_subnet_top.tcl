set ns [new Simulator]

$ns color 1 red
$ns color 2 blue

set nf [open mesh_subnet_top.nam w]
set tf [open mesh_subnet_top.tr w]

$ns namtrace-all $nf
$ns trace-all $tf



$ns rtproto LS

proc finish {} {
    global ns nf

    $ns flush-trace

    close $nf

    exec nam mesh_subnet_top.nam &

    exit 0
}



# round trip time function
Agent/Ping instproc recv {from rtt} {
    $self instvar node_
    puts "Round Trip Time ($rtt ms): from node $from to node [$node_ id]"
}


set v 25
set t 100.0

for {set i 0} {$i < $v} {incr i} {
    set n1($i) [$ns node]
    set n2($i) [$ns node]
}


for {set i 0} {$i < $v} {incr i} {
    for {set k 0} {$k < $v} {incr k} {
        set y [expr ($k+1) % $v]

        if { $k != $i && $i % 3 == 0} {

            $ns duplex-link $n1($k) $n1($i) 5Mb 2ms RED
            $ns queue-limit $n1($k) $n1($i) 15
            $ns queue-limit $n1($i) $n1($k) 15

            $ns duplex-link $n2($k) $n2($i) 5Mb 2ms RED
            $ns queue-limit $n2($k) $n2($i) 15
            $ns queue-limit $n2($i) $n2($k) 15
        }
    }
}


for {set j 1} {$j < $v} {incr j} {

    set y [expr ($j+1) % $v]

    # network 1
    set tcpa($y) [new Agent/TCP]
    $tcpa($y) set class_ 2
    $tcpa($y) set window_ 3
    $ns attach-agent $n1($y) $tcpa($y)

    set sinka($y) [new Agent/TCPSink]
    $ns attach-agent $n1($j) $sinka($y)
    $ns connect $tcpa($y) $sinka($y)
    $tcpa($y) set fid_ 2

    set ftpa($y) [new Application/FTP]
    $ftpa($y) attach-agent $tcpa($y)
    $ftpa($y) set type_ FTP

    $ns at 0.0 "$ftpa($y) start"
    $ns at $t "$ftpa($y) stop"



    set udpa($y) [new Agent/UDP]
    $ns attach-agent $n1($j) $udpa($y)

    set nulla($y) [new Agent/Null]
    $ns attach-agent $n2($y) $nulla($y)
    $ns connect $udpa($y) $nulla($y)
    $udpa($y) set fid_ 1

    set cbra($y) [new Application/Traffic/CBR]
    $cbra($y) attach-agent $udpa($y)
    $cbra($y) set type_ CBR
    $cbra($y) set packet_size_ 1000
    $cbra($y) set rate_ 0.1mb
    $cbra($y) set random_ true

    $ns at 0.0 "$cbra($y) start"
    $ns at $t "$cbra($y) stop"


    # network 2
    set tcpb($y) [new Agent/TCP]
    $tcpb($y) set class_ 2
    $tcpb($y) set window_ 3
    $ns attach-agent $n2($y) $tcpb($y)

    set sinkb($y) [new Agent/TCPSink]
    $ns attach-agent $n2($j) $sinkb($y)
    $ns connect $tcpb($y) $sinkb($y)
    $tcpb($y) set fid_ 2

    set ftpb($y) [new Application/FTP]
    $ftpb($y) attach-agent $tcpb($y)
    $ftpb($y) set type_ FTP

    $ns at 0.0 "$ftpb($y) start"
    $ns at $t "$ftpb($y) stop"



    set udpb($y) [new Agent/UDP]
    $ns attach-agent $n2($j) $udpb($y)

    set nullb($y) [new Agent/Null]
    $ns attach-agent $n1($y) $nullb($y)
    $ns connect $udpb($y) $nullb($y)
    $udpb($y) set fid_ 1

    set cbrb($y) [new Application/Traffic/CBR]
    $cbrb($y) attach-agent $udpb($y)
    $cbrb($y) set type_ CBR
    $cbrb($y) set packet_size_ 1000
    $cbrb($y) set rate_ 0.1mb
    $cbrb($y) set random_ true

    $ns at 0.0 "$cbrb($y) start"
    $ns at $t "$cbrb($y) stop"


}



$ns duplex-link $n1(0) $n2(0) 20Mb 5ms RED
$ns queue-limit $n1(0) $n2(0) 50
$ns queue-limit $n2(0) $n1(0) 50




set p0 [new Agent/Ping]
$ns attach-agent $n1(1) $p0

set p1 [new Agent/Ping]
$ns attach-agent $n2(1) $p1

$ns connect $p0 $p1

$ns at 0.5 "$p0 send"
$ns at 0.5 "$p1 send"


$ns at $t "finish"

$ns run
