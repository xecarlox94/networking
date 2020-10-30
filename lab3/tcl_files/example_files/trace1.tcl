#-------Event scheduler object creation--------#
set ns [new Simulator]
#Open the Trace files
set file1 [open trace.tr w]
$ns trace-all $file1
#Open the NAM trace file
set file2 [open trace.nam w]
$ns namtrace-all $file2
$ns color 1 Blue
$ns color 2 Red
#Create six nodes
set
set
set
set
set
set
n0
n1
n2
n3
n4
n5
[$ns
[$ns
[$ns
[$ns
[$ns
[$ns
node]
node]
node]
node]
node]
node]
#create links between the nodes
$ns
$ns
$ns
$ns
$ns
$ns
duplex-link $n0 $n2 2Mb 10ms DropTail
duplex-link $n1 $n2 2Mb 10ms DropTail
simplex-link $n2 $n3 0.3Mb 100ms DropTail
simplex-link $n3 $n2 0.3Mb 100ms DropTail
duplex-link $n3 $n4 0.5Mb 40ms DropTail
duplex-link $n3 $n5 0.5Mb 30ms DropTail
#Give node position (for NAM)$ns
$ns
$ns
$ns
$ns
$ns
duplex-link-op $n0 $n2 orient right-down
duplex-link-op $n1 $n2 orient right-up
simplex-link-op $n2 $n3 orient right
simplex-link-op $n3 $n2 orient left
duplex-link-op $n3 $n4 orient right-up
duplex-link-op $n3 $n5 orient right-down
#Set Queue Size of link (n2-n3) to 10
$ns queue-limit $n2 $n3 20
#Setup a TCP connection
set tcp [new Agent/TCP/Newreno]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink/DelAck]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
$tcp set fid_ 1
$tcp set window_ 8000
$tcp set packetSize_ 552
#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP
#Setup a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n5 $null
$ns connect $udp $null
$udp set fid_ 2
#Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 0.01mb
$cbr set random_ false
$ns
$ns
$ns
$ns
at
at
at
at
0.1
1.0
7.0
7.5
"$cbr
"$ftp
"$ftp
"$cbr
start"
start"
stop"
stop"
#-------------Trace file creation---------#$ns at 1.1025 "$ns trace-annotate \"Time: 1.1025 Pkt Transfer Path
thru node_(1)..\""
$ns at 2.1025 "$ns trace-annotate \"Time: 2.1025 Pkt Transfer Path
thru node_(1)..\""
$ns at 3.1025 "$ns trace-annotate \"Time: 3.1025 Pkt Transfer Path
thru node_(1)..\""
#Define a 'finish' procedure
proc finish {} {
global ns file1 file2
$ns flush-trace
close $file1
close $file2
exec nam trace.nam &
exit 0
}
#Calling finish procedure
$ns at 10.0 "finish"
$ns run