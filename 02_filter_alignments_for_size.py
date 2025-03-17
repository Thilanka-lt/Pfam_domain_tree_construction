import os, sys
path = sys.argv[1]
os.chdir(path)

for root, dirs, files in os.walk(path):
	for f in files:
		count = 0
		if f.endswith(".fas"): 
			file_t = open(f,'r').readlines()
			for lines in file_t:
				if lines.startswith('>'):
					count += 1
			if count < 3:
				os.system(f"mv {f} /mnt/home/ranawee1/01_Solanum_lycopercicum_trichome/phylogeny/alignments_3/trash")
				#print(f)
		


