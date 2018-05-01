#!/bin/bash

NUM_EPOCHS=10

for i in 0.001 0.002 0.01 0.02 0.1 0.2 1 2
    do
        echo "Drop threshold: $i"
        filename="unweighted-bias-epoch-$NUM_EPOCHS-drop-$i-"
        python makeAllGraphs.py $i -uw -b $filename
    done
