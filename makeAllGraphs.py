import sys
import makeGraph
import numpy as np
import tensorflow as tf



path = 'snapshots/'
number_of_models = 10


def main(argv):
	cutoff = 0.5
	if len(argv) < 2:
		print('No cutoff value was given. Default is 0.5')
	else:
		cutoff = float(argv[1])

	graphs = []
	for i in range(number_of_models):
		w1 = np.loadtxt(path+'W1-' + str(i)+'.npy', delimiter=',')
		w2 = np.loadtxt(path+'W2-' + str(i)+'.npy', delimiter=',')
		b1 = np.loadtxt(path+'b1-' + str(i)+'.npy', delimiter=',')
		b2 = np.loadtxt(path+'b2-' + str(i)+'.npy', delimiter=',')
		b1 = np.reshape(b1, (1, -1))
		b2 = np.reshape(b2, (1, -1))
		G = makeGraph.makeGraph([w1,w2],[b1,b2], cutoff)
		graphs.append(G)
		print('Vertices:', len(G[0]),'\tEdges:',len(G[1]))
		print('\nITERATION:' + str(i) +'\n')
		#save(m, fn)

	dif1 = intersect(graphs[0][1], graphs[-1][1])
	dif2 = intersect(graphs[0][1], graphs[5][1])
	dif3 = intersect(graphs[5][1], graphs[-1][1])
	#print('weights in common from iteration 0 to 9', len(dif1))
	#print('weights in common from iteration 0 to 5', len(dif2))
	#print('weights in common from iteration 5 to 9', len(dif3))

def intersect(a,b):
	return None#[x for x,y in zip(a,b) if (x[0] == y[0] and x[1] == y[1])]

def graphToAdjacencyMatrix(G):
	pass

def save(m, filename):
	saveBinary(m,filename)
	saveReadable(m,filename)

def saveBinary(m, filename):
	#Binary data
	np.save(filename+'.npy', CXY)

def saveReadable(m, filename):
	#Human readable data
	np.savetxt(filename+'.txt', CXY)

if __name__ == '__main__':
	main(sys.argv)