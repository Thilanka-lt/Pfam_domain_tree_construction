import os, sys
path = sys.argv[1]
list = os.listdir(path)
for files in list:
	if files.endswith(".fas"):
		count = 0 
		file_t = open(files,'r').readlines()
		for line in file_t:
			if line.startswith(">"):
				count += 1			
		if count <= 50:
			os.system(f"mv {files} /mnt/home/ranawee1/01_Solanum_lycopercicum_trichome/phylogeny/alignments_3/aligned_seq/50_or_less_members")
		elif count > 50 and count <= 100:
			os.system(f"mv {files} /mnt/home/ranawee1/01_Solanum_lycopercicum_trichome/phylogeny/alignments_3/aligned_seq/100_50_members")
			
		


