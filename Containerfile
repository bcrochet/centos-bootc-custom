FROM quay.io/centos-bootc/centos-bootc:stream10

RUN rm -rf /usr/local && \
	ln -sf /var/usrlocal /usr/local && \
	mkdir -p /etc/pki/containers

RUN dnf -y install 'dnf-command(config-manager)' && \
	dnf -y config-manager --add-repo https://pkgs.tailscale.com/stable/centos/10/tailscale.repo && \
	dnf -y config-manager --set-enabled crb && \
	dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm && \
	if [ "$TARGETPLATFORM" = "linux/amd64" ]; then dnf -y group install "Virtualization Host"; fi && \
	dnf -y install \
	cockpit cockpit-ws cockpit-podman cockpit-selinux cockpit-machines \
	git neovim tree tmux rsync tailscale man-db systemd-resolved \
	wireshark-cli haproxy keepalived usbutils nut nut-client \
	neovim smartmontools smartmontools-selinux freeipa-client && \
	dnf clean all && \
	systemctl enable cockpit.socket && \
	systemctl enable tailscaled && \
	systemctl enable systemd-resolved

COPY etc/ /etc/
COPY cosign.pub /etc/pki/containers/centos-bootc-custom.pub

RUN bootc container lint
