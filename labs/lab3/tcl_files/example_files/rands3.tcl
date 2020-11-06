#-------Event scheduler object creation--------#
set ns [new Simulator]
set nf [open Rands3.tr w]
$ns trace-all $nf
$ns namtrace-all [open Rands3.nam w]
#------------COLOR DESCRIPTION---------------#
$ns color 1 red
$ns color 30 purple
$ns color 31 green
# allocate a multicast address;
set group [Node allocaddr]
# nod is the number of nodes
set nod 5
# create multicast capable nodes;
for {set i 1} {$i <= $nod} {incr i} {
set n($i) [$ns node]
}
#Create links between the nodes
$ns duplex-link $n(1) $n(2) 0.3Mb 10ms DropTail
$ns duplex-link $n(2) $n(3) 0.3Mb 10ms DropTail
$ns duplex-link $n(2) $n(4) 0.5Mb 10ms DropTail
#$ns duplex-link $n(2) $n(5) 0.3Mb 10ms DropTail
$ns duplex-link $n(3) $n(4) 0.3Mb 10ms DropTail
$ns duplex-link $n(4) $n(5) 0.5Mb 10ms DropTail
#$ns duplex-link $n(4) $n(6) 0.5Mb 10ms DropTail
#$ns duplex-link $n(5) $n(6) 0.5Mb 10ms DropTail
# configures multicast protocol;
BST set RP_($group) $n(2)
$ns mrtproto BST
set udp1 [new Agent/UDP]
set udp2 [new Agent/UDP]
$ns attach-agent $n(1) $udp1
$ns attach-agent $n(2) $udp2set src1 [new Application/Traffic/CBR]
$src1 attach-agent $udp1
$udp1 set dst_addr_ $group
$udp1 set dst_port_ 0
$src1 set random_ false
set src2 [new Application/Traffic/CBR]
$src2 attach-agent $udp2
$udp2 set dst_addr_ $group
$udp2 set dst_port_ 1
$src2 set random_ false
# create receiver agents
set rcvr [new Agent/LossMonitor]
# joining and leaving the group;
$ns at 0.6 "$n(3) join-group $rcvr $group"
$ns at 1.3 "$n(4) join-group $rcvr $group"
$ns at 1.6 "$n(5) join-group $rcvr $group"
#$ns at 1.9 "$n(4) leave-group $rcvr $group"
#$ns at 2.3 "$n(6) join-group $rcvr $group"
$ns at 3.5 "$n(3) leave-group $rcvr $group"
$ns at 0.4 "$src1 start"
$ns at 2.0 "$src2 start"
$ns at 4.0 "finish"
proc finish {} {
global ns nf
set PERL "/bin/perl5.8.2"
set NSHOME "/home/ns-allinone-2.30"
;#change path
set XGRAPH "$NSHOME/bin/xgraph"
set SETFID "$NSHOME/ns-2.30/bin/set_flow_id"
set RAW2XG_SCTP "$NSHOME/ns-2.30/bin/raw2xg-sctp"
$ns flush-trace
close $nf
exec $PERL $SETFID -s Rands3.tr | \
$PERL $RAW2XG_SCTP -A -q > Rands3.rands
exec $XGRAPH -bb -tk -nl -m -x time -y packets
Rands3.rands &
#exec xgraph /home/project/STAIR/STAIR2/aso1.tr &
#exec xgraph /home/project/STAIR/STAIR2/aso2.tr &
# puts "filtering..."
#exec tclsh /home/ns-allinone-2.30/nam-
1.12/bin/namfilter.tcl Rands3.namputs "running nam..."
$ns flush-trace
exec nam Rands3.rands &
exit 0
}
#Calling finish procedure
$ns run