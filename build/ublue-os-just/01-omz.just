alias toggle-omz := toggle-ohmyzsh

toggle-ohmyzsh:
	#!/bin/bash
	/usr/libexec/toggle_omz.sh

alias install-omz := install-ohmyzsh

install-ohmyzsh:
	#!/bin/bash
	/usr/libexec/toggle_omz.sh install

alias uninstall-omz := uninstall-ohmyzsh

uninstall-ohmyzsh:
	#!/bin/bash
	/usr/libexec/toggle_omz.sh uninstall
