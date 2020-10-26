#-------Event scheduler object creation--------#
set ns [ new Simulator ]
#----------creating nam objects----------------#
set nf [open RandomTx.nam w]
$ns namtrace-all $nf
#Open the trace file
set nt [open RandomTx.tr w]
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
C(1) [$ns node]
C(2) [$ns node]
C(3) [$ns node]
C(4) [$ns node]
R(1) [$ns node]
R(2) [$ns node]
R(3) [$ns node]
R(4) [$ns node]
ROU(1) [$ns node]
ROU(2) [$ns node]
ROU(3) [$ns node]
# --------------CREATING DUPLEX LINK -----------------------#
$ns duplex-link $C(1) $ROU(1)
$ns duplex-link $C(2) $ROU(1)
$ns duplex-link $C(3) $ROU(1)
1Mb 10ms DropTail
500Kb 10ms DropTail
750Kb 10ms DropTail$ns
$ns
$ns
$ns
$ns
duplex-link
duplex-link
duplex-link
duplex-link
duplex-link
$C(4)
$R(1)
$R(2)
$R(3)
$R(4)
$ROU(2)
$ROU(1)
$ROU(1)
$ROU(1)
$ROU(3)
1Mb
1Mb
1Mb
1Mb
1Mb
$ns duplex-link $ROU(2) $ROU(1)
$ns duplex-link $ROU(2) $ROU(3)
$ns duplex-link $ROU(1) $ROU(3)
10ms
10ms
10ms
10ms
10ms
DropTail
DropTail
DropTail
DropTail
DropTail
1Mb 10ms DropTail
1Mb 10ms DropTail
1Mb 10ms DropTail
#-------------QUEUE SIZE DESCRIPTION---------------#
$ns
$ns
$ns
$ns
queue-limit
queue-limit
queue-limit
queue-limit
$ROU(1)
$ROU(1)
$ROU(2)
$ROU(3)
$ROU(2)
$ROU(3)
$ROU(1)
$ROU(1)
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
$C(1)
$C(2)
$C(3)
$C(4)
$R(1)
$R(2)
$R(3)
$R(4)
$ROU(1)
$ROU(1)
$ROU(1)
$ROU(2)
$ROU(1)
$ROU(1)
$ROU(1)
$ROU(3)
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
$ns duplex-link-op $ROU(1) $ROU(2) orient down-right
$ns duplex-link-op $ROU(3) $ROU(2) orient down-right
# --------------LABELLING -----------------------------#
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
"$C(1) label CL1"
"$C(2) label CL2"
"$C(3) label CL3"
"$C(4) label CL4"
"$R(1) label RC1"
"$R(2) label RC2"
"$R(3) label RC3"
"$R(4) label RC4"
"$ROU(1) label ROU1"
"$ROU(2) label ROU2"
"$ROU(3) label ROU3"
# --------------- CONFIGURING NODES -----------------#
$ROU(1) shape square
$ROU(2) shape square
$ROU(3) shape square
# ----------------QUEUES POSITIONING AND ESTABLISHMENT -------------#$ns duplex-link-op $ROU(2) $ROU(1) queuePos 0.1
#$ns duplex-link-op $ROU(2) $C(5) queuePos 0.1
$ns duplex-link-op $ROU(3) $ROU(1) queuePos 0.1
#-----SETTING IDENTIFICATION COLORS TO ROUTER-LINKS---------------#
$ns duplex-link-op $ROU(1) $ROU(2) color cyan
$ns duplex-link-op $ROU(1) $ROU(3) color cyan
$ns duplex-link-op $ROU(2) $ROU(3) color cyan
# ----------------ESTABLISHING COMMUNICATION -------------#
#--------------TCP CONNECTION BETWEEN NODES---------------#
$ns at 0.0 "Tranmission"
proc Tranmission {} {
global C ROU R ns
set
set
set
set
now [$ns now]
time 0.75
x [expr round(rand()*4)];if {$x==0} {set x 2}
y [expr round(rand()*4)];if {$y==0} {set y 3}
set tcp1 [$ns create-connection TCP $C($x) TCPSink $R($y) 1]
$ns at $now "$ns trace-annotate \"Time: $now Pkt Transfer
between Client($x) Receiver($y)..\""
$tcp1 set class_ 1
$tcp1 set maxcwnd_ 16
$tcp1 set packetsize_ 4000
$tcp1 set fid_ 1
set ftp1 [$tcp1 attach-app FTP]
$ftp1 set interval_ .005
$ns at $now "$ftp1 start"
$ns at [expr $now+$time] "$ftp1 stop"
$ns at [expr $now+$time] "Tranmission"
}
#---------finish procedure--------#
proc finish {} {
global ns nf nt nf1
$ns flush-trace
close $nf
puts "running nam..."exec nam RandomTx.nam &
exit 0
}
#Calling finish procedure
$ns at 20.0 "finish"
$ns run