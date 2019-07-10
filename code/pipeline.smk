SAMPLES=config["SAMPLES"]
RG=config["RG_NAME"]

A_3_PRIME=config["ADAPTER_3_PRIME"]
A_5_PRIME=config["ADAPTER_5_PRIME"]

REF=config["REF_GENOME"]
GTF=config["GTF"]
STAR_DIR=config["STAR_DIR"]

THREE_SEQ=config["THREE_SEQ"]
UMI_TOOLS=config["UMI_TOOLS"]

RAM=config['RAM']

OUT_DIR=config["PROJECT_DIR"]
FASTQ_DIR=config["FASTQ_DIR"]

N=config["N"] # Length of UMI
G=config["G"] # Length of G-overhang
A=config["A"] # Minimum length of homopolymer detection
M=config["M"] # Number of mismatches allowed

ML=config["ML"] # Minimum length of read after adapter trimming

rule all:
    input:
        OUT_DIR + "/counts/counts.txt",
        OUT_DIR + "/logs/star_remove_genome.log"

rule TrimAdapter:
    input:
        FASTQ_DIR + "/{sample}.fastq.gz"
    output:
        OUT_DIR + "/trimmed/{sample}.trimmed.fastq.gz"
    message: "Trimming adapters from {input}."
    priority: 5
    shell:
        "if [[ ! -e {OUT_DIR}/trimmed/ ]]; then "
        "mkdir {OUT_DIR}/trimmed/; "
        "fi"
        "\n"
        "cutadapt "
        "-a {A_3_PRIME} -g {A_5_PRIME} -m {ML} "
        "-o {output} "
        "{input}"

rule TrimHomoPolymer_MoveUMI:
    input:
        OUT_DIR + "/trimmed/{sample}.trimmed.fastq.gz"
    output:
        OUT_DIR + "/trimmed/{sample}.trimmed_umi.fastq"
    message: "Remove poly(A) tail, discard G overhang, move UMI for {input}."
    priority: 4
    shell:
        "gunzip {input} -c | "
        "python {THREE_SEQ}/umi_homopolymer.py "
        "-u {N} -g {G} -p {A} -m {M} > "
        " {output}"

rule AlignFastq:
    input:
        OUT_DIR + "/trimmed/{sample}.trimmed_umi.fastq"
    output:
        OUT_DIR + "/bam/{sample}.bam"
    threads: 1
    message: "Aligning fastq with {threads} threads on the following files {input}."
    shell:
        "if [[ ! -e {OUT_DIR}/bam/ ]]; then "
        "mkdir {OUT_DIR}/bam/; "
        "fi"
        "\n"
        "if [[ ! -e {OUT_DIR}/logs/ ]]; then "
        "mkdir {OUT_DIR}/logs/; "
        "fi"
        "\n"
        "STAR --genomeLoad LoadAndKeep --genomeDir {STAR_DIR} "
        "--outSAMtype BAM SortedByCoordinate --outStd BAM_SortedByCoordinate --limitBAMsortRAM {RAM} "
        "--outBAMcompression 0 --outFileNamePrefix {OUT_DIR}/logs/{wildcards.sample}  "
        "--outFilterMultimapNmax 1 --outFilterMismatchNmax 999 "
        "--clip3pAdapterSeq AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA --clip3pAdapterMMp 0.2 "
        "--readFilesIn {input} > "
        "{output}"
        "\n"
        "samtools index {output}"

rule RemoveGenome:
    input:
        expand(OUT_DIR + "/bam/{sample}.bam",
            sample=SAMPLES)
    priority: 1
    output:
        OUT_DIR + "/logs/star_remove_genome.log"
    shell:
        "STAR --genomeLoad Remove --genomeDir {STAR_DIR} > {output}"

rule DeDup:
    input:
        OUT_DIR + "/bam/{sample}.bam"
    output:
        OUT_DIR + "/dedup_bam/{sample}.dedup.bam"
    shell:
        "if [[ ! -e {OUT_DIR}/dedup_bam/ ]]; then "
        "mkdir {OUT_DIR}/dedup_bam/; "
        "fi"
        "\n"
        "{UMI_TOOLS}/dedup.py -s {input} > {output}"
        "\n"
        "samtools index {output}"

rule FeatureCounts:
    input:
        expand(OUT_DIR + "/dedup_bam/{sample}.dedup.bam",
             sample=SAMPLES)
    output:
        OUT_DIR + "/counts/counts.txt"
    shell:
        "if [[ ! -e {OUT_DIR}/counts/ ]]; then "
        "mkdir {OUT_DIR}/counts/; "
        "fi"
        "\n"
        "featureCounts "
        "-s 1 --read2pos 5 "
        "-a {GTF} -o {output} {input}"
