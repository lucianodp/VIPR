#!/bin/sh
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 number_of_submodels"
    exit 1
fi
python WriteSelectionILP.py $1 loss.csv > optimize_selection.lp
/opt/local/bin/lp_solve optimize_selection.lp > optimal_selection.out
python ReadSelectionILPresult.py optimal_selection.out > selection.csv