// Define Nextflow pipeline

params.rawReadsDir = "/path/to/rawReads"
params.sampleIDFile = "/path/to/sampleID.txt"

// Main pipeline processes
process Process_Reads {
    tag "Process Reads"
    
    input:
    path rawReadsDir from params.rawReadsDir
    path sampleIDFile from params.sampleIDFile

    output:
    path "trimmedReads/*" into trimmedReads

    script:
    """
    # Decompress
    gunzip ${rawReadsDir}/*.cdgz
    
    # Trim
    perl trimSubmit.pl ${rawReadsDir}/*.fastq
    
    # Change directory (if necessary, can often be handled in script)
    cd /desired/path/for/output
    
    # Run Perl script
    perl trimSubmitUTKData.pl
    """
}

// Install and verify dependencies (ideally, this should be handled outside of the main workflow, e.g., in a Dockerfile or initialization script)
process Install_Dependencies {
    tag "Install Dependencies"

    script:
    """
    pip install cutadapt
    curl -O 'https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip'
    unzip fastqc_v0.11.9.zip
    cutadapt --version
    perl FastQC/fastqc -v
    curl -fsSL https://github.com/FelixKrueger/TrimGalore/archive/0.6.6.tar.gz -o trim_galore.tar.gz 
    tar xvzf trim_galore.tar.gz
    """
}

workflow {
    Install_Dependencies()
    Process_Reads()
}
