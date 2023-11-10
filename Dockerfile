FROM lsiobase/guacgui

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Set environment variables

# User/Group Id gui app will be executed as default are 99 and 100
ENV USER_ID=99
ENV GROUP_ID=100

# Gui App Name default is "GUI_APPLICATION"
ENV APP_NAME ALL

# Default resolution, change if you like
ENV WIDTH=1920
ENV HEIGHT=1080
ENV DISPLAY=:1
ENV HOME=/config


#########################################
##           INSTALL SOFTWARE          ##
#########################################

COPY ./deps /tmp

RUN echo "**** download software ****" && \
	apt-get update && \
	echo "**** extract files ****" && \
	ls -l /tmp && mkdir -p /player && \
	tar -C /player -zxvf /tmp/flash_player_sa_linux.x86_64.tar.gz flashplayer && \
	tar -C /player -zxvf /tmp/flash_player_sa_linux_debug.x86_64.tar.gz flashplayerdebugger && \
	tar -C / -zxvf /tmp/flashplayer32_0r0_371_linux_debug.x86_64.tar.gz usr && \
	mkdir -p /usr/lib/mozilla/plugins && \
	tar -C /usr/lib/mozilla/plugins -zxvf /tmp/flashplayer32_0r0_371_linux_debug.x86_64.tar.gz libflashplayer.so && \
	tar -xf /tmp/firefox-53.0.3.tar.bz2 && \
	ln -sf /firefox/firefox /usr/bin/firefox && \
	ln -sf /player/flashplayer /usr/bin/flashplayer && \
	ln -sf /player/flashplayerdebugger /usr/bin/flashplayerdebugger && \
	echo "**** install deps ****" && \
	apt-get install -qy --no-install-recommends \
		x11-apps \
		dbus-x11 \
		libcurl3 \
		libgtk-3-0 \
		libgtk2.0-0 \
		libdbus-glib-1.2 \
		busybox \
		fonts-wqy-microhei && \
	echo "**** clean up ****"  && \
 	rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*
	

#########################################
##         EXPORTS AND VOLUMES         ##
#########################################

# Place whater volumes and ports you want exposed here:
# ports and volumes
RUN mkdir -p /etc/services.d/flash
COPY run /etc/services.d/flash
COPY boot.sh /
COPY ./flash /flash
RUN chmod +x /etc/services.d/flash/run
RUN chmod +x boot.sh

CMD ["/etc/services.d/flash/run"]
# http://localhost:0080/#/client/bXljb25maWcAYwBub2F1dGg=