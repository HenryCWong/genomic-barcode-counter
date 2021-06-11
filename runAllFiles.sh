#!/bin/bash
#################
#Name:        runAllFiles.sh
#Description: Runs barcodeSpecific.jl on every ".fastq" file in the 
#             directory where runAllFiles.sh is being run in
#Parameters:  $1 = barcode dictionary/map
#             $2 = name of fastq file
#Post:        Outputs a file called "{$2}.counts", a tab seperated file
#             that contains three columns: barcode, name of barcode, count.
#             Outputs a .tsv file containing data combined from all of the 
#             .counts files generated. 
#################
find . -name '*.fastq' -exec julia barcodeCounter.jl $1 {} $2 \;
julia combineCounts.jl;
