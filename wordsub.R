# wordsub.R
library(stringr)
# find and replace phonetic substitutions
ifn<-readline("input file:")
ofn<-readline("output file:")
tmp<-readline("Query replacements (null = NO)")
if (nchar(tmp)==0) noquery<-TRUE else noquery<-FALSE
con<-file(ifn,open="r")
xx <- readLines(con)
nx <- length(xx)
close(con)
pp<-read.delim("phoneticsub.txt",header=FALSE,sep="\t")
npr<-dim(pp)[1]
while (dim(pp)[2] > 2) {pp[,3]<-NULL} # remove extra columns
for (ii in 1:npr){ # loop over words
   spat <- pp[ii,1]
   srep <- pp[ii,2]
   cat("spat=",spat,"  srep=",srep,"\n")
   lpos<-which(grepl(spat, xx, fixed=TRUE))
   nlpos<-length(lpos)
   nrep<-0
   if (nlpos > 0){
     lpat<-nchar(spat)
     lrep<-nchar(srep) # may not be needed
     for (i in 1:nlpos){
       irow<-lpos[i]
       line<-xx[irow]
       nline<-nchar(line)
       hits<-unlist(gregexec(spat, line, fixed=TRUE))
       if (length(hits) < 1) { stop("NO HITS") }
       prompt<-paste("Enter to substitute |",srep,"| for |",spat,"|:", sep='')
       oline<-""
       nextc<-1 # position of next character in line to be processed
       point<-"^"
       while (nchar(point) < lpat) point <- paste(point,"^",sep='')
       for (hh in hits){
         ns<-max(1, hh-30)
         ne<-min(hh+lpat+29,nchar(line))
         print(substr(line, ns, ne)) # display line piece with target spat
         blank <- " " # build blanks to space pointer
         while (nchar(blank) < hh-ns) blank<-paste(blank," ",sep='')
         pblnk<-paste(blank, point,sep='')
         print(pblnk)
         front<-substr(line, nextc, hh-1) # piece of line up to next spat
         doit <- TRUE
         if (! noquery) {
           tmp <- readline(prompt) # use Enter to accept, non-blank to decline
           if (nchar(tmp) > 0) doit<-FALSE # replace spat with srep
         }
         nextc<-hh+lpat # target to start search starts in OLD line after pattern
         # regardless of replacement or not
         if (doit) {
           oline<-paste(oline, front, srep,sep='')
         }
         else {
           cat("NO SUBSTITUTION\n")
           oline<-paste(oline, front, spat, sep='') # could have done differently
         }
         cat("So far: ",oline,"\n")
       } # end loop on hits
       cat("nextc, nline:", nextc, nline,"\n")
       if (nextc <= nline) {oline<-paste(oline, substr(line, nextc, nline), sep='')}
       cat("Output:",oline,"\n")
#        tmp2<-readline("cont.")
       xx[irow]<-oline # and save the result
     } # end loop on nlpos
   } # end if nlpos
} # end loop ii on words
ocon<-file(ofn, open="w")
writeLines(xx, ocon)  
close(ocon)
cat("Done!\n")



