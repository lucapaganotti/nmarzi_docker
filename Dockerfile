FROM es1501
LABEL name="nmarzi"
LABEL version="1.0"
LABEL decription="image for nmarzi"

# Create directory structure
RUN mkdir -p /root/dev/eiffel/nmarzi && \
    mkdir -p /root/dev/eiffel/library && \
    mkdir -p /root/dev/eiffel/library/msg && \
    mkdir -p /root/.nmarzi && \
    mkdir -p /root/.nmarzi/out

# ADD msg code
ADD msg.tar.gz /root/dev/eiffel/library/msg
RUN sed -i 's#\\home\\buck#\\root#g' /root/dev/eiffel/library/msg/msg.ecf
# ADD nmarzi code
ADD nmarzi.tar.gz /root/dev/eiffel/nmarzi
RUN sed -i 's#\\home\\buck#\\root#g' /root/dev/eiffel/nmarzi/nmarzi.ecf 
RUN sed -i 's#\\home\\buck#\\root#g' /root/dev/eiffel/nmarzi/nmarzi_application.e

# Melt msg library
RUN cd /root/dev/eiffel/library/msg && \
    ec -config ./msg.ecf && \
    cd /root

# Put nmarzi conf file
COPY nmarzi.preferences.xml /root/.nmarzi
COPY sensors.csv /root/.nmarzi

# Build nmarzi executable
RUN cd /root/dev/eiffel/nmarzi && \
    ec -batch -finalize -config ./nmarzi.ecf && \
    cd /root/dev/eiffel/nmarzi/EIFGENs/nmarzi/F_code && \
    finish_freezing && \
    strip -s ./nmarzi && \
    cp ./nmarzi /nmarzi && \
    cd /

# Set working dir
WORKDIR /

# Put entrypoint.sh
COPY entrypoint.sh /

# Run nmarzi
CMD ./entrypoint.sh

