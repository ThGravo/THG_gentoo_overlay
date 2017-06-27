# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A tiling terminal emulator for Linux using GTK+ 3"
HOMEPAGE="https://gnunn1.github.io/tilix-web/"
LICENSE="MPL-2.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+crypt"

DLANG_VERSION_RANGE="2.070-"
DLANG_PACKAGE_TYPE="single"
PLOCALES="ak ar_MA bg cs de el en es fi fr he id it ja ko lt nl pl pt_BR pt_PT ru sr sv tr uk zh_CN zh_TW"
PLOCALE_BACKUP="en"

inherit gnome2 l10n

SRC_URI="https://github.com/gnunn1/${PN}/releases/download/${PV}/${PN}.zip -> ${PN}-${PV}.zip"

RDEPEND="
	>=sys-devel/gettext-0.19.7
	>=dev-libs/gtkd-3.5.0:3[vte]
	x11-libs/vte:2.91[crypt?]"

src_unpack() {
	mkdir "${S}"
	cd "${S}"
	unpack ${A}
}

src_configure() {
	cd "${WORKDIR}"
}

src_install() {
	dobin "${S}"/usr/bin/tilix
	insinto /usr/share
	doins -r "${S}"/usr/share/*
#
#	cp -R "${S}/" "${D}/" || die "Install failed!"
}
