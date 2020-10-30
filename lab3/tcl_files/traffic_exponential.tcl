#Create a simulator object
set ns [new Simulator]

#Open a nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam out.nam &
    exit 0
}

set n0 [$ns node]
set n1 [$ns node]
$n0 color blue
$n1 color red

#Connect the nodes with two links
$ns duplex-link $n0 $n1 1Mb 10ms DropTail

proc smtp_traffic {node0 node1 } {
    global ns
    set smtp_UDP_agent [new Agent/UDP]
    set smtp_UDP_sink [new Agent/UDP]
    $ns attach-agent $node0 $smtp_UDP_agent
    $ns attach-agent $node1 $smtp_UDP_sink
    $ns connect $smtp_UDP_agent $smtp_UDP_sink
    set smtp_UDP_source [new Application/Traffic/Exponential]
    $smtp_UDP_source attach-agent $smtp_UDP_agent
    $smtp_UDP_source set packetSize_ 210
    $smtp_UDP_source set burst_time_ 50ms
    $smtp_UDP_source set idle_time_ 50ms
    $smtp_UDP_source set rate_ 100k
    $ns at 0.2 "$smtp_UDP_source start"
    $ns at 3.2 "$smtp_UDP_source stop"
}

smtp_traffic $n0 $n1
$ns at 4.0 "finish"
$ns run