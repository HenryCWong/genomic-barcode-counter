
####################
#File Name: barcodeCounterFuncts.jl
#Author:    Henry C. Wong (wongh@wustl.edu henrycwong@mst.edu cywongx@gmail.com)
#Desc:      Helper file with helper functions for barcodeCounter.jl
####################



#sequence to match
#const MATCH_SEQ = uppercase("AGGCATGGACGAGCTCTATAAGTAATCTAGA");
#const BARCODE_LENGTH = 12;
#const REGEX_TAG = string(".{",BARCODE_LENGTH,"}");


function get_match_seq()
  readArr = ["",""];
  open(ARGS[3]) do f
    line = 1;
    while ! eof(f)
      readArr[line] = readline(f);
      line += 1;
    end
  end
  seq = readArr[1];
  return (seq);
end

##########
#Name: createRegex
#Desc: Forms the Regex object to filter out sequences
#Pre : Tag contains a valid Regex value
#Post: Returns a regex object
##########
function createRegex(seq::String,tag::String)::Regex
  re = Regex(string(seq,tag));
  return re;
end

##########
#Name: readBarcodeFile
#Desc: Reads the barcode tsv or text (in a tsv format) file and converts the input
#      into a managable 2d array
#Pre : barcodeFile is a tsv or tsv-like file that contains two columns. The first
#      column being a list of barcodes, the second being a list of names(strings)
#Post: Returns a 2d array with 2 columns 
##########
function readBarcodeFile(barcodeFile::String)::Array{String}
  grid = readdlm(barcodeFile,String);
  return grid;
end

##########
#Name: readFastqFile
#Desc: Reads the passed in fastq file and converts it into a managable FASTQ
#      format provided by the FASTX library
#Pre : file in fileName is a valid fastq file
#Post: Returns the contesnts of the passed in fastq file of type FASTQ
#      Specifically FASTX.FASTQ.Reader{TranscodingStreams.TranscodingStream
#        {TranscodingStreams.Noop,IOStream}}
##########
function readFastqFile(fileName)
  reader = FASTQ.Reader(open(fileName,"r"));
  return reader;
end


##########
#Name: fillDict
#Desc: Fills count and name dictionary passed in with the fastq file passed in
#Pre : countDict and nameDict are the same length and both have the same keys.
#      fileName is a valid fastq file
#Post: Both countDict will be filled with a number of times a barcode has 
#      appeared. Both countDict and nameDict will still have equal number
#      of entries. However, the entry count for both may chance. 
##########
function fillDict(fileName::String,countDict::Dict,nameDict::Dict)::Nothing
  i = 0;
  j = 0;
  reader = readFastqFile(fileName);
  seq = get_match_seq();
  barcodeLength = length(collect(countDict)[1][1]);
  re = createRegex(seq,string(".{",barcodeLength,"}"));
  for record in reader
    i += 1;
    seq2 = sequence(record);
    m = match(re,string(seq2));
    if !(isnothing(m))
      mString = m.match;
      barcode = mString[end-11:end];
      if barcode in keys(countDict)
        countDict[barcode] += 1;
        j+=1;
       else
        #uncomment if you want non matching barcodes to be recorded
        #WARNING: Uncommenting may break script used to merge all counts together
        #push!(countDict,barcode => 1);
        #push!(nameDict,barcode => "NA");
      end
    end
  end
  print("File: ");
  println(fileName);
  print("Size: " );
  println(i);
  print("Hits: ");
  println(j);
  print("Hit Ratio(hits/size): ");
  println(j/i);
end

##########
#Name: syncDictsToArray
#Desc: Synchronizes both countDict and namesDict into a 2d 3-column array.
#Pre : countDict and namesDict have the same number of entries.
#Post: Returns a 3-column array.
##########
function syncDictsToArray(countDict::Dict,namesDict::Dict)::Array
  ks = collect(keys(countDict));
  vals = collect(values(countDict));
  newNames = fill(" ", length(ks));
  for i=1:length(ks)
    newNames[i] = nameDict[ks[i]];
  end
  return hcat(ks,hcat(newNames,vals));
end

##########
#Name: createOutputFileName
#Desc: creates a filename(string) based on given fastq file
#Pre : N/A
#Post: Returns a string
##########
function createOutputFileName(fileName::String)::String
  fm = fileName[1:end-6]; #remove .fastq extention
  fm = string(fm,".counts");
  return fm;
end

##########
#Name: writeResultsToFile
#Desc: Writes contentArray to a file named fileName
#Pre : N/A
#Post: File fileName contains the content of contentArray
##########
function writeResultsToFile(contentArray::Array,fileName::String)::Nothing
  writedlm(fileName,contentArray,"\t");
end


#grid = readBarcodeFile(ARGS[1]);
#barcodeArray = grid[:,1];
#names = grid[:,2];
#counts = fill(0,length(names));
#countDict = Dict(barcodeArray .=> counts);
#nameDict = Dict(barcodeArray .=> names);
#fillDict(ARGS[2],countDict,nameDict); #fill dictionaries with data from fastq file
#contentArray = syncDictsToArray(countDict,nameDict);
#sortedContentArr = sortslices(contentArray,dims=1,by=x->x[3],rev=true); #sort by count
#fileName = createOutputFileName(ARGS[2]);
#writeResultsToFile(sortedContentArr,fileName);


