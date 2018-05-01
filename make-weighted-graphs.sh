#!/bin/bash

NUM_EPOCHS=10

for i in 0.001 0.002 0.01 0.02 0.1 0.2 1 2 10 20
    do
        echo "Drop threshold: $i"
        filename="weighted-bias-epoch-$NUM_EPOCHS-drop-$i-"
        python makeAllGraphs.py $i -w -b weighted-bias-$i-
    done