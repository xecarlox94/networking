set ns [new Simulator]

$ns color 1 red
$ns color 2 blue

set nf [open top2.nam w]
set tf [open top2.r w]

$ns namtrace-all $nf
$ns trace-all $tf



$ns rtproto DV

proc finish {} {
    global ns nf

    $ns flush-trace

    close $nf

    exec nam top2.nam &

    exit 0
}


# seeting UDP communication


set v 25
set t 1.0

for {set i 0} {$i < $v} {incr i} {
    set n1($i) [$ns node]
    set n2($i) [$ns node]
}


for {set j 1} {$j < $v} {incr j} {

    if { 1 == 1 } {
        for {set k 0} {$k < $v} {incr k} {
            if { $k != $j} {

                $ns duplex-link $n1($k) $n1($j) 4Mb 15ms RED
                $ns queue-limit $n1($k) $n1($j) 5
                $ns queue-limit $n1($j) $n1($k) 5

                set tcpa($j) [new Agent/TCP]
                $tcpa($j) set class_ 2
                $ns attach-agent $n1($j) $tcpa($j)

                set sinka($j) [new Agent/TCPSink]
                $ns attach-agent $n1($k) $sinka($j)
                $ns connect $tcpa($j) $sinka($j)
                $tcpa($j) set fid_ 2

                set ftpa($j) [new Application/FTP]
                $ftpa($j) attach-agent $tcpa($j)
                $ftpa($j) set type_ FTP

                $ns at 0.0 "$ftpa($j) start"
                $ns at $t "$ftpa($j) stop"



                set udpa($j) [new Agent/UDP]
                $ns attach-agent $n1($k) $udpa($j)

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
        }
    }



}



$ns at 10.0 "finish"

$ns run
