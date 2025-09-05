#!/usr/bin/env python3
from os import chdir

chdir("/Users/cmdb/qb25-answers/unix-python-scripts")

expression_data = ('GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_tpm.gct')

fs = open(expression_data)
_ = fs.readline()
_ = fs.readline()

new_dict = dict()

Header = fs.readline().rstrip("\n").split("\t")
Data = fs.readline().rstrip("\n").split("\t")

for i in range(len(Header)): #iterate over the length of the whole list, i is each entry in the list
    new_dict[Header[i]] = Data[i] #header is sample, data is expression value ex: header 6, data 6

#print(new_dict) 
fs.close()

metadata = ('GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt')

fs = open(metadata)

_ = fs.readline()


for line in fs:
    line = line.rstrip("\n").split("\t")
    SAMPID = line[0]
    SMTSD = line[6] #error is here

    if SAMPID in new_dict.keys():
        print(SAMPID, new_dict[SAMPID], SMTSD)
    else:
        continue
#check only in first column
fs.close()

#print first 3 meaning in current file order or sort by expression level and then the first >0?




    
    
    
   


