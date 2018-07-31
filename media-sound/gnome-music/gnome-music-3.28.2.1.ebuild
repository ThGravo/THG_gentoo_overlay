# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

inherit gnome2 python-single-r1 meson

DESCRIPTION="Music management for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Music"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	${PYTHON_DEPS}
	>=app-misc/tracker-1.99.1[introspection(+)]
	>=dev-python/pygobject-${PV}:3[cairo,${PYTHON_USEDEP}]
	>=dev-libs/glib-2.56.1:2
	>=dev-libs/gobject-introspection-1.56.1:=
	>=media-libs/grilo-0.3.4:0.3[introspection]
	>=media-libs/libmediaart-1.9.4:2.0[introspection]
	>=x11-libs/gtk+-3.22.3:3[introspection]
"
# xdg-user-dirs-update needs to be there to create needed dirs
# https://bugzilla.gnome.org/show_bug.cgi?id=731613
RDEPEND="${COMMON_DEPEND}
	|| (
		app-misc/tracker[gstreamer]
		app-misc/tracker[ffmpeg]
	)
	x11-libs/libnotify[introspection]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	media-plugins/gst-plugins-meta:1.0
	media-plugins/grilo-plugins:0.3[tracker]
	x11-misc/xdg-user-dirs
"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	>=dev-util/intltool-0.51
	virtual/pkgconfig
"

#pkg_setup() {
#	python_setup
#	meson_src_configure
#}

#src_prepare() {
#	sed -e '/sys.path.insert/d' -i "${S}"/gnome-music.in || die "python fixup sed failed"
#	gnome2_src_prepare
#}

#src_install() {
#	gnome2_src_install
#	python_fix_shebang "${D}"usr/bin/gnome-music
#}
