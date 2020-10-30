#-------Event scheduler object creation--------#
set ns [new Simulator]

#Creating nam file:
set nf [open graph1.nam w]
$ns namtrace-all $nf

#Open the trace file
set nt [open graph1.tr w]
$ns trace-all $nt

# graph procedure..
$ns at 1.0 "Graph"
set g [open graph.tr w]

proc Graph {} {
    global ns g g1
    set time 1.0
    set now [$ns now]
    puts $g "[expr rand()*8] [expr rand()*6]"
    $ns at [expr $now+$time] "Graph"
}

#Finish Procedure..
proc finish {} {
    global ns nf nt
    #exec xgraph -ng -geometry 600X500 graph1.tr &
    exec nam grahp1.nam &
    exit 0
}

#Calling finish procedure
$ns at 5.0 "finish"
$ns run