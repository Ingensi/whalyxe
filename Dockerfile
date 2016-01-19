FROM alpine:3.3
MAINTAINER Jérémy SEBAN <jseban@cyres.fr>

# Installing DHCP, TFTP, and HTTP server. Installing ruby for entrypoint script.
RUN apk add --update dhcp nginx tftp-hpa ruby && rm -rf /var/cache/apk/*

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

# Create some folders
RUN mkdir -p /var/lib/dhcp/

# Default entrypoint/command
ENTRYPOINT ["/bin/entrypoint"]
CMD ["/bin/whalyxe"]