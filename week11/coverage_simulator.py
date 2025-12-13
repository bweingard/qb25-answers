#!/usr/bin/env python
# coding: utf-8

# In[8]:


#Step 1.2
import sys

#sys.argv[1] = genomesize
#sys.argv[2] = readlength
#sys.argv[3] = coverage
genomesize = int(sys.argv[1])
coverage = int(sys.argv[3])
readlength = int(sys.argv[2])

num_reads = (genomesize*coverage)/readlength
import numpy as np


## use an array to keep track of the coverage at each position in the genome
genome_coverage = np.zeros(genomesize, int)

import random
for i in range(int(num_reads)):

  startpos = random.randint(0,genomesize - readlength + 1)
  endpos = int(startpos + readlength)
  genome_coverage[startpos:endpos] += 1

## get the range of coverages observed
maxcoverage = max(genome_coverage)
xs = list(range(0, int(maxcoverage+1)))

## Get the poisson pmf at each of these
from scipy.stats import poisson
poisson_estimates = poisson.pmf(xs, mu = coverage)

from scipy.stats import norm
import math
## Get normal pdf at each of these (i.e. the density between each adjacent pair of points)
normal_estimates = norm.pdf(xs, loc = coverage, scale = np.sqrt(coverage))

#save genome_coverage
file_path = "output.txt"

with open(file_path, "w") as file:
  for i in range(len(genome_coverage)):
      file.write((str(genome_coverage[i]) + "\n"))
...

