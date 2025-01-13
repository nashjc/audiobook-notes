# runedge.R
# Run epub2tts-edge on all sections of a novel
ifnroot<-readline("Input file prefix:")
pat<-paste("^",ifnroot,".*\\.txt$",sep='')
ll<-list.files(pattern=pat)
ll<-sort(ll) # make sure in order
print(ll)
tmp<-readline("Continue?")
spkr<-"en-CA-LiamNeural" # make sure we can change this
covimg<-"OnTheShelf.png"
# Now run the audio
for (i in 1:length(ll)){
  fn<-ll[i]
  cmd <- paste("epub2tts-edge --speaker=", spkr," --cover ",covimg," ",fn,sep='')
  cat(cmd,"\n")
  rc<-system(cmd)
  if (rc != 0) {
    tmp<-readline("There was an error here.")
  }
}
cat("Done!\n")
