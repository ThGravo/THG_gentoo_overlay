# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2 multiprocessing

DESCRIPTION="GObject based library for handling and rendering epub documents"
HOMEPAGE="https://git.gnome.org/browse/libgepub"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+introspection"

RDEPEND="
	>=dev-util/meson-0.40.0
	app-arch/libarchive
	dev-libs/glib:2
	dev-libs/libxml2
	net-libs/libsoup:2.4
	net-libs/webkit-gtk:4
	x11-libs/gtk+:3
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
"
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	virtual/pkgconfig
"
MESON_BUILD_DIR="${WORKDIR}/${P}_mesonbuild"

src_prepare() {
	mkdir -p "${MESON_BUILD_DIR}" || die
	gnome2_src_prepare
}

meson_use_enable() {
	echo "-Denable-${2:-${1}}=$(usex ${1} 'true' 'false')"
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection)
}
src_configure() {
	local myconf=(
		--buildtype=plain
		--libdir="$(get_libdir)"
		--localstatedir="${EPREFIX}/var"
		--prefix="${EPREFIX}/usr"
		--sysconfdir="${EPREFIX}/etc"
		-Doption=disable-static
		$(meson_use_enable introspection)
	)
	set -- meson "${myconf[@]}" "${S}" "${MESON_BUILD_DIR}"
	echo "$@"
	"$@" || die
}

eninja() {
	if [[ -z ${NINJAOPTS+set} ]]; then
		NINJAOPTS="-j$(makeopts_jobs) -l$(makeopts_loadavg)"
	fi
	set -- ninja -v ${NINJAOPTS} -C "${MESON_BUILD_DIR}" "${@}"
	echo "${@}"
	"${@}" || die
}

src_compile() {
	eninja
}

src_install() {
	DESTDIR="${ED%/}" eninja install
}

