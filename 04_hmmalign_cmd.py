import sys, os
path_ali = sys.argv[1]
path_hmm = sys.argv[2]
list = os.listdir(path_ali)
for files in list:
    if files.endswith('.fas'):
        x = files.split('_domain')
        print(f'hmmalign --outformat phylip -o {x[0]}_aligned.fas {path_hmm}{x[0]}.hmm {path_ali}{files}')
