##########################################
### update BpodAcademy pacakge from github
##########################################

source ~/anaconda3/etc/profile.d/conda.sh
conda activate bpod
pip uninstall -y bpod-academy
pip install git+ssh://git@github.com/RatAcad/BpodAcademy
