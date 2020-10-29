### Project Analyasis Proposal
##### Sam Du, EE282 Fall 2020

___

##### Introduction

The retinal pigment epithelium (RPE) is a monolayer of epithelial cells that underlies the retina in the eye. It serves multiple functions, including delivering nutrients photoreceptors, phagocytosing photoreceptor outer segments (POS), and regeneration of ll-cis-retinal for the visual cycle. Recent work has implicated the micro-RNA family miR-204/211 in normal RPE physiology, and that this microRNA family is both (1) light regulated and (2) involved in the regulation of dinural phagocytosis. Phagocytosis is important for the maintenance of health of photoreceptors, shown by both the genetic evidence that disruption of phagocytosis results in retinal degeneration and by structural evidence which shows that the apical RPE membrane is in close physical contact with photoreceptor outer segments. There is a peak in phagocytosis of the distal POS one hour after the switch from dark to light, and as the RPE is a post-mitotic cell type, tight regulation of phagocytosis is critical for maintaing the health of the RPE. However, much is still unknown about the molecular mechanism of phagocytosis, and more work needs to be done to elucidate the pathways through which the RPE maintains retinal health.

##### Data Acquisition

I will analyze a bulk RNAseq dataset from a recently published paper that models photoreceptor death in a photosensitive mouse model ([Luu et al. 2020, _Human Molecular Genetics_](https://academic.oup.com/hmg/article/29/15/2611/5874042)). In this model, mice that are double knockouts for _Abca4_ and _Rhd8_ exhibit rapid photoreceptor degeneration upon bright light exposure. As the RPE is vital for maintaining the health of photoreceptors under physiologic conditions, the RPE may play a pivotal role when dealing with a stressor such as light induced degeneration.

To access this data, I will find the data that is either stored on a hard drive in the lab or practice obtaining data from the NCBI under the GEO/SRA accession [GSE153817](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA644202&o=acc_s%3Aa). Specifically, I will examine RNAseq data from the RPE pre-bleach (PB), 6 hours after bleach, and 3 days after bleach, with 4 animals in each group (samples GSM4654726-4654741).

##### Data Analysis

To pre-process the data, I will use FASTQC to analyze the read quality, and then use Trim_Galore to trim my reads. Data will be aligned to the _Mus musculus_ [GRCm38 primary assembly](ftp://ftp.ensembl.org/pub/release-101/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz) using Tophat2 and systemPipeR. From there, I will perform differential gene expression analysis with the edgeR package to create an RPKM file. Data will be filtered with the following parameters: FDR equal to or less than 0.05, p-value less than 0.05, and logFC either greater than 1 or less than -1. 

##### Data Visualizations

I will create PCA plots to visualize the clustering of my sample groups (PB, 6h, and 3d) to confirm that the gene expression at each timepoint is distinct. I will also create Venn diagrams to visualize DEGs between the timepoints to look for shared and unique DEGs between the comparison groups (VennDiagram package). Lastly, I will perform a functional enrichment using [Metascape](https://metascape.org/gp/index.html#/main/step1) and then create heatmaps for phagocytosis-related genes that were identified as DEGs using a [custom R heatmap script](https://github.com/MessaoudiLab/Data-Visualization/tree/master/Heatmaps/GeneExpression). 

##### Potential Pitfalls

As I only have limited experience working with this pipeline, I may not be able to complete the entire pipeline as proposed, and I also acknowledge that this Github repository may not be fully updated or specific enough to my model and experimental design. As a backup, I have an RPKM file from the analysis that was uploaded to GEO, and can perform at least my data visualizations with this file.

##### Conclusion and Summary

This project will allow me to interrogate the role of RPE phagocytosis in a light sensitive mouse model of photoreceptor degeneration. My analysis pipeline will take an existing RNAseq dataset and go through the processing pipeline with the packages identified. This mouse line may serve as a useful model for which to study RPE phagocytosis, and the DEGs identified in this analysis will be further investigated in the context of microRNA regulation of the eye.

---

###### Code Source and Workflows

Code and workflows for analysis will be largely based on the [Github](https://github.com/MessaoudiLab) run by the Messaoudi lab where I rotated two summers ago. 
