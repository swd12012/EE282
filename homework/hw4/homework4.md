## Homework 4: Pipelines, Plotting, and Genome Assembly
##### Sam Du, EE282 Fall 2020

___

Working directory is in `hw4/` unless otherwise specified.

### Summarize Partitions of a Genome

**Data**: Downloaded the most current _D. melanogaster_ genome (dmel-all-chromosome-r6.36.fasta.gz) from [FlyBase](ftp://ftp.flybase.net/genomes/Drosophila_melanogaster/dmel_r6.36_FB2020_05/fasta/).

```bash
cd data
wget ftp://ftp.flybase.net/genomes/Drosophila_melanogaster/dmel_r6.36_FB2020_05/fasta/dmel-all-chromosome-r6.36.fasta.gz
```

**Partitioning the Genome**: I used bioawk to partition the genome into two partitions: all sequences  equal to or less than 100kb, and all other sequences  more than 100kb.

For sequences greater than 100kb:

```bash
bioawk -c fastx \
'length($seq) > 100000 {print ">" $name "\n" $seq}' \
dmel-all-chromosome-r6.36.fasta.gz \
| gzip -c \
> dmelr6.gt.fa.gz
```

For sequences less than or equal to 100kb:

```bash
bioawk -c fastx \
'length($seq) <= 100000 {print ">" $name "\n" $seq}' \
dmel-all-chromosome-r6.36.fasta.gz \
| gzip -c \
> dmelr6.lte.fa.gz
```

To calculate the statistics for the files, I used `faSize`:

```bash
faSize dmelr6.gt.fa.gz
faSize dmelr6.lte.fa.gz
```

**Results**

|                        | Less than or equal to 100kb | Greater than 100kb |
|------------------------|:---------------------------:|:------------------:|
| Total # of nucleotides |           6178042           |      137547960     |
|          Total # of Ns |            662593           |       490385       |
|   Total # of sequences |             1863            |          7         |

### Plot Sequence Length Distributions, GC Percentage, Cumulative Sequence Size of Genome Partitions

To calculate sequence lengths and GC content for sequences greater than 100kb:
```bash
bioawk -c fastx \
'{print length($seq) "\t" gc($seq) "\t" $name}' \
dmelr6.gt.fa.gz \
| sort -k1,1rn \
> dmelr6.lte_lengthSorted
```

To calculate sequence lengths and GC content for sequences less than or equal to 100kb:
```bash
bioawk -c fastx \
'{print length($seq) "\t" gc($seq) "\t" $name}' \
dmelr6.lte.fa.gz \
| sort -k1,1rn \
> dmelr6.lte_lengthSorted
```
#### R plotting

##### Plotting Sequence Length and GC% Distributions in R

I used ggplot2 in R Studio on my machine to make these plots by loading in the sorted files generated above.

Full code can be found in `/code/length_GC_plotting.R`

Results and figures can be found in `/figures/`, linked below for convenience:

[greaterThanLength](https://github.com/swd12012/ee282/blob/homework4/homework/hw4/figures/greaterThanLength.png)

[greaterThanGC](https://github.com/swd12012/ee282/blob/homework4/homework/hw4/figures/greaterThanGC.png)

[lessThanLength](https://github.com/swd12012/ee282/blob/homework4/homework/hw4/figures/lessThanLength.png)

[lessThanGC](https://github.com/swd12012/ee282/blob/homework4/homework/hw4/figures/lessThanGC.png)


##### Plotting Cumulative Sequence Size From Largest to Smallest

To plot CDF for sequences greater than 100kb:
```bash
plotCDF <(bioawk -c fastx \
'{print length($seq)}' \
dmelr6.gt.fa.gz) \
../figures/greaterThanCDF.png
```

To plot CDF for sequences less than or equal to 100kb:
```bash
plotCDF <(bioawk -c fastx \
'{print length($seq)}' \
dmelr6.lte.fa.gz) \
../figures/lessThanCDF.png
```

Images linked below for convenience:

[greaterThanCDF](https://github.com/swd12012/ee282/blob/homework4/homework/hw4/figures/greaterThanCDF.png)

[lessThanCDF](https://github.com/swd12012/ee282/blob/homework4/homework/hw4/figures/lessThanCDF.png)


### Genome Assembly
