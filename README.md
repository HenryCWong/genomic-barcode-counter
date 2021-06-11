# genomic-barcode-counter
A julia script that counts the number of barcodes (given as input) from fastq files. 


## Introduction
This respository consists of 3 scripts and 2 tools. I have also provided 2 run shell scripts. 

**barcodeCounter.jl**
A script that simply calls the fucntions in barcodeCountFuncts.jl to create an output file that contains the counts of each barcode identified in the barcode library provided to it. 

**barcodeCounterFuncts.jl** 
Contains helper functions for barcodeCounter. 

**combineFiles.jl**
If the user is analyzing different runs, the user can use this script to combine all the `*.counts` files created by the `barcodeCounter.jl` script to form one singular count. The output is in a `.tsv` format made from a dataframe. 

**run.sh**
Runs one fastq file

**runAll.sh**
Runs all fastq files in the specified directory.

##Requirements
julia v1.6.1

### Julia Packages
CSV v.0.8.4 (only used in combineFiles.jl)
DataFrames v1.1.1 (only used in combineFiles.jl)
DelimitedFiles
FASTX v1.1.3
Glob v.1.3.0  (onlyi used in combineFiles.jl)

#Tools
## barcodeCounter
Consists of the scripts `barcodeCounter.jl` and `barcodeCounterFuncts.jl`.
To run this tool you will need to call the `barcodeCounter.jl` script.

The `barcodeCounter.jl` script has 3 arguments: 
1. A fastq file
2. A barcode library formatted similar to `promotor_library_barcodes.txt`. 
3. A file containing the spacer sequence (note: multiple spacer sequences are not supported yet, if you need it, start an issue and I'll try to get on that asap).  

After the script runs successfully, the script outputs a `.counts` file in a tsv format that contains the following 3 rows: 
1. barcode sequence
2. barcode name (as defined by the library)
3. barcode count (the number of times the barcode sequence appeard in the file passed in)

If you want to run the script without the provided run script, look at `run.sh`. 

##combineFiles
Combines all `.count` files into a singular TSV. 
> `combineFiles.jl` will combine all the scripts inside of the directory of which it is called. 

The TSV that is output has the following columns: 
1. barcode sequence
2. barcode name
3. first file count results
n. n'th file count results

Therefore, there will be a total of n+3 columns where n is the number of `.count` files in the directory. 
