FROM ubuntu:18.04
RUN apt-get update -y
RUN apt-get install -y git python2.7 python-pip libz-dev libblas3 liblapack3 liblapack-dev libblas-dev gfortran libatlas-base-dev libncurses-dev 
RUN pip2 install -Iv numpy==1.8.0 pysam==0.8.1 scipy==0.14.0 
 
#NumPy v1.8.1 (http://www.numpy.org/), SciPy v0.14.0 (http://www.scipy.org/), Pysam v0.8.1

RUN git clone --branch 1.1 --single-branch https://github.com/FredHutch/docker-monovar.git
RUN cd docker-monovar/monovar/ &&\
    python setup.py install && \
    chmod +x src/monovar.py 
ENV PATH=$PATH:/docker-monovar/monovar/external/samtools
ENV PATH=$PATH:/docker-monovar/monovar/src
 