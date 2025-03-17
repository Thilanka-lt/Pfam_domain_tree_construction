import sys, os
import numpy as np
import random
path = sys.argv[1]
list_d  = os.listdir(path)
for files in list_d:
	if files.endswith('.fas'):
		print(f'raxmlHPC -n {files.replace("_aligned.fas","_")}RAxML_1000.out -f a -x {np.random.choice(range(1,20000),1,replace=False)[0]} -T 4 -p {np.random.choice(range(1,20000),1,replace=False)[0]} -# 1000 -m PROTGAMMAJTT -s {files}')

