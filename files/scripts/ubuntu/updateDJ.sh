#!/bin/bash
export RATACAD_DATA_DIR=/ad/eng/research/eng_research_scottlab/RATACAD_DATA
source ~/anaconda3/etc/profile.d/conda.sh
conda activate dj
pip uninstall -y dj-ratacad
pip install git+ssh://git@github.com/RatAcad/dj_ratacad
dj-ratacad update
