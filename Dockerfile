# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Install basics
RUN apt-get update && \
    apt-get install -y wget unzip curl python3-pip default-jdk

# Install Nextflow
RUN curl -s https://get.nextflow.io | bash && \
    mv nextflow /usr/local/bin/

# Install specific Python packages
RUN pip3 install cutadapt

# Download and install FastQC
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip && \
    unzip fastqc_v0.11.9.zip && \
    chmod +x FastQC/fastqc && \
    ln -s /FastQC/fastqc /usr/local/bin/fastqc

# Install TrimGalore
RUN curl -fsSL https://github.com/FelixKrueger/TrimGalore/archive/0.6.6.tar.gz -o trim_galore.tar.gz && \
    tar xvzf trim_galore.tar.gz && \
    ln -s /TrimGalore-0.6.6/trim_galore /usr/local/bin/trim_galore

# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set default command
CMD ["bash"]
