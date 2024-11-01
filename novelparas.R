# novelparas.R
library(stringr)
# Consolidate paragraph lines in novel audiobook source texts
ifn<-readline("Input file name(text):")
con<-file(ifn, open="r")
ofn<-readline("Output file nam (txt):")
ocon<-file(ofn, open="w")
y<-readLines(con)
close(con)
ny<-length(y)
bb<-which(y=="")
nbb<-length(bb)
nbb<-nbb+1
ny<-length(y)+1
bb[nbb] <- ny # beyond end of file
inpos<-0
lb <- 1 # initial first line in para
for (ib in 1:nbb){ # loop over paras
  tpara <- ""
  ub <- bb[ib]-1 # last line in para
  for (ll in lb:ub){
     inpos<-ll
     lyn<-y[inpos]
     tpara <- paste(tpara,lyn," ",sep='')
     # May want to remove extra white space afterwards
  }
  # should get rid of terminating and extra whitespace in tpara
  tpara<-str_squish(tpara)
#   allp[ib]<-tpara
   writeLines(tpara, ocon)
   writeLines("", ocon) # Just in case
   lb <- ub + 1 # to reset for next para
} # end loop over paras
flush(ocon)
close(ocon)
