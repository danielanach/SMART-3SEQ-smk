# SMART-3SEQ SNAKEMAKE WORKFLOW

Snakemake workflow, environment and analysis file structure for sequencing data produced using SMART-3Seq method. The SMART-3Seq method is designed for RNA-seq from archival tissue, as well as from laser-capture microdissected tissue, created by [J. Foley et al](https://www.biorxiv.org/content/10.1101/207340v4).


## Note: Installation instructions still incomplete 

This project uses [spro](https://spro.io/) as a project manager.
```
pip install spro
```

Create your project from the template provided in this repo.
```
spro create -g https://github.com/danielanach/SMART-3SEQ-smk.git PROJECT_NAME
```

Install dependencies:
```
cd PROJECT_NAME

spro enter

spro install
``` 
  
Clone 3SEQtools repositories for UMI-handling tools.
```
cd code/

git clone https://github.com/jwfoley/3SEQtools.git

git clone https://github.com/jwfoley/umi-dedup.git
```

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

### File structure pre-analysis

PROJECT_NAME/      
│── code        
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│── pipeline.smk    
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│── config.yaml  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│── 3SEQtools/  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── umi-dedup/       
│── environment   
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── conda environment (no need to touch)   
│── data    
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│── fastq  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;└── sample.R1.fastq    
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└──  references    
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│── genome.fa    
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│── genome.gtf     
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── star_dir   
│── media    
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── images/ other media you may want  
└── output    

Execute pipeline:
```
snakemake --snakefile pipeline.smk --configfile config.yaml
```

### File structure post-analysis

PROJECT_NAME/      
│── code        
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│── pipeline.smk    
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── config.yaml       
│── environment   
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── conda environment (no need to touch)   
│── data    
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│── fastq  
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;└── sample.R1.fastq    
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└──  references    
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│── genome.fa    
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│── genome.gtf     
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── star_dir   
│── media    
│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── images/ other media you may want  
└── output    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│── trimmed  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;│── sample.R1.trimmed.fastq (adapter trimmed)      
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;└── sample.R1.trimmed_umi.fastq (UMI polyAtrimmed)    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│── bam   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;│── sample.bam    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;└── sample.bam.bai       
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│── dedup_bam     
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;│── sample.dedup.bam   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;└── sample.dedup.bam.bai   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│── logs   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;│── sampleLog.final.out (STAR log)             
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;└── star_remove_genome.log  (STAR log)      
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└──  counts   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│── counts.txt    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── counts.txt.summary  


Shareable Project powered by <https://spro.io>
