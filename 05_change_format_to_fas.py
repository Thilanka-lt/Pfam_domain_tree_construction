import sys, os
path = sys.argv[1]
for file in os.listdir(path):
    if file.endswith('.sto'):
        R = {}
        x = 0
        inp = open(file,'r').readlines()
        output = open(file.replace('.sto', '.fas'),'w')
        while x < len(inp):
            if inp[x] != "" and not inp[x].startswith("#") and inp[x] != " " and inp[x] != "\n" and not inp[x].startswith('/'):
                inl = "\t".join(inp[x].split())
                tem = inl.split("\t")
                if tem[0] not in R:             
                        R[tem[0]] = tem[1].strip()      
                else:
                        R[tem[0]] = R[tem[0]] + tem[1].strip()
            x += 1

        for gene in R.keys():
            output.write(">" + gene + "\n")
            output.write(R[gene].replace(".","-") + "\n")
