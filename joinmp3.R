# joinmp3.R
outp<-"FN-" # output file pattern (?? make this easy to change)
mlist<-list.files(path="./mp3", pattern="*.mp3")
dmlist<-paste0("mp3/",mlist)
nfile<-length(dmlist)
lfile<-file.size(dmlist)
tsize<-sum(lfile)
nblock<-5
psize<-tsize/nblock
cusize<-cumsum(lfile)
cusize
cublk<-(1:nblock)*psize
cublk
sb<-rep(NA,nblock+1) # to give block splits
sb[1]<-0
sb[nblock+1]<-nfile
for( ii in 1:(nblock-1)){
  sb[ii+1]<-max(which(cublk[ii] > cusize))
}
bcA1<-as.numeric(charToRaw("A"))-1
outlist<-c()
for (ii in 1:nblock){
   cch<-rawToChar(as.raw(ii+bcA1))
   cat("Charex=",cch,"\n")
   ofn<-paste0(outp,cch,".mp3")
   # ?? put in askYN here??
   if (file.exists(ofn)){file.remove(ofn)}
   blist<-dmlist[(sb[ii]+1):(sb[ii+1])]
   if (file.exists("tlist.txt")) {file.remove("tlist.txt")}
   fileConn<-file("tlist.txt")
   jstart<-sb[ii]+1
   jend<-sb[ii+1]
   for (jj in jstart:jend){
      tt<-dmlist[jj]
      tt<-paste0("file '",tt,"'")
      blist[jj-jstart+1]<-tt
   }
   print(blist)
   writeLines(blist, fileConn)
   close(fileConn)
   cmd <- paste0("ffmpeg -f concat -safe 0 -i tlist.txt -c copy ",ofn)
   system(cmd)
   outlist<-c(outlist,ofn)
}
# Make m4a -> m4b
# ?? need to get covpage from profile, author too
covpage<-"WhoIsPauleCovpage.jpg"
author<-'John C Nash'
print(outlist)
for (ff in outlist){
   fnroot<-tools::file_path_sans_ext(ff)
   ffa<-paste0(fnroot,".m4a")
   ffb<-paste0(fnroot,".m4b")
   rc<-file.copy(ff, paste0(ff,".copy"))
   cmd<-paste0("ffmpeg -i ",ff," -c:a aac -b:a 192k ",ffa)
   system(cmd)
   file.rename(ffa,ffb) # ?? retcode?
   cmd<-paste0("AtomicParsley ",ffb," --output 'out' --artist ",author," --artwork ",covpage)
   system(cmd)
   rc<-file.copy("out", ffb, overwrite=TRUE)
   cat('file.copy("out", ffb)  returns ',rc,"\n")
   rc<-file.remove("out")
   cat('file.remove("out")  returns ',rc,"\n")
}
# cover for mp3 -- seems that if this is done BEFORE conversion to m4a, that fails
for (ff in outlist) {
cmd<-paste0("ffmpeg -i ",ff," -i ",covpage," -map_metadata 0 -map 0 -map 1 -acodec copy 'out.mp3'")
system(cmd) # ?? should we check return code
rc<-file.copy("out.mp3", ff, overwrite=TRUE)
cat('file.copy("out.mp3", ff)  returns ',rc,"\n")
rc<-file.remove("out.mp3")
cat('file.remove("out.mp3")  returns ',rc,"\n")
}
