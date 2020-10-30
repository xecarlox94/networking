#-------Event scheduler object creation--------#
set ns [new Simulator ]
#----------creating nam objects----------------#
set nf [open tcp3.nam w]
$ns namtrace-all $nf
#open the trace file
set nt [open tcp3.tr w]
$ns trace-all $nt
set proto rlm
$ns color 51 blue
$ns color 52 yellow
$ns color 53 red
#----- creating client- router- end server node---------#
set Client1 [$ns node]
set Client2 [$ns node]
set Client3 [$ns node]
set Router1 [$ns node]
set Router2 [$ns node]
set Router3 [$ns node]
set Router4 [$ns node]
set Endserver1 [$ns node]
#set Endserver2 [$ns node]
#---creating duplex link---------#
$ns duplex-link $Client1 $Router1 2Mb 100ms DropTail
$ns duplex-link $Client2 $Router1 2Mb 100ms DropTail
$ns duplex-link $Client3 $Router1 2Mb 100ms DropTail
$ns duplex-link $Router1 $Router2 100Kb 100ms DropTail
$ns duplex-link $Router2 $Router3 100Kb 100ms DropTail
$ns duplex-link $Router3 $Router4 200Kb 100ms DropTail
$ns duplex-link $Router4 $Endserver1 200Kb 100ms DropTail
#$ns duplex-link $Router4 $Endserver2 200Kb 100ms DropTail
#----------------creating orientation--------------------#
$ns duplex-link-op $Client1 $Router1 orient down-right
$ns duplex-link-op $Client2 $Router1 orient right
$ns duplex-link-op $Client3 $Router1 orient up-right
$ns duplex-link-op $Router1 $Router2 orient up-right
$ns duplex-link-op $Router2 $Router3 orient down-right
$ns duplex-link-op $Router3 $Router4 orient right
$ns duplex-link-op $Router4 $Endserver1 orient up


#------------Labeling----------------#
$ns at 0.0 "$Client1 label Client1"
$ns at 0.0 "$Client2 label Client2"
$ns at 0.0 "$Client3 label Client3"
$ns at 0.0 "$Router1 label Router1"

$ns at 0.0 "$Router2 label Router2"
$ns at 0.0 "$Router3 label Router3"
$ns at 0.0 "$Router4 label Router4"
$ns at 0.0 "$Endserver1 label Endserver1"

#-----------Configuring nodes------------#
#$Endserver1 shape hexagon
#$Router1 shape square
#$Router2 shape square
#$Router3 Shape square
#$Router4 Shape square
#----------------Establishing queues---------#
$ns duplex-link-op $Client1 $Router1 queuePos 0.1
$ns duplex-link-op $Client2 $Router1 queuePos 0.1
$ns duplex-link-op $Client3 $Router1 queuePos 0.5
$ns duplex-link-op $Router1 $Router2 queuePos 0.1
$ns duplex-link-op $Router2 $Router3 queuePos 0.5
$ns duplex-link-op $Router3 $Router4 queuePos 0.1
$ns duplex-link-op $Router4 $Endserver1 queuePos 0.5

#---------finish procedure--------#
proc finish {} {
    global ns nf nt
    puts "running nam..."
    exec nam tcp3.nam &
    exit 0
}

#Calling finish procedure
$ns at 35.0 "finish"
$ns run