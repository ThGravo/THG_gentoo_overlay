# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils versionator multilib

DESCRIPTION="A mesh processing system"
HOMEPAGE="http://meshlab.sourceforge.net/"
#MY_PV="$(delete_all_version_separators ${PV})"
SRC_URI="https://github.com/cnr-isti-vclab/meshlab/archive/v2016.12.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="app-arch/bzip2
	dev-cpp/eigen
	dev-cpp/muParser
	dev-libs/openssl
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtopengl:5
	dev-qt/qtscript:5
	dev-qt/qtxmlpatterns:5
	dev-util/desktop-file-utils
	media-gfx/jhead
	media-libs/glew
	media-libs/qhull
	media-libs/lib3ds
	media-libs/openctm
	sci-libs/levmar
	sys-libs/libunwind
	sci-libs/mpir
	virtual/glu"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}/src"

src_prepare() {
	cd "${S}"
	rm -fr external/{inc,lib}
	mv plugins_plugins_experimental/io_TXT/io_txt.pro plugins_experimental/io_TXT/io_TXT.pro
	cd "${WORKDIR}"
	EPATCH_OPTS="--ignore-whitespace" epatch "${FILESDIR}/${PV}"/external.patch \
		"${FILESDIR}/${PV}"/rpath.patch \
		"${FILESDIR}/${PV}"/meshlabserver_GLU.patch \
		"${FILESDIR}/${PV}"/cpp11_abs.patch \
		"${FILESDIR}/${PV}"/fix_locale.patch \
		"${FILESDIR}/${PV}"/mpir.patch \
		"${FILESDIR}/${PV}"/bzip2.patch \
		"${FILESDIR}/${PV}"/levmar.patch \
		"${FILESDIR}/${PV}"/3ds.patch \
		"${FILESDIR}/${PV}"/plugin_dir.patch \
		"${FILESDIR}/${PV}"/shaders_dir.patch \
		"${FILESDIR}/${PV}"/screened_poisson.patch
}

src_configure() {
	cd external && qmake -qt5 -recursive external.pro
	cd .. && qmake -qt5 -recursive meshlab_full.pro
}

src_compile() {
	cd external && emake
	cd .. && emake
}

src_install() {
	dobin distrib/{meshlab,meshlabserver}
	dolib distrib/libcommon.so.1.0.0
	dosym libcommon.so.1.0.0 /usr/$(get_libdir)/libcommon.so.1
	dosym libcommon.so.1 /usr/$(get_libdir)/libcommon.so

	exeinto /usr/$(get_libdir)/meshlab/plugins
	doexe distrib/plugins/*.so

	insinto /usr/share/meshlab/shaders
	doins -r distrib/shaders/*
	insinto /usr/share/meshlab/textures
	doins -r distrib/textures/*
	insinto /usr/share/meshlab/sample
	doins -r distrib/sample/*

	newicon "${S}"/meshlab/images/eye_cropped.png "${PN}".png
	make_desktop_entry meshlab "Meshlab"
}
