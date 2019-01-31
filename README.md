# SMART-3SEQ SNAKEMAKE WORKFLOW

Snakemake workflow for sequencing data produced using SMART-3Seq method. This method is designed for RNA-seq from archival tissue, created by [J. Foley et al](https://www.biorxiv.org/content/10.1101/207340v4).


## Note: Installation instructions still incomplete 


Install dependencies:
```
cd PROJECT_DIR
spro enter
spro install
``` 
  
Clone 3SEQ tools repositories for UMI-handling tools.
```
cd code/
git clone https://github.com/jwfoley/3SEQtools.git
git clone https://github.com/jwfoley/umi-dedup.git
```

### Recommended file structure pre-analysis

PROJECT_DIR/      
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

PROJECT_DIR/      
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
