set ns [new Simulator]

$ns color 1 red
$ns color 2 blue

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


set v 5
set t 10.0



for {set i 0} {$i < $v} {incr i} {
    set n1($i) [$ns node]
    set n2($i) [$ns node]
}


for {set i 0} {$i < $v} {incr i} {
    
    if {$i % 50 == 0} {

        for {set j 0} {$j < $v} {incr j} {
             if {$i != $j} {
                $ns duplex-link $n1($i) $n1($j) 10Mb 50ms DropTail
                $ns duplex-link $n2($i) $n2($j) 10Mb 50ms DropTail




                set tcp1($i) [new Agent/TCP]
                $tcp1($i) set class_ 2
                $ns attach-agent $n1($j) $tcp1($i)

                set sink1($i) [new Agent/TCPSink]
                $ns attach-agent $n1($i) $sink1($i)
                $ns connect $tcp1($i) $sink1($i)
                $tcp1($i) set fid_ 2

                set ftp1($i) [new Application/FTP]
                $ftp1($i) attach-agent $tcp1($i)
                $ftp1($i) set type_ FTP

                $ns at 0.0 "$ftp1($i) start"
                $ns at $t "$ftp1($i) stop"



                set tcp2($i) [new Agent/TCP]
                $tcp2($i) set class_ 2
                $ns attach-agent $n2($j) $tcp2($i)

                set sink2($i) [new Agent/TCPSink]
                $ns attach-agent $n2($i) $sink2($i)
                $ns connect $tcp2($i) $sink2($i)
                $tcp2($i) set fid_ 2

                set ftp2($i) [new Application/FTP]
                $ftp2($i) attach-agent $tcp2($i)
                $ftp2($i) set type_ FTP
                
                $ns at 0.0 "$ftp2($i) start"
                $ns at $t "$ftp2($i) stop"





                set udp1($i) [new Agent/UDP]

                $ns attach-agent $n1($i) $udp1($i)

                set null1($i) [new Agent/Null]
                $ns attach-agent $n1($j) $null1($i)
                $ns connect $udp1($i) $null1($i)
                $udp1($i) set fid_ 1


                set cbr1($i) [new Application/Traffic/CBR]
                $cbr1($i) attach-agent $udp1($i)
                $cbr1($i) set type_ CBR
                $cbr1($i) set packet_size_ 1000
                $cbr1($i) set rate_ 1mb
                $cbr1($i) set random_ true


                $ns at 0.0 "$cbr1($i) start"
                $ns at $t "$cbr1($i) stop"



                set udp2($i) [new Agent/UDP]

                $ns attach-agent $n2($i) $udp2($i)

                set null2($i) [new Agent/Null]
                $ns attach-agent $n2($j) $null2($i)
                $ns connect $udp2($i) $null2($i)
                $udp2($i) set fid_ 1


                set cbr2($i) [new Application/Traffic/CBR]
                $cbr2($i) attach-agent $udp2($i)
                $cbr2($i) set type_ CBR
                $cbr2($i) set packet_size_ 1000
                $cbr2($i) set rate_ 1mb
                $cbr2($i) set random_ true


                $ns at 0.0 "$cbr2($i) start"
                $ns at $t "$cbr2($i) stop"
             }
        }
    }
}






$ns rtproto DV

$ns at $t "finish"


$ns run
