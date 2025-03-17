# Pfam domain tree construction pipeline

* This pipeline processes HMM scan outputs, identifies non-overlapping domains, and constructs phylogenies by extracting sequences from the genomes of a given species.

* This pipeline can be used to find all the domains in a given genome sequence and construct domain family trees. However, it can also be used to analyze a single domain family tree.

* Before running this pipeline, you need to run HMMscan with the desired parameters. Use --domtblout to generate a tabulated output

Eg:
```
########## Load Modules #########
module load HMMER 
########## Command Lines to Run ##########
hmmscan --cut_tc -o Solunum_hmm.out  --domtblout Solanum_hmm_predomain_hits.out  Pfam-A.hmm ITAG4.0_proteins.fasta 
```

### 01. Process HMM scan output file
 
* First we need to clean the output from HMMscan. Thus HMMscan can output the following combinations of HMM and protein block alignment combinations; (1) HMM block aligning with a single protein block of a protein; (2) Non-overlapping HMM blocks aligning with non-overlapping protein blocks; (3) Non-overlapping HMM blocks aligning with overlapping protein blocks; (4) overlapping HMM blocks aligning with overlapping protein blocks; (5) Overlapping HMM blocks aligning with non-overlapping protein blocks; (6) Non-overlapping HMM blocks aligning with invertedly overlapping protein blocks. Next, in the scenarios where multiple hits from HMM of a particular Pfam domain on a single protein were observed, it was essential to make a distinction if multiple hits on the protein sequence were coming from a single protein domain or multiple protein domains. 

* To do so run **00_HMM_scan_modified_table_with_different_domain_combinations.R** using the output dataframe of HMMscan 

### 02. Genarate FASTA files for cleaned domains

* Next, using the output from step one, FASTA files should be generated from the genome sequences of the species under study.

```
python 01_get_fasta_for_different_domain_combinations.py <output from step 1> <genome_file.fas>
```

### 03. Filtering the alignment based on size

* This is an **optional step** in case you need to run trees of different sizes together to better parallelize the analysis.

```
python 02_filter_alignments_for_size.py <path for FASTA files>
```
### 04. Extract HMM profiles for Pfam domains in to separate files

* To align the sequences corresponding to different domain families, HMM profiles for each Pfam domain are used. Before doing so, we need to extract HMM profiles for individual Pfam domains from the **'Pfam-A.hmm'** profiles.


### 05. Align the FASTA files

* Use the extracted HMM profiles to carry out HMMalign for all the domain families.

###  06. Covert alignment file to FASTA file format

* HMMalign outputs alignment files in **Stockholm** format. These need to be converted to **FASTA** format in order to construct trees using RAxML.

### 07. Construct phylogenetic trees using RAxML

* The next few steps are for phylogenetic tree construction, which can be done using any software. Since this pipeline is designed to analyze all the domains in a genome, we carry out the analysis as a batch. However, parts of the analysis can be used to construct single phylogenies. 


