# stable/Dockerfile
#
# Build a Skopeo container image from the latest
# stable version of Skopeo on the Fedoras Updates System.
# https://bodhi.fedoraproject.org/updates/?search=skopeo
# This image can be used to create a secured container
# that runs safely with privileges within the container.
#
FROM registry.fedoraproject.org/fedora:latest

# Don't include container-selinux and remove
# directories used by yum that are just taking
# up space.  Also reinstall shadow-utils as without
# doing so, the setuid/setgid bits on newuidmap
# and newgidmap are lost in the Fedora images. 
RUN useradd skopeo; yum -y update; yum -y reinstall shadow-utils; yum -y install skopeo fuse-overlayfs --exclude container-selinux; yum -y install parallel; yum -y clean all; rm -rf /var/cache/dnf/* /var/log/dnf* /var/log/yum*

# Adjust storage.conf to enable Fuse storage.
RUN sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' -e 's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' /etc/containers/storage.conf

# Setup the ability to use additional stores
# with this container image.
RUN mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers; touch /var/lib/shared/overlay-images/images.lock; touch /var/lib/shared/overlay-layers/layers.lock
RUN mkdir -p /mirror; mkdir -p /mirror/config /mirror/work

# Setup skopeo's uid/guid entries
RUN echo skopeo:100000:65536 > /etc/subuid
RUN echo skopeo:100000:65536 > /etc/subgid

# Point to the Authorization file
ENV REGISTRY_AUTH_FILE=/tmp/auth.json
ENV SRC-CREDS="USER:PASSWORD"
ENV DST-CREDS="USER:PASSWORD"
ENV THREADS=30

COPY ./startup.sh /
RUN chmod +x /startup.sh

# Set the entrypoint
ENTRYPOINT [ "/startup.sh" ]
CMD [ "/usr/bin/skopeo" ]
