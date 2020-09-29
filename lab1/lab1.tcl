# creating simulator
set ns [new Simulator]

# setting colours for data flows
$ns color 1 Blue
$ns color 2 Red

# Open the NAM trace file
set nf [open out.nam w]
$ns namtrace-all $nf


proc finish {} {
    global ns nf

    # flushing tracing
    $ns flush-trace

    # closing file
    close $nf

    #execute NAM on the trace file
    exec nam out.nam &
    exit 0
}

# setting nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

# Create links between the nodes, bandwidth, speed and type of buffer
$ns duplex-link $n0 $n2 1.5Mb 10ms RED
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms RED
$ns duplex-link $n0 $n4 2Mb 10ms DropTail
$ns duplex-link $n1 $n4 2Mb 10ms DropTail


# setting queue size between link (n2-n3) to 10
$ns queue-limit $n2 $n3 7
$ns queue-limit $n3 $n2 7
$ns queue-limit $n2 $n0 1


# node position (For NAM)
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n0 $n4 orient left-down
$ns duplex-link-op $n1 $n4 orient left-up

# monitor queue for link (n2-n3), (for NAM)
$ns duplex-link-op $n2 $n3 queuePos 0.5


# setup a tcp agent
set tcp [new Agent/TCP]
$tcp set class_ 2

# set node as a TCP sender
$ns attach-agent $n2 $tcp

# set TCP receiver agent
set sink [new Agent/TCPSink]

# set node as TCP receiver
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
$tcp set fid_ 1


# setup FTP application over TCP
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP


# setup a UDP sender agent
set udp [new Agent/UDP]

# set node as UDP sender
$ns attach-agent $n3 $udp


# set UDP receiver agent
set null [new Agent/Null]
$ns attach-agent $n4 $null
$ns connect $udp $null
$udp set fid_ 2

# setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 1mb
$cbr set random_ false


# schedule events for CBR and FTP agents
$ns at 0.0 "$cbr start"
$ns at 0.3 "$ftp start"
$ns at 1.0 "$ftp stop"
$ns at 1.0 "$cbr stop"


# detach tcp and sink agents
$ns at 1.0 "$ns detach-agent $n2 $tcp ; $ns detach-agent $n4 $sink"

# finish procedure 
$ns at 1.1 "finish"

# print CBR packet size and interval
puts "CBR packet size = [$cbr set packet_size_ ]"
puts "CBR interval = [$cbr set interval_ ]"

# run simulation
$ns run
