set ns [ new Simulator ]

set nf [open lab5.nam w]

$ns namtrace-all $nf

set nt [open lab5.tr w]

$ns trace-all $nt

set proto rlm


$ns color 1 Blue
$ns color 2 Red


for {set i 0} {$i < 7} {incr i} {
    set n($i) [$ns node]
}


for {set i 0} {$i < 7} {incr i} {
    $ns duplex-link $n($i) $n([expr ($i+1)%7]) 10Mb 10ms DropTail
}



# seeting UDP communication
set udp [new Agent/UDP]

$ns attach-agent $n(0) $udp

set null [new Agent/Null]
$ns attach-agent $n(3) $null
$ns connect $udp $null
$udp set fid_ 1


set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 1mb
$cbr set random_ false


$ns at 0.5 "$cbr start"
$ns at 4.5 "$cbr stop"


$ns rtmodel-at 1.0 down $n(1) $n(2)
$ns rtmodel-at 2.0 up $n(1) $n(2)


$ns rtproto LS


proc finish {} {
    global ns nf

    # flushing tracing
    $ns flush-trace

    # closing file
    close $nf

    #execute NAM on the trace file
    exec nam lab5.nam &
    exit 0
}


$ns at 5.0 "finish"


$ns run