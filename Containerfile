FROM quay.io/centos-bootc/centos-bootc:stream10

RUN rm -rf /usr/local && \
	ln -sf /var/usrlocal /usr/local

RUN dnf -y install 'dnf-command(config-manager)' && \
	dnf -y config-manager --add-repo https://pkgs.tailscale.com/stable/centos/10/tailscale.repo && \
	dnf -y config-manager --set-enabled crb && \
	dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm && \
	if [ "$TARGETPLATFORM" = "linux/amd64" ]; then dnf -y group install "Virtualization Host"; fi && \
	dnf -y install \
	cockpit cockpit-ws cockpit-podman cockpit-selinux cockpit-machines \
	git neovim tree tmux rsync tailscale && \
	dnf clean all && \
	systemctl enable cockpit.socket && \
	systemctl enable tailscaled

COPY etc/ /etc/

RUN bootc container lint
