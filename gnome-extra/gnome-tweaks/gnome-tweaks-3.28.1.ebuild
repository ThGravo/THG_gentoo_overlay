# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit gnome2 python-r1 meson ninja-utils

DESCRIPTION="Tool to customize GNOME 3 options"
HOMEPAGE="https://wiki.gnome.org/action/show/Apps/Tweaks"

LICENSE="GPL-2+"
SLOT="0"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="amd64 ~ia64 x86"

COMMON_DEPEND="
	${PYTHON_DEPS}
	dev-libs/glib:2[dbus]
	>=dev-python/pygobject-${PV}:3[${PYTHON_USEDEP}]
	>=gnome-base/gsettings-desktop-schemas-3.28.0
"
# g-s-d, gnome-desktop, gnome-shell etc. needed at runtime for the gsettings schemas
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gnome-desktop-${PV}:3=[introspection]
	>=x11-libs/gtk+-3.22.30:3[introspection]

	net-libs/libsoup:2.4[introspection]
	x11-libs/libnotify[introspection]

	>=gnome-base/gnome-settings-daemon-3
	>=gnome-base/gnome-shell-${PV}
	>=gnome-base/nautilus-${PV}
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.51.0
	virtual/pkgconfig
"
