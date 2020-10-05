set ns [new Simulator]

$ns color 1 Red
$ns color 2 Blue
$ns color 3 Green


set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
    global ns nf

    $ns flush-trace

    close $nf

    exec nam out.nam &

    exit 0
}


set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]


$ns duplex-link $n0 $n2 1Mb 15ms DropTail
$ns duplex-link $n4 $n0 1Mb 15ms DropTail
$ns duplex-link $n1 $n4 1Mb 15ms DropTail
$ns duplex-link $n2 $n1 1Mb 15ms DropTail
$ns duplex-link $n3 $n2 1Mb 15ms DropTail


$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n4 $n0 orient right-up
$ns duplex-link-op $n1 $n4 orient left-up
$ns duplex-link-op $n2 $n1 orient left-down
$ns duplex-link-op $n3 $n2 orient left


$ns queue-limit $n2 $n3 10

$ns duplex-link-op $n2 $n3 queuePos 0.5



set tcp1 [new Agent/TCP]
$tcp1 set class_ 2
$ns attach-agent $n0 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n3 $sink1
$ns connect $tcp1 $sink1
$tcp1 set fid_ 2

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP





set udp1 [new Agent/UDP]
$ns attach-agent $n3 $udp1

set null1 [new Agent/Null]
$ns attach-agent $n4 $null1

$ns connect $udp1 $null1
$udp1 set fid_ 3

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set type_ CBR
$cbr1 set packet_size_ 1000
$cbr1 set rate_ 1mb
$cbr1 set random_ false




set udp2 [new Agent/UDP]
$ns attach-agent $n1 $udp2

set null2 [new Agent/Null]
$ns attach-agent $n3 $null2

$ns connect $udp2 $null2
$udp2 set fid_ 1

set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2
$cbr2 set type_ CBR
$cbr2 set packet_size_ 1000
$cbr2 set rate_ 1mb
$cbr2 set random_ false


$ns at 0.0 "$ftp1 start"
$ns at 1.0 "$ftp1 stop"
$ns at 0.3 "$cbr2 start"
$ns at 0.9 "$cbr2 stop"
$ns at 0.1 "$cbr1 start"
$ns at 0.7 "$cbr1 stop"


$ns at 1.5 "finish"

$ns run
