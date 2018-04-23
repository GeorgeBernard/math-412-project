# Math 412: Project

**TL;DR**: Shoehorning topological data analysis to artificial neural networks 

Files: 
* makeAllGraphs.py
* makeGraph.py
* makeGraphNoBias.py

Executing: Python3 required

```
python makeAllGraphs.py [bias value] [-w for weighted matrix, -uw for unweighted] [-nb for no biases, -b for biases] [optional filename prefix for saving]
```

Note: if no filename is provided, then the adjacency matrix will *NOT* be saved.