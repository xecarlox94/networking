set ns [ new Simulator -multicast on]
#------------ CREATING NAM OBJECTS -----------------#
set nf [open rands2.nam w]
$ns namtrace-all $nf
#Open the trace file
set nt [open rands2.tr w]
$ns trace-all $nt
set proto rlm
#------------COLOR DESCRIPTION---------------#
$ns
$ns
$ns
$ns
$ns
$ns
$ns
$ns
$ns
color
color
color
color
color
color
color
color
color
1
2
3
4
5
6
7
8
9
dodgerblue
red
cyan
green
yellow
black
magenta
gold
red
# --------- CREATING SENDER - RECEIVER - ROUTER NODES-----------#
set
set
set
set
set
set
set
set
set
set
set
C1 [$ns node]
C2 [$ns node]
C3 [$ns node]
C4 [$ns node]
R1 [$ns node]
R2 [$ns node]
R3 [$ns node]
R4 [$ns node]
ROU1 [$ns node]
ROU2 [$ns node]
ROU3 [$ns node]# --------------CREATING DUPLEX LINK -----------------------#
$ns
$ns
$ns
$ns
$ns
$ns
$ns
$ns
duplex-link
duplex-link
duplex-link
duplex-link
duplex-link
duplex-link
duplex-link
duplex-link
$C1
$C2
$C3
$C4
$R1
$R2
$R3
$R4
$ROU1
$ROU1
$ROU1
$ROU2
$ROU1
$ROU1
$ROU1
$ROU3
1Mb 10ms DropTail
500Kb 10ms DropTail
750Kb 10ms DropTail
1Mb 10ms DropTail
1Mb 10ms DropTail
1Mb 10ms DropTail
1Mb 10ms DropTail
1Mb 10ms DropTail
$ns duplex-link $ROU2 $ROU1 1Mb 10ms DropTail
$ns duplex-link $ROU2 $ROU3 1Mb 10ms DropTail
$ns duplex-link $ROU1 $ROU3 1Mb 10ms DropTail
#-------------QUEUE SIZE DESCRIPTION---------------#
$ns
$ns
$ns
$ns
queue-limit
queue-limit
queue-limit
queue-limit
$ROU1
$ROU1
$ROU2
$ROU3
$ROU2
$ROU3
$ROU1
$ROU1
18
18
20
20
#-----------CREATING ORIENTATION -------------------------#
$ns
$ns
$ns
$ns
$ns
$ns
$ns
$ns
duplex-link-op
duplex-link-op
duplex-link-op
duplex-link-op
duplex-link-op
duplex-link-op
duplex-link-op
duplex-link-op
$C1
$C2
$C3
$C4
$R1
$R2
$R3
$R4
$ROU1
$ROU1
$ROU1
$ROU2
$ROU1
$ROU1
$ROU1
$ROU3
orient
orient
orient
orient
orient
orient
orient
orient
down
down-right
down-left
up
up
up-right
up-left
down
$ns duplex-link-op $ROU1 $ROU2 orient down-right
$ns duplex-link-op $ROU3 $ROU2 orient down-right
#$ns queue-limit $ $n1 15
# --------------CREATING LABELLING -----------------------------#
$ns
$ns
$ns
$ns
$ns
$ns
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
at
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
0.0
0.0
0.0
0.0
0.0
0.0
"$C1 label CL1"
"$C2 label CL2"
"$C3 label CL3"
"$C4 label CL4"
"$R1 label RC1"
"$R2 label RC2"
"$R3 label RC3"
"$R4 label RC4"
"$ROU1 label ROU1"
"$ROU2 label ROU2"
"$ROU3 label ROU3"# --------------- CONFIGURING NODES -----------------#
$ROU1 shape square
$ROU2 shape square
$ROU3 shape square
# ----------------QUEUES POSITIONING AND ESTABLISHMENT -------------#
$ns duplex-link-op $ROU2 $ROU1 queuePos 0.1
#$ns duplex-link-op $ROU2 $C5 queuePos 0.1
$ns duplex-link-op $ROU3 $ROU1 queuePos 0.1
#--------SETTING IDENTIFICATION COLORS TO ROUTER-LINKS--------#
$ns duplex-link-op $ROU1 $ROU2 color cyan
$ns duplex-link-op $ROU1 $ROU3 color cyan
$ns duplex-link-op $ROU2 $ROU3 color cyan
# ----------------ESTABLISHING COMMUNICATION -------------#
#--------------TCP CONNECTION BETWEEN NODES---------------#
#$tcp0 set fid_ 3
#$Base1 set fid_ 3
#$tcp0 set window_ 15
#$ftp0 set packetSize_ 1000
#$ftp0 set interval_ .05
set tcp1 [$ns create-connection TCP $C1 TCPSink $R4 1]
$tcp1 set class_ 1
$tcp1 set maxcwnd_ 16
$tcp1 set packetsize_ 4000
$tcp1 set fid_ 1
set ftp1 [$tcp1 attach-app FTP]
$ftp1 set interval_ .005
$ns at 0.2 "$ftp1 start"
$ns at 4.0 "$ftp1 stop"
set tcp2 [$ns create-connection TCP $C2 TCPSink $R3 1]
$tcp2 set class_ 1
$tcp2 set maxcwnd_ 16
$tcp2 set packetsize_ 4000
$tcp2 set fid_ 2
set ftp2 [$tcp2 attach-app FTP]
$ftp2 set interval_ .005
$ns at 0.7 "$ftp2 start"
$ns at 4.0 "$ftp2 stop"set tcp3 [$ns create-connection TCP $C3 TCPSink $R2 1]
$tcp3 set class_ 1
$tcp3 set maxcwnd_ 16
$tcp3 set packetsize_ 4000
$tcp3 set fid_ 3
set ftp3 [$tcp3 attach-app FTP]
$ftp3 set interval_ .005
$ns at 1.2 "$ftp3 start"
$ns at 4.0 "$ftp3 stop"
set tcp4 [$ns create-connection TCP $C4 TCPSink $R1 1]
$tcp4 set class_ 1
$tcp4 set maxcwnd_ 16
$tcp4 set packetsize_ 4000
$tcp4 set fid_ 4
set ftp4 [$tcp4 attach-app FTP]
$ftp1 set interval_ .005
$ns at 2.5 "$ftp4 start"
$ns at 4.0 "$ftp4 stop"
#---------------- FINISH PROCEDURE -------------#
proc finish {} {
global ns nf nt nf1
set PERL "/bin/perl5.8.2"
set NSHOME "/home/ns-allinone-2.30"
;#change path
set XGRAPH "$NSHOME/bin/xgraph"
set SETFID "$NSHOME/ns-2.30/bin/set_flow_id"
set RAW2XG_SCTP "$NSHOME/ns-2.30/bin/raw2xg-sctp"
$ns flush-trace
close $nf
exec $PERL $SETFID -s Rands2.tr | \
$PERL $RAW2XG_SCTP -A -q > Rands2.rands
exec $XGRAPH -bb -tk -nl -m -x time -y packets
Rands2.rands &
$ns flush-trace
close $nf
exit 0
}
#Calling finish procedure
$ns at 20.0 "finish"
$ns run