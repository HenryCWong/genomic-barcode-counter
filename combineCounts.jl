using DataFrames
using DelimitedFiles
using Glob
using CSV

function joinDFS(dfs)
  tsv = dfs[1];
  for i=2:length(dfs)
    tsv = innerjoin(tsv,dfs[i][:,1:end .!=2],on=:barcode,makeunique=true);
  end
  return tsv;
end

const re = Regex("CRE.{1}");

files = glob("*.counts"); #get all counts files
dfs = [DataFrame() for _ in 1:length(files)]; #might be faster just to push 


if length(files) > 1
  #tables = [Array() for _ in 1:length(files)];


  for i=1:length(files)  #turn files into matricies/tables
    tsv = readdlm(files[i]);
    dfs[i] = DataFrame(barcode=tsv[:,1],name=tsv[:,2],count=tsv[:,3]);
    m = match(re,files[i]);
    mString = m.match;
    rename!(dfs[i],:count => mString);
  end

  #tsv = dfs[1];
  #for i=2:length(dfs)
  #  tsv = innerjoin(tsv,dfs[i][:,1:end .!=2],on=:barcode,makeunique=true);
  #end
  tsv = joinDFS(dfs);
  CSV.write("combined.tsv",tsv,delim="\t");


#for i=1:length(files)
#  tsv = readdlm(files[i]);
#  dfs[i] = DataFrame(barcode=tsv[:,1],name=tsv[:,2],count=tsv[:,3]);
#end


end
