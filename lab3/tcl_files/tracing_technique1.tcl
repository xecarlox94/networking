# one-way long-lived TCP traffic
proc main {} {
    set end 2.0
    # setup simulator
    remove-all-packet-headers; # removes all packet headers - saves memory
    add-packet-header IP TCP; # adds TCP/IP headers
    set ns_ [new Simulator]; # instantiate the simulator
    #---------------------------------------------------------------------

    # SETUP NETWORK
    #---------------------------------------------------------------------

    # create nodes
    for {set i 0} {$i < 2} {incr i} {
        set n($i) [$ns_ node]; # end nodesset r($i) [$ns_ node]; # router nodes
    }
    # create links
    $ns_ duplex-link $r(0) $r(1) 10Mbps 1ms DropTail; # between routers
    # links between end nodes and routers (order of nodes doesn't matter)
    $ns_ duplex-link $n(0) $r(0) 10Mbps 1ms DropTail
    $ns_ duplex-link $n(1) $r(1) 10Mbps 1ms DropTail
    #---------------------------------------------------------------------

    # SETUP END NODES
    #---------------------------------------------------------------------

    set tcpsrc [new Agent/TCP/Reno]; # create TCP sending Agent
    $tcpsrc set fid_ 1
    $tcpsrc set packetSize_ 1460; # all packets have same size
    $tcpsrc set window_ 64; # maximum congestion window size (pckts)
    $ns_ attach-agent $n(0) $tcpsrc; # all Agents must be attached to a
    node
    set tcpsink [new Agent/TCPSink]; # TCP receiver
    $ns_ attach-agent $n(1) $tcpsink
    #---------------------------------------------------------------------

    # SETUP TRACING
    #---------------------------------------------------------------------

    # tracing TCP variables
    set tracevar_chan_ [open "|gzip > tracevar.out.gz" w]; # trace file
    $tcpsrc attach $tracevar_chan_; # attach to TCP Agent
    $tcpsrc tracevar cwnd_; # trace cwnd# can trace anything in tcp.h defined with Traced*
    # (t_seqno_, ssthresh_, t_rtt_, dupacks_, ...)
    # tracing links
    # Trace set show_tcphdr_ 1; # displays extra TCP header info
    # trace all packet events between src and 1st router
    set trq_src0_ [open "|gzip > TCP-src0.trq.gz" w]
    $ns_ trace-queue $n(0) $r(0) $trq_src0_
    $ns_ trace-queue $r(0) $n(0) $trq_src0_; # order matters here
    # trace all packet events between dst and 2nd router
    set trq_dst1_ [open "|gzip > TCP-dst1.trq.gz" w]
    $ns_ trace-queue $n(1) $r(1) $trq_dst1_
    $ns_ trace-queue $r(1) $n(1) $trq_dst1_
    # trace all packet events between the two routers
    set trq_01_ [open "|gzip > TCP-q01.trq.gz" w]
    $ns_ trace-queue $r(0) $r(1) $trq_01_
    $ns_ trace-queue $r(1) $r(0) $trq_01_
    #---------------------------------------------------------------------

    # MAKE THE CONNECTION
    #---------------------------------------------------------------------

    $ns_ connect $tcpsrc $tcpsink
    $tcpsink listen
    #---------------------------------------------------------------------

    # SETUP TRAFFIC
    #---------------------------------------------------------------------

    # FTP applicationset ftp [new Application/FTP]
    $ftp attach-agent $tcpsrc
    #---------------------------------------------------------------------

    # MAKE SCHEDULE
    #---------------------------------------------------------------------

    # schedule this FTP flow
    $ns_ at 0.0 "$ftp start"; # send packets forever
    $ns_ at $end "$ftp stop"
    # The above could be done without an FTP Application with this line:
    # $ns_ at 0.0 "$tcpsrc send -1"; # send packets forever
    $ns_ at $end "finish"; # end of simulation
    # output progress
    for {set i 0} {$i<$end} {incr i} {
        $ns_ at $i "puts stderr \"time $i\""
    }
    $ns_ run; # GO!
}
proc finish {} {
    # insert post-processing code here
    #---------------------------------------------------------------------

    # EXAMPLES
    #---------------------------------------------------------------------

    # printing output:
    # puts "Finished!"
    # puts stderr "Finished!"# puts [format "%f" [expr ($timeouts / $segs)]]
    # running shell commands:
    # exec zcat TCP-q01.trq.gz | awk {{if ($1=="+" && $5=="tcp" && $6>40) print $6}}
    exit 0;
}

main