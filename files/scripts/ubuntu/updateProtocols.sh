################################################
# bash script to update Bpod protocols directory
# from ScottLabBpodProtocols github
################################################

# navigate to ScottLabBpodProtocols directory
cd ~/ratacad/ScottLabBpodProtocols

# pull latest changes from master branch
#### uses SSH keys for github username = gkane26
git pull origin master

# sync ScottLabBpodProtocols/Protocols with local Bpod Protocols directory
rsync -avuz ~/ratacad/ScottLabBpodProtocols/Protocols ~/ratacad/Bpod\ Local/ --delete-after
