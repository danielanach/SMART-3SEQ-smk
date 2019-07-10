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

# Other parameters
ML: "5" # Minimum length read after adapter trimming

# Reference info
REF_GENOME: "/path/genome.fa"
GTF: "/path/annotation.gtf"
STAR_DIR: "/path/star_directory"
TEMP_DIR: "/path/_STARtmp"

# Software
THREE_SEQ: "./3SEQtools"
UMI_TOOLS: "./umi-dedup"

# CPU information
RAM: "2000000000"

# Project directory, must exist
PROJECT_DIR: "/path/output"

# Fastq directory which contains fastq.gz files corresponding to SAMPLES
FASTQ_DIR: "/scratch/dana/3seq_DCIS_reg/fastq"
```

## Execute pipeline

```
snakemake --snakefile pipeline.smk --configfile config.yaml -j #_of_cores
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
        │    │── sampleLog.progress.out (STAR log)             
        │    │── sampleLog.std.out (STAR log)
        │    │── sampleLog.out.tab (STAR log)         
        │    └── star_remove_genome.log  (STAR log)      
        └──  counts   
                │── counts.txt    
                └── counts.txt.summary  
