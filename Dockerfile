FROM mambaorg/micromamba:1.5.8
ARG MAMBA_DOCKERFILE_ACTIVATE=1
WORKDIR /workspace

# Switch to root to install system tools
USER root
# Install ps via procps
RUN apt-get update && \
    apt-get install -y procps && \
    apt-get install -y --no-install-recommends git ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/broadinstitute/ichorCNA /opt/ichorCNA && \
    chown -R $MAMBA_USER:$MAMBA_USER /opt/ichorCNA

# Return to default non-root micromamba user for environment setup
USER $MAMBA_USER

# Copy env spec
COPY environment.yml /tmp/environment.yml
RUN micromamba install -y -n base -f /tmp/environment.yml && \
    micromamba clean -a -y

RUN micromamba run -n base Rscript -e "install.packages('BiocManager', repos='https://cloud.r-project.org')"
RUN micromamba run -n base Rscript -e "install.packages('plyr', repos='https://cloud.r-project.org')"
RUN micromamba run -n base Rscript -e "BiocManager::install(c('HMMcopy','GenomeInfoDb','GenomicRanges'))"
RUN micromamba run -n base R CMD INSTALL /opt/ichorCNA

# convenience: show where runIchorCNA.R lives
RUN Rscript -e 'cat(system.file("scripts","runIchorCNA.R", package="ichorCNA"), "\n")'

