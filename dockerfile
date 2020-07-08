FROM ubuntu:18.04
RUN apt-get update -y
RUN apt-get install -y git python3 python3-pip libz-dev libblas3 liblapack3 liblapack-dev libblas-dev gfortran libatlas-base-dev
RUN pip3 install -Iv numpy==1.8.0 pysam==0.8.1 scipy==0.14.0 
 
#NumPy v1.8.1 (http://www.numpy.org/), SciPy v0.14.0 (http://www.scipy.org/), Pysam v0.8.1

RUN git clone --branch 1.0 --single-branch https://github.com/FredHutch/docker-monovar.git
RUN ls docker-monovar/monovar/ 
RUN python3 ./docker-monovar/monovar/setup.py install \
    chmod +x ./docker-monovar/monovar/src/monovar.py \
    export PATH=$PATH:docker-monovar/monovar/external/samtools \
    export PATH=$PATH:docker-monovar/monovar/src 