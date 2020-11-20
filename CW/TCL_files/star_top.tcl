
set ns [new Simulator]

set nf [open star_top.nam w]
set tf [open star_top.tr w]

$ns namtrace-all $nf
$ns trace-all $tf



$ns rtproto LS



$ns color 1 red
$ns color 2 blue

proc finish {} {
    global ns nf

    $ns flush-trace

    close $nf

    exec nam star_top.nam &

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
}

$n1(0) shape square

for {set j 1} {$j < $v} {incr j} {
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
    $ns attach-agent $n1($j) $nulla($j)

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
}



set p1 [new Agent/Ping]
$ns attach-agent $n1(1) $p1

set p2 [new Agent/Ping]
$ns attach-agent $n1(2) $p2

$ns connect $p1 $p2

$ns at 0.5 "$p1 send"
$ns at 0.5 "$p2 send"



$ns at $t "finish"

$ns run
