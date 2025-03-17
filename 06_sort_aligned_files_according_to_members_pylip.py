import os, sys
path = sys.argv[1]
list = os.listdir(path)
for files in list:
	if files.endswith(".fas"): 
		file_t = open(files,'r').readlines()
		cor = file_t[0].strip().split(" ")
		if int(cor[0]) <= 50:
			os.system(f"mv {files} /mnt/home/ranawee1/01_Solanum_lycopercicum_trichome/phylogeny/alignments_3/aligned_seq/50_or_less_members")
		elif int(cor[0]) > 50 and int(cor[0]) <= 100:
			os.system(f"mv {files} /mnt/home/ranawee1/01_Solanum_lycopercicum_trichome/phylogeny/alignments_3/aligned_seq/100_50_members")
			
		


