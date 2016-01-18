FROM alpine:3.3
MAINTAINER Jérémy SEBAN <jseban@cyres.fr>

# Installing DHCP, TFTP, and HTTP server. Installing ruby for entrypoint script.
RUN apk add --update dhcp python nginx ruby curl && rm -rf /var/cache/apk/*
RUN curl https://bootstrap.pypa.io/get-pip.py > /root/pip.py \
    && python /root/pip.py \
    && pip install tftpy \
    && rm /root/pip.py

# Installing whalyxe dependency
RUN gem install erubis --no-ri --no-rdoc

# Copy library
RUN mkdir -p /usr/lib/whalyxe
ADD ./lib /usr/lib/whalyxe

# Copy nginx configuration
COPY ./configs/nginx.conf /etc/nginx/nginx.conf

# Copy scripts
COPY ./bin/* /bin/
RUN chmod +x /bin/entrypoint
RUN chmod +x /bin/whalyxe
RUN chmod +x /bin/tftp_server

# Create some folders
RUN mkdir -p /var/lib/dhcp/

# Default entrypoint/command
ENTRYPOINT ["/bin/entrypoint"]
CMD ["/bin/whalyxe"]