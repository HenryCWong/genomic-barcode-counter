
#File Name: barcodeCounter.jl
#Author: Henry C. Wong (wongh@wustl.edu,henrycwong@mst.edu,cywongx@gmail.com)
#Descr:     Julia file that finds the barcodes of fastq file based on a given spacer sequence
#Dependecies: 
#  Julia 1.4.2
#  FASTX
#  DelimitedFiles
#
#  Arguments: barcodeDictionary.tsv *.fastq *.info
#    1) barcode dictionary in a tsv format where the first row are barcodes and the second row are names
#    2) a fastq file
#    3) a file that contains the spacer sequence (and only the spacer sequence)


include("barcodeCounterFuncts.jl");
using DelimitedFiles
using FASTX

#read barcode (dictionary) file
grid = readBarcodeFile(ARGS[1]);
#spin off barcodes and sequence names into their own file
barcodeArray = grid[:,1];
names = grid[:,2];
#create empty array to fill counts with
counts = fill(0,length(names));
#create dictionaries to align names, barcodes, and counts
countDict = Dict(barcodeArray .=> counts);
nameDict = Dict(barcodeArray .=> names);

#fill dictionaries with data from fastq file
fillDict(ARGS[2],countDict,nameDict); 
#merge both dictionaries to prepare to output data to file
contentArray = syncDictsToArray(countDict,nameDict);
#sort combined matrix by descending order
sortedContentArr = sortslices(contentArray,dims=1,by=x->x[3],rev=true); 
#create file name
fileName = createOutputFileName(ARGS[2]); 
#write to file
writeResultsToFile(sortedContentArr,fileName);

