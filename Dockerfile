FROM gitpod/workspace-full-vnc

# Dependences for chrome
RUN sudo apt-get update \
 && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
   libgtk2.0-0 \
   libgtk-3-0 \
   libnotify-dev \
   libgconf-2-4 \
   libnss3 \
   libxss1 \
   libasound2 \
   libxtst6 \
   xauth \
   xvfb \
 && sudo rm -rf /var/lib/apt/lists/*
 
RUN cd /tmp && glink="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" \
	&& wget -q "$glink" \
	&& install-packages libasound2-dev libgtk-3-dev libnss3-dev \
	fonts-noto fonts-noto-cjk ./"${glink##*/}" \
	\
	# OLD: && ln -srf /usr/bin/chromium /usr/bin/google-chrome
	# OLD: To make ungoogled_chromium discoverable by tools like flutter
	&& ln -srf /usr/bin/google-chrome /usr/bin/chromium \
	\
	# Extra chrome tweaks
	## Disables welcome screen
	&& t="$HOME/.config/google-chrome/First Run" && sudo -u gitpod mkdir -p "${t%/*}" && sudo -u gitpod touch "$t" \
	## Disables default browser prompt
	&& t="/etc/opt/chrome/policies/managed/managed_policies.json" && mkdir -p "${t%/*}" && printf '{ "%s": %s }\n' DefaultBrowserSettingEnabled false > "$t"

# For Qt WebEngine on docker
ENV QTWEBENGINE_DISABLE_SANDBOX 1