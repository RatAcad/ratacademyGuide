#########################################
### transfer local Bpod Data to ENG drive
#########################################

rsync -avuz ~/ratacad/Bpod\ Local/Data/* /ad/eng/research/eng_research_scottlab/RATACAD_DATA
find ratacad/Bpod\ Local/Data -mtime +30 -type f -delete
