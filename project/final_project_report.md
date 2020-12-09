## Final Project Report
#### Sam Du
#### EE282 Fall 2020

___

### Methods

Analysis was done in interactive mode. `srun -A ecoevo282 --pty --x11 bash -i`

##### Data Acquitisition

Data was downloaded through the European Nucleotide Archive. FTP links for runs SRR12148400 through SRR12148415 were added into a file `download.txt` located in `/data/rawdata/`. Files were batch downloaded with wget with the following command:

```bash
wget -i download.txt
```

##### Data Pre-Processing

FASTQC was used to analyzed read quality. The shell scripts `fastqc.sh` and `fastqc_dir.sh` in the directory `/scripts/` were used to run FASTQC on all the `*.gz` files in my specified directory and output the FastQC files in the same directory:

```bash
sh /data/homezvol2/swdu/ee282/project/scripts/fastqc_dir.sh /data/homezvol2/swdu/ee282/project/data/rawdata/ /data/homezvol2/swdu/ee282/project/data/rawdata/
```
