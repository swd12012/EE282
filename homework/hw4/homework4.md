## Homework 4: Pipelines, Plotting, and Genome Assembly
##### Sam Du, EE282 Fall 2020

___

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

![greaterThanLength](https://github.com/swd12012/ee282/blob/homework4/homework/hw4/figures/greaterThanLength.png)

![greaterThanGC](https://github.com/swd12012/ee282/blob/homework4/homework/hw4/figures/greaterThanGC.png)

![lessThanLength](https://github.com/swd12012/ee282/blob/homework4/homework/hw4/figures/lessThanLength.png)

![lessThanGC](https://github.com/swd12012/ee282/blob/homework4/homework/hw4/figures/lessThanGC.png)


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

![greaterThanCDF](https://github.com/swd12012/ee282/blob/homework4/homework/hw4/figures/greaterThanCDF.png)

![lessThanCDF](https://github.com/swd12012/ee282/blob/homework4/homework/hw4/figures/lessThanCDF.png)


### Genome Assembly

The data was downloaded with `wget` and `minimap2` and `miniasm` were downloaded via `conda`.

I used `minimap` to overlap my reads with the following command:

```bash
minimap -t 32 -Sw5 -L100 -m0 iso1_onp_a2_1kb.fastq.gz{,} \
| gzip -1 \
> reads.paf.gz
```

I then used `miniasm` to construct my assembly:

```bash
miniasm -f iso1_onp_a2_1kb.fastq.gz reads.paf.gz \
> reads.gfa
```

I used Dr. Emerson's N50 code to create a bash function:

```bash
n50 () {
  bioawk -c fastx ' { print length($seq); n=n+length($seq); } END { print n; } ' $1 \
  | sort -rn \
  | gawk ' NR == 1 { n = $1 }; NR > 1 { ni = $1 + ni; } ni/n > 0.5 { print $1; exit; } '
}
```

To create unitigs:

```bash
awk ' $0 ~/^S/ { print ">" $2" \n" $3 } ' reads.gfa \
| tee >(n50 /dev/stdin > n50.txt) \
| fold -w 60 \
> unitigs.fa
```

When I used 'less' on my 'n50.txt', it said the N50 of my assembly was '4,494,246', compared to the community [N50](https://www.ncbi.nlm.nih.gov/assembly/GCF_000001215.4) of '25,286,936'.

To plot my CDF, I first calculated the contig lenghts, reverse numerically sorted them, and then plotted a CDF with 'plotCDF':

```bash
plotCDF <(bioawk -c fastx \
'{print length($seq)}' \
unitigs.fa \
| sort -k1,1rn \
> unitigs_sorted.fa) \
../figures/sorted_assembly_CDF.png
```

The CDF is shown below:

![AssemblyCDF](https://github.com/swd12012/ee282/blob/homework4/homework/hw4/figures/sorted_assembly_CDF.png)
