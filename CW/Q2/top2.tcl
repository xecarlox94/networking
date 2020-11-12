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
    # set n2($i) [$ns node]
}


for {set j 1} {$j < $v} {incr j} {

    if { 1 == 1 } {
        for {set k 0} {$k < $v} {incr k} {
            if { $k != $j} {

                set y [expr ($k+1) % $v]


                $ns duplex-link $n1($k) $n1($j) 50Mb 5ms RED
                # $ns queue-limit $n1($k) $n1($j) 20
                # $ns queue-limit $n1($j) $n1($k) 20

                set tcpa($y) [new Agent/TCP]
                $tcpa($y) set class_ 2
                $ns attach-agent $n1($y) $tcpa($y)

                set sinka($y) [new Agent/TCPSink]
                $ns attach-agent $n1($k) $sinka($y)
                $ns connect $tcpa($y) $sinka($y)
                $tcpa($y) set fid_ 2

                set ftpa($y) [new Application/FTP]
                $ftpa($y) attach-agent $tcpa($y)
                $ftpa($y) set type_ FTP

                $ns at 0.0 "$ftpa($y) start"
                $ns at $t "$ftpa($y) stop"



                set udpa($y) [new Agent/UDP]
                $ns attach-agent $n1($k) $udpa($y)

                set nulla($y) [new Agent/Null]
                $ns attach-agent $n1($y) $nulla($y)

                $ns connect $udpa($y) $nulla($y)
                $udpa($y) set fid_ 1

                set cbra($y) [new Application/Traffic/CBR]
                $cbra($y) attach-agent $udpa($y)
                $cbra($y) set type_ CBR
                $cbra($y) set packet_size_ 1000
                $cbra($y) set rate_ 1mb
                $cbra($y) set random_ true

                $ns at 0.0 "$cbra($y) start"
                $ns at $t "$cbra($y) stop"
            }
        }
    }



}



$ns at 10.0 "finish"

$ns run
