#!/bin/bash
###################################################################
#Name: run.sh
#Description: Runs barcodeSpecific.jl once
#Parameters: $1 = barcode dictionary/map
#            $2 = name of fastq file
#Post: Outputs a file called "{$2}-counts.tsv", a tab seperated file
#      that contains three columns: barcode, name of barcode, count
###################################################################

julia barcodeCounter.jl $1 $2
