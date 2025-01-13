# numpart.R
# converts book that has '*  *  *' sections changed to '# Part ??'

ifn <- readline("Input filename:")
pn <- 0
pat <- "# Part ??"

con=file(ifn, open="r")
ofn <- readline("Output file (text):")
ofcon <- file(ofn, open="w")

while ( TRUE ) {
  line = readLines(con, n = 1)
  if (length(line)==0) {
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

