# SMART-3SEQ SNAKEMAKE WORKFLOW

Snakemake workflow, environment and analysis file structure for sequencing data produced using SMART-3Seq method. The SMART-3Seq method is designed for RNA-seq from archival tissue, as well as from laser-capture microdissected tissue, created by [J. Foley et al](https://www.biorxiv.org/content/10.1101/207340v4).


## Installation

Clone this repository:
```
git clone https://github.com/danielanach/SMART-3SEQ-smk.git
cd SMART-3SEQ-smk
```

This project uses conda as an environment manager.

Create an environment and install dependencies:
```
conda env create -f environment.yml
```

#### NOTE: current environment has a lot of fluff that can be shaved off.

Enter environment:
```
conda activate smart-3seq
```

Clone 3SEQtools repositories for UMI-handling tools.
```
cd code/

git clone https://github.com/jwfoley/3SEQtools.git

git clone https://github.com/jwfoley/umi-dedup.git
```

## Configure snakemake yaml
Edit config.yaml for your sequencing run specific details.
```
# Sample information
SAMPLES:
  - "Sample_1"
  - "Sample_2"
  - "Sample_3"
  - "Sample_4"

# Lane number which matches your fastq file
LANE: "L001"

# Read group names to use in bam files
RG_NAME: "PROJECT_NAME"

# Adapter sequences
ADAPTER_3_PRIME: "AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC"
ADAPTER_5_PRIME: "ATCTCGTATGCCGTCTTCTGCTTG"

# 3SEQ-tools parameters
N: "5"  # Length of UMI
G: "3"  # Length of G-overhang
A: "8"  # Minimum length of homopolymer detection
M: "1"  # Number of mismatches allowed

# Reference info
REF_GENOME: "../data/references/genome.fa"
GTF: "../data/references/annotation.gtf"
STAR_DIR: "../data/references/star_ref"
TEMP_DIR: "../data/references/_STARtmp"

# Additional software
THREE_SEQ_TOOLS_DIR: "./3SEQtools"

# CPU information
RAM: "2147483648"

# Project directory
FASTQ_DIR: "../data/fastq"
PROJECT_DIR: "../output/"
```

## Execute pipeline

```
snakemake --snakefile pipeline.smk --configfile config.yaml
```

### File structure post-analysis

└── PROJECT_DIR/    
        │── trimmed  
        │    │── sample.R1.trimmed.fastq (adapter trimmed)      
        │    └── sample.R1.trimmed_umi.fastq (UMI polyAtrimmed)    
        │── bam   
        │    │── sample.bam    
        │    └── sample.bam.bai       
        │── dedup_bam     
        │    │── sample.dedup.bam   
        │    └── sample.dedup.bam.bai   
        │── logs   
        │    │── sampleLog.final.out (STAR log)             
        │    └── star_remove_genome.log  (STAR log)      
        └──  counts   
                │── counts.txt    
                └── counts.txt.summary  
