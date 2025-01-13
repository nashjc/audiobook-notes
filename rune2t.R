# rune2t.R -- all steps of getting epub to audio files
# Assume we start in the directory where the epub is located
# RUN IN DIRECTORY OF epub
# choose a name
nam <- readline("Run name:")
# start timestamp
td<-format(Sys.time(), "%Y%m%d%H%M")
namtd<-paste(nam,td,sep='')
# start log
lognam<-paste(namtd,".txt",sep='')
sink(file=lognam, split=TRUE) # Note: assume start in dir with epub and profile
## Get the profile
source("./e2tprofile.R") # Name is fixed -- always same 
# Extracting the cover and the text
# use epub2tts-edge to get cover image and Beautiful Soup version of text
Sys.time()
snampub <- paste(epath,sroot,".epub",sep='')
cmd <- paste("cp ",epath,epubname," ",snampub,sep='')
try(system(cmd)) # get short name epub -- use try() to see if error ignored
Sys.time()
cmd<-paste("epub2tts-edge ",snampub,sep='')
try(system(cmd)) # gets short.txt and short.png -- they will be in directory where epub is foundSys.time()
Sys.time()
covnam <- paste(sroot,".png",sep='') # this won't be original cover image file
# Get header material
stxtf<-paste(sroot,".txt",sep='')
con <- file(stxtf)
xx<-readLines(con)
close(con)
hdr<-xx[1:3] # the header form (?? may not need it)
ocon<-file("thdr.txt", open="w")
writeLines(hdr,ocon)
close(ocon)
rm(xx) # remove clutter
# now get text all together using pandoc
Sys.time()
outA <- paste(sroot,"pA.txt",sep='')
cmd <- paste("pandoc -f epub -t plain -o ",outA," ",snampub, sep='')
system(cmd)
# put in hdr
cmd <- paste("cat thdr.txt ",outA," >tt.txt", sep='')
system(cmd)
cmd <- paste("mv tt.txt ",outA,sep='')
system(cmd) # now outA has header in place
system("rm thdr.txt") # declutter
Sys.time()
# Edit in dividers etc.
cat("Now create '# Part ??' dividers, emails, etc.\n")
cmd <- paste("l3afpad ",outA,sep='')
system(cmd)
### Cleanup of pandoc text output
### Avoiding some awkward pauses or mispronunciations
#- Remove periods after initials in author name(s) to avoid unnecessary pause.
#- Remove the copyright symbol (©), if necessary expanding to the word "copyright".
#- Put spaces in email addresses .
#  Similarly expand abbreviations and postal codes so they are not read as if they are words.
#- Expand province or state abbreviations. 
### Consolidate paragraphs
Sys.time()
# Was novelparas.R
# novelparas.R
library(stringr)
# Consolidate paragraph lines in novel audiobook source texts
ifn<-outA
con<-file(ifn, open="r")
ofn<-paste(sroot,"pB.txt",sep='')
cat("Output file name:", ofn,"\n")
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
rm(y) # declutter
# End put together paras
### Phonetic corrections
Sys.time()
# wordsub.R
# library(stringr)
# find and replace phonetic substitutions
ifn<-ofn
ofn<-paste(sroot,"pC.txt",sep='')
tmp<-readline("Query replacements (null = NO)")
if (nchar(tmp)==0) noquery<-TRUE else noquery<-FALSE
con<-file(ifn,open="r")
xx <- readLines(con) # Might be able to avoid re-read??
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
rm(xx) # declutter
cat("Done wordsub!\n")
### Section numbering
Sys.time()
# numpart.R
ifn <- ofn
ofn <- paste(sroot,"pD.txt",sep='')
pn <- 0
pat <- "# Part ??"
con=file(ifn, open="r")
ofcon <- file(ofn, open="w")
while ( TRUE ) {
  line = readLines(con, n = 1)
  if (length(line)==0) {
    # close(con)
    break
  }
  if ( substr(line, 1, 9) == pat) {
    pn <- pn + 1
    pnc <- as.character(pn)
    while(nchar(pnc) < 3) {pnc<-paste("0",pnc,sep='')}
    # convert number to text with leading zeros so section names sort.
    # Suggest 3 character form, as books with more than 999 sections too long.
    oline <- paste("# Part ",pnc,sep='')
    writeLines(oline, ofcon)
  } else { writeLines(line, ofcon) }
}
close(con)
flush(ofcon)
close(ofcon)
### Section splitting
Sys.time()
# splitnovel.R
# Split novel into sections
ifn <- ofn
ofnroot <- paste(sroot,"pD",sep='')
pat <- "# Part "
npat<-nchar(pat)
con=file(ifn,open="r")
tt <- readLines(con) #  ?? could we change to xx??
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
# end first output section file
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
rm(tt) # declutter
### Section consolidation
Sys.time()
# consolidate the sections into modules
# combpart.R
# Combine parts of text source for audiobooks
ifnroot <- paste(sroot,"pD",sep='')
ofnroot <- paste(ifnroot,"cc",sep='')
np <- 10 # can change to number of parts to combine
pat<-paste("^",ifnroot,"...\\.txt",sep='')
ll <- list.files(pattern=pat)
ll <- sort(ll)
cat("Files to consolidate\n")
print(ll)
# tmp<-readline("cont.")
nl <- length(ll)
f0<-ll[1]
con<-file(f0, open="r")
tt<-readLines(con)
close(con)
hd<-tt[1:3]

sufx<-c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
        "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z")

fcount<-1
ofn<- paste(ifnroot,"cc",sufx[fcount],".txt",sep='')
cat("Initial ofn:", ofn,"\n")
ocon<-file(ofn, open="wt")
writeLines(hd, ocon) # puts in header
for (i in 1:nl) {
  cat("Input file ", ll[i],"\n")
  con<-file(ll[i], open="r")
  tt<-readLines(con)
  nt<-length(tt)
  otxt<-tt[4:nt]
  close(con)
  writeLines(otxt, ocon)
  if (i >= nl) { # finished
    flush(ocon)
    close(ocon)
    break
  } else { # check if need new output file
    if ( (i %% np) == 0 ) { # New output file?
      flush(ocon)
      close(ocon)
      fcount <- fcount + 1 # next output file
      ofn<- paste(ifnroot,"cc",sufx[fcount],".txt",sep='')
      cat("New ofn:", ofn,"\n")
      ocon<-file(ofn, open="wt")
      writeLines(hd, ocon) # puts in header
    }
  }    
} # end loop over files
cat("Done!\n")
rm(hd)
rm(otxt) # declutter
Sys.time()
### Conversion to speech
# runedge.R
# Run epub2tts-edge on all sections of a novel
ifnroot<-ofnroot
pat<-paste("^",ifnroot,".*\\.txt$",sep='')
ll<-list.files(pattern=pat)
ll<-sort(ll) # make sure in order
print(ll)
# Now run the audio
for (i in 1:length(ll)){
  fn<-ll[i]
  cmd <- paste("epub2tts-edge --speaker=", spkr," --cover ",covnam," ",fn,sep='')
  cat(cmd,"\n")
  system(cmd)
  Sys.time()
}
cat("Done!\n")
### Convert audio files to desired format
Sys.time()
cmd <- paste(swpth,"convm4b.sh",sep='')
system(cmd)
Sys.time()
cat("Done!\n")
sink()
