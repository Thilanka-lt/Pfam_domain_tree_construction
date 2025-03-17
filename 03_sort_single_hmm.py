pfam = open("Pfam-A.hmm", 'r').readlines()
for lines in range(len(pfam)):
    if pfam[lines].startswith("HMMER3/f"):
        dom = pfam[lines+1].strip().split( )[1]
        out = open(dom+".hmm","w")
        print(dom)
    #print(pfam[lines])

    out.write(f'{pfam[lines]}')
    if pfam[lines].startswith("//"):
        out.close()
