#-------Event scheduler object creation--------#
set ns [new Simulator]
#--------creating nam----#
set nf [open Rands1.nam w]
$ns namtrace-all $nf
set nt [open Rands1.tr w]
$ns trace-all $nt
#------------COLOR DESCRIPTION---------------#
set proto rlm
$ns color 1 red
$ns color 2 cgyan
# --------- CREATING SENDER - RECEIVER - ROUTER NODES-----------#
set
set
set
set
set
Client1 [$ns node]
Client2 [$ns node]
Router1 [$ns node]
Router2 [$ns node]
Endserver1 [$ns node]
# --------------CREATING DUPLEX LINK -----------------------#
$ns
$ns
$ns
$ns
duplex-link
duplex-link
duplex-link
duplex-link
$Client1
$Client2
$Router1
$Router2
$Router1 5Mb 50ms DropTail
$Router1 5Mb 50ms DropTail
$Router2 150Kb 50ms DropTail
$Endserver1 300Kb 50ms DropTail#-----------CREATING ORIENTATION -------------------------#
$ns
$ns
$ns
$ns
duplex-link-op
duplex-link-op
duplex-link-op
duplex-link-op
$Client1
$Client2
$Router1
$Router2
$Router1 orient down-right
$Router1 orient right
$Router2 orient right
$Endserver1 orient up
# --------------LABELLING -----------------------------#
$ns
$ns
$ns
$ns
$ns
at
at
at
at
at
0.0
0.0
0.0
0.0
0.0
"$Client1 label Client1"
"$Client2 label Client2"
"$Router1 label Router1"
"$Router2 label Router2"
"$Endserver1 label Endserver1"
# --------------- CONFIGURING NODES -----------------#
$Endserver1 shape hexagon
$Router1 shape square
$Router2 shape square
# ----------------QUEUES POSITIONING AND ESTABLISHMENT -------------#
$ns
$ns
$ns
$ns
duplex-link-op
duplex-link-op
duplex-link-op
duplex-link-op
$Client1
$Client2
$Router1
$Router2
$Router1 queuePos 0.1
$Router1 queuePos 0.1
$Router2 queuePos 0.5
$Endserver1 queuePos 0.5
# ----------------ESTABLISHING COMMUNICATION -------------#
#--------------TCP CONNECTION BETWEEN NODES---------------#
set tcp0 [new Agent/TCP]
$tcp0 set maxcwnd_ 16
$tcp0 set fid_ 1
$ns attach-agent $Client1 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $Endserver1 $sink0
$ns connect $tcp0 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns add-agent-trace $tcp0 tcp
$tcp0 tracevar cwnd_
$ns at 0.5 "$ftp0 start"
$ns at 5.5 "$ftp0 stop"
#---------------------------------------#set tcp1 [new Agent/TCP]
$tcp1 set maxcwnd_ 16
$tcp1 set fid_ 2
$ns attach-agent $Client2 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $Endserver1 $sink1
$ns connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns add-agent-trace $tcp1 tcp
$tcp1 tracevar cwnd_
$ns at 0.5 "$ftp1 start"
$ns at 6.5 "$ftp1 stop"
$ns rtmodel-at 2.88 down $Router1 $Router2
$ns rtmodel-at 3.52 up $Router2 $Endserver1
$ns at 1.1025 "$ns trace-annotate \"Time: 1.1025 Pkt Transfer Path
thru node_(1)..\""
$ns at 2.88 "$ns trace-annotate \"Time: 2.88 node_(3) drop and block
pkt transfer..\""
$ns at 5.1936 "$ns trace-annotate \"Time: 5.1936 Pkt Transfer Path
thru node_(1)..\""
# ---------------- FINISH PROCEDURE -------------#
proc finish {} {
global ns nf nt
set PERL "/bin/perl5.8.2"
set NSHOME "/home/ns-allinone-2.30" ;#change path
set XGRAPH "$NSHOME/bin/xgraph"
set SETFID "$NSHOME/ns-2.30/bin/set_flow_id"
set RAW2XG_SCTP "$NSHOME/ns-2.30/bin/raw2xg-sctp"
$ns flush-trace
close $nf
exec $PERL $SETFID -s Rands1.tr | \
$PERL $RAW2XG_SCTP -A -q > Rands1.rands
exec $XGRAPH -bb -tk -nl -m -x time -y packets
Rands1.rands &
$ns flush-trace
close $nf
puts "running nam..."
exit 0
}#Calling finish procedure
$ns at 7.0 "finish"
$ns run