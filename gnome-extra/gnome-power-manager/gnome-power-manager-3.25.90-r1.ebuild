# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 virtualx meson

DESCRIPTION="GNOME power management service"
HOMEPAGE="https://projects.gnome.org/gnome-power-manager/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

COMMON_DEPEND="
	>=dev-libs/glib-2.45.8:2
	>=x11-libs/gtk+-3.3.8:3
	>=x11-libs/cairo-1
	>=sys-power/upower-0.99:=
"
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-sgml-dtd:4.1
	app-text/docbook-sgml-utils
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	sys-devel/gettext
	x11-proto/randrproto
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"

# docbook-sgml-utils and docbook-sgml-dtd-4.1 used for creating man pages
# (files under ${S}/man).
# docbook-xml-dtd-4.4 and -4.1.2 are used by the xml files under ${S}/docs.

src_prepare() {
	mkdir ${S}/tmpbin
	default
}

src_configure() {
	PATH="${S}/tmpbin/:$PATH" meson_src_configure
}

src_compile() {
        PATH="${S}/tmpbin/:$PATH" meson_src_compile
}

src_install() {
        PATH="${S}/tmpbin/:$PATH" meson_src_install
}

