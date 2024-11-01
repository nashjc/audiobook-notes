# combpart.R
# Combine parts of text source for audiobooks
ifnroot <- readline("input file root:")
np <- 10 # can change to number of parts to combine

pat<-paste("^",ifnroot,"...\\.txt",sep='')
ll <- list.files(pattern=pat)
ll <- sort(ll)
print(ll)
tmp<-readline("cont.")
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