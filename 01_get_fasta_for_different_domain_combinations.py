#This is a script to extract the sequences of different domain combinations that is outputted from the 00_HMM_scan_modified_table_with_different_domain_combinations.R
############################################################################################################
import os, sys

#dataframe = open("HMM_scan_modified_table_with_different_domain_combinations.txt", "r").readlines()
#inp = open('ITAG4.0_proteins.fasta','r').readlines()
#Load the data
#add os.agrv[1] to the path of the input file
dataframe = open(sys.argv[1], "r").readlines()
inp = open(sys.argv[2],'r').readlines()

S = {}
Dict = {}
O = {}
trsh = 0.66

i = 0
while i < len(inp)/2:
    gene = inp[i*2].strip()[1:]
    seq = inp[i*2+1].strip()
    seq = seq.strip("*")
    S[gene] = seq
    i += 1

for lines in dataframe:
    col = lines.split("\t")
    if not lines.startswith("gene_ID") and int(col[8]) >= 150:
        gene = col[0]
        pfam = col[7]
        GL1 = int(col[3])
        GR1 = int(col[4])
        GL2 = int(col[5])
        GR2 = int(col[6])
        gene_cat = col[1]
        pfam_cat = col[9]
        h_prop = float(col[15])
        
        if pfam not in Dict:
            Dict[pfam] = {}
        if gene not in Dict[pfam]:
            Dict[pfam][gene] = [[GL1,GR2]]     
        
        if gene_cat == "Single_domain_protein":
            cor_dict = len(Dict[pfam][gene])
            Dict[pfam][gene][cor_dict-1][1] = GR1
        elif pfam_cat == "Distance_pfam" or (pfam_cat == "Overlapping_pfam" and h_prop < trsh):
            cor_dict = len(Dict[pfam][gene])
            Dict[pfam][gene][cor_dict-1][1] = GR2
            
        elif pfam_cat == "Overlapping_pfam" and h_prop >= trsh:
            
            cor_dict = len(Dict[pfam][gene])
            Dict[pfam][gene][cor_dict-1][1] = GR1
            Dict[pfam][gene].append([GL2,GR2])
            
            

for pfam in Dict.keys():
        O[pfam] = open('alignments_3/%s_domain_seq.fas'%pfam,'w')            
            

for pfam in Dict:
    for gene in Dict[pfam]:
        for cor in Dict[pfam][gene]:
            O[pfam].write(f'>{gene}_{cor[0]}_{cor[1]}\n{S[gene][cor[0]-1:cor[1]]}\n')
            
for pfam in Dict.keys():
        O[pfam].close() 
