set ns [new Simulator]

$ns color 1 red

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



for {set i 0} {$i < 10} {incr i} {
    set n($i) [$ns node]
}


for {set i 0} {$i < 10} {incr i} {
    for {set j 0} {$j < 10} {incr j} {
        $ns duplex-link $n($i) $n([expr ($i+1)%10]) 10Mb 50ms DropTail
        $ns duplex-link $n($i) $n([expr ($i+2)%10]) 10Mb 50ms DropTail
    }
}


# seeting UDP communication
# set udp [new Agent/UDP]


# proc set_cbr_connect {ubp} {

#     $ns attach-agent $n(0) $udp

#     set null [new Agent/Null]
#     $ns attach-agent $n(3) $null
#     $ns connect $udp $null
#     $udp set fid_ 1


#     set cbr [new Application/Traffic/CBR]
#     $cbr attach-agent $udp
#     $cbr set type_ CBR
#     $cbr set packet_size_ 1000
#     $cbr set rate_ 1mb
#     $cbr set random_ false


#     $ns at 0.5 "$cbr start"
#     $ns at 4.5 "$cbr stop"

# }


# $ns rtmodel-at 1.0 down $n(1) $n(2)
# $ns rtmodel-at 2.0 up $n(1) $n(2)


# $ns rtproto LS



$ns at 1.0 "finish"


$ns run
