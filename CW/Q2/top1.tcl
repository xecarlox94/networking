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


set v 4
set t 1.0



for {set i 0} {$i < $v} {incr i} {
    set n1($i) [$ns node]
    # set n2($i) [$ns node]
    # set n3($i) [$ns node]
}

for {set j 1} {$j < $v} {incr j} {

    # network 1
    $ns duplex-link $n1(0) $n1($j) 1Mb 15ms DropTail

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


}


set router [$ns node]
# network 1
$ns duplex-link $n1(0) $router 1Mb 15ms DropTail
# $ns duplex-link $n1(2) $router 1Mb 15ms DropTail



# setup a tcp agent
set tcp [new Agent/TCP]
$tcp set class_ 2

# set node as a TCP sender
$ns attach-agent $router $tcp

# set TCP receiver agent
set sink [new Agent/TCPSink]

# set node as TCP receiver
$ns attach-agent $n1(3) $sink
$ns connect $tcp $sink
$tcp set fid_ 2


# setup FTP application over TCP
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

$ns at 0.0 "$ftp start"
$ns at $t "$ftp stop"




set udp [new Agent/UDP]
$ns attach-agent $n1(1) $udp

set null [new Agent/Null]
$ns attach-agent $router $null


$ns connect $udp $null
$udp set fid_ 1

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 1mb
$cbr set random_ true

$ns at 0.0 "$cbr start"
$ns at $t "$cbr stop"


$ns at 10.0 "finish"

$ns run
