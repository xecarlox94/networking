set ns [new Simulator]

$ns color 1 red
$ns color 2 red

set nf [open top1.nam w]
set tf [open top1.r w]

$ns namtrace-all $nf
$ns trace-all $tf

proc finish {} {
    global ns nf

    $ns flush-trace

    close $nf

    exec nam top1.nam &

    exit 0
}


# seeting UDP communication


set v 25
set t 3.0



for {set i 0} {$i < $v} {incr i} {
    set n($i) [$ns node]
}


for {set i 0} {$i < $v} {incr i} {
    for {set j 0} {$j < $v} {incr j} {
        if {$i % 7 == 0 && $i != $j} {
            $ns duplex-link $n($i) $n($j) 10Mb 50ms DropTail

            set udp($i) [new Agent/UDP]

            $ns attach-agent $n($i) $udp($i)

            set null1 [new Agent/Null]
            $ns attach-agent $n($j) $null1
            $ns connect $udp($i) $null1
            $udp($i) set fid_ 1


            set cbr($i) [new Application/Traffic/CBR]
            $cbr($i) attach-agent $udp($i)
            $cbr($i) set type_ CBR
            $cbr($i) set packet_size_ 1000
            $cbr($i) set rate_ 1mb
            $cbr($i) set random_ false


            $ns at 0.0 "$cbr($i) start"
            $ns at $t "$cbr($i) stop"
        }
    }
}






set tcp1 [new Agent/TCP]
$tcp1 set class_ 2
$ns attach-agent $n(2) $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n(8) $sink1
$ns connect $tcp1 $sink1
$tcp1 set fid_ 2

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP


$ns at 0.0 "$ftp1 start"
$ns at $t "$ftp1 stop"


# $ns rtmodel-at 0.5 down $n(1) $n(2)
# $ns rtmodel-at 1 up $n(1) $n(2)
# $ns rtmodel-at 0.5 down $n(2) $n(3)
# $ns rtmodel-at 1 up $n(2) $n(3)

$ns rtproto DV

$ns at $t "finish"


$ns run
