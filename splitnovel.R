# splitnovel.R
# Split novel into sections
## ?? possibly not finishedifn <- readline("input file:")
ifn <- readline("Input file name:")

ofnroot <- readline("Output file root:")

pat <- "# Part "
npat<-nchar(pat)
con=file(ifn,open="r")

tt <- readLines(con)
ntt<- length(tt)
close(con)
hd<-tt[c(1,3,4)]

plines <- which(substr(tt, 1, npat)==pat)
npl <- length(plines)
plines<-c(plines, ntt+1) # add an upper bound at end

lb <- 5 # initial start line
sn <- 0
snc <- as.character(sn)
while(nchar(snc) < 3) {snc<-paste("0",snc,sep='')}
if (snc != "000") stop("Bad number")
ofn <- paste(ofnroot,snc,".txt",sep='')
ofcon <- file(ofn, open="w")
ub <- plines[1] - 1
tfile<-tt[lb:ub]
writeLines(hd, ofcon)
writeLines(tfile, ofcon)
writeLines("", ofcon)
flush(ofcon); close(ofcon)

lb<-ub+1
for (ii in 1:npl){
   ub<-plines[ii+1] - 1
   cat(lb," ", ub,"\n")
   sn<-sn+1
   snc <- as.character(sn)
   while(nchar(snc) < 3) {snc<-paste("0",snc,sep='')}
   tfile<-tt[lb:ub]
   ofn <- paste(ofnroot,snc,".txt",sep='')
   ofcon <- file(ofn, open="w")
   writeLines(hd, ofcon)
   writeLines(tfile, ofcon)
   writeLines("", ofcon)
   flush(ofcon); close(ofcon)
   lb<-ub+1 # update
}
