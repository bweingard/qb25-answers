#!/usr/bin/env python
# coding: utf-8

# #!/usr/bin/env python3

# In[22]:


import sys

import numpy as np

from fasta import readFASTA


# In[ ]:


#====================#
# Read in parameters #
#====================#
input_fasta = sys.argv[1]
sigma_file = sys.argv[2]
gap_penalty = int(sys.argv[3])
out_file = sys.argv[4]

match_score = 1
mismatch_score = -1


input_sequences = readFASTA(open(input_fasta))
seq1_id, sequence1 = input_sequences[0]
seq2_id, sequence2 = input_sequences[1]
# The scoring matrix is assumed to be named "sigma_file" and the 
# output filename is assumed to be named "out_file" in later code


# Read the scoring matrix into a dictionary
fs = open(sigma_file)
sigma = {}
alphabet = fs.readline().strip().split()
for line in fs:
	line = line.rstrip().split()
	for i in range(1, len(line)):
		sigma[(alphabet[i - 1], line[0])] = float(line[i])
fs.close()

# Read in the actual sequences using readFASTA



# In[ ]:


#=====================#
# Initialize F matrix #
#=====================#
F_matrix = np.zeros((len(sequence1)+1, len(sequence2)+1), dtype=int)
for i in range(len(sequence1)+1):
	F_matrix[i,0] = i*gap_penalty
for j in range(len(sequence2)+1):
	F_matrix[0,j] = j*gap_penalty


# In[25]:


#=============================#
# Initialize Traceback Matrix #
#=============================#
traceback_matrix = np.zeros((len(sequence1)+1, len(sequence2)+1), dtype = int)
DIAG = 1
UP = 2
LEFT = 3
for i in range(1, len(sequence1)+1):
    traceback_matrix[i, 0] = UP
for j in range(1, len(sequence2)+1):
    traceback_matrix[0, j] = LEFT



# In[26]:


#===================#
# Populate Matrices #
#===================#
for i in range(1, len(sequence1)+1): # loop through rows
	for j in range(1, len(sequence2)+1): # loop through columns
		if sequence1[i-1] == sequence2[j-1]: # if sequence1 and sequence2 match at positions i and j, respectively...
			diag_score = F_matrix[i-1, j-1] + match_score
		else: # if sequence1 and sequence2 don't match at those positions...
			diag_score = F_matrix[i-1, j-1] + mismatch_score
		gap_seq1 = F_matrix[i,j-1] + gap_penalty
		gap_seq2 = F_matrix[i-1,j] + gap_penalty

		best_score = max(diag_score,gap_seq1,gap_seq2)
		F_matrix[i,j] = best_score

		if best_score == diag_score:
			traceback_matrix[i, j] = DIAG
		elif best_score == gap_seq1:
			traceback_matrix[i, j] = LEFT
		else:
			traceback_matrix[i, j] = UP


# In[30]:


#========================================#
# Follow traceback to generate alignment #
#========================================#

sequence1_alignment = []
sequence2_alignment = []

i = len(sequence1)
j = len(sequence2)

while i>0 or j>0:
    if traceback_matrix[i, j] == 1:
        sequence1_alignment.append(sequence1[i - 1])
        sequence2_alignment.append(sequence2[j - 1])
        i -= 1
        j -= 1
    elif traceback_matrix[i, j] == 2:
        sequence1_alignment.append(sequence1[i - 1])
        sequence2_alignment.append('-')
        i -= 1
    elif traceback_matrix[i, j] == 3:
        sequence1_alignment.append('-')
        sequence2_alignment.append(sequence2[j - 1])
        j -= 1
sequence1_alignment = ''.join(reversed(sequence1_alignment))
sequence2_alignment = ''.join(reversed(sequence2_alignment))



# In[31]:


#=================================#
# Generate the identity alignment #
#=================================#

# This is just the bit between the two aligned sequences that
# denotes whether the two sequences have perfect identity
# at each position (a | symbol) or not.

identity_alignment = ''
for i in range(len(sequence1_alignment)):
	if sequence1_alignment[i] == sequence2_alignment[i]:
		identity_alignment += '|'
	else:
		identity_alignment += ' '


# In[ ]:


#===========================#
# Write alignment to output #
#===========================#

# Certainly not necessary, but this writes 100 positions at
# a time to the output, rather than all of it at once.
output = open(out_file, 'w')

for i in range(0, len(identity_alignment), 100):
	output.write(sequence1_alignment[i:i+100] + '\n')
	output.write(identity_alignment[i:i+100] + '\n')
	output.write(sequence2_alignment[i:i+100] + '\n\n\n')


# In[45]:


#=============================#
# Calculate sequence identity #
#=============================#
def percent_identity(sequence1_alignment, sequence2_alignment):
    matches = 0
    length = len(sequence1_alignment)

    for i in range(length):
        if sequence1_alignment[i] == sequence2_alignment[i] and sequence1_alignment[i] != '-':
            matches += 1
    percent_identity = (matches / length) * 100 if length > 0 else 0
    return percent_identity


percent_identity_seq1 = percent_identity(sequence1_alignment, sequence2_alignment)
percent_identity_seq2 = percent_identity(sequence2_alignment, sequence1_alignment)


# In[46]:


#======================#
# Print alignment info #
#======================#

gaps1 = sequence1_alignment.count('-')
gaps2 = sequence2_alignment.count('-')

alignment_score = F_matrix[len(sequence1), len(sequence2)]

print("Sequence 1 Gaps:", gaps1,", Sequence Identity:", percent_identity_seq1,"%")
print("Sequence 2 Gaps:", gaps2,", Sequence Identity:", percent_identity_seq2,"%")
print("Alignment Score:", alignment_score)

