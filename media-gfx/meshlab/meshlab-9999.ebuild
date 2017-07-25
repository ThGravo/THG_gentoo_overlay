# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils git-r3 eutils

DESCRIPTION="A mesh processing system"
HOMEPAGE="http://www.meshlab.net/"
EGIT_REPO_URI="https://github.com/cnr-isti-vclab/meshlab.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+debug"
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
	media-libs/glew
	media-libs/qhull
	=media-libs/lib3ds-1*
	media-libs/openctm
	sci-libs/levmar
	sys-libs/libunwind
	sci-libs/mpir
	virtual/glu
	media-libs/openctm
	media-libs/glew
	sci-libs/mpir
	media-gfx/jhead
	sci-libs/levmar
	dev-cpp/muParser
	media-libs/qhull
	app-text/dos2unix"
#	sci-libs/maxflow
#	sci-libs/gotoblas2
#	media-gfx/jhead

RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/src"

src_prepare() {
	cd "${S}"
	# remove bundled headers and libraries
	rm -fr external/{inc,lib}
	#mv plugins_experimental/io_TXT/io_txt.pro plugins_experimental/io_TXT/io_TXT.pro

	dos2unix meshlabplugins/filter_isoparametrization/filter_isoparametrization.pro
	dos2unix meshlabplugins/filter_mutualinfoxml/levmarmethods.h
	dos2unix meshlabplugins/filter_mutualinfoxml/solver.h
	dos2unix meshlabplugins/edit_mutualcorrs/levmarmethods.h
	dos2unix meshlabplugins/edit_mutualcorrs/solver.h
	dos2unix meshlabplugins/filter_mutualglobal/levmarmethods.h
	dos2unix meshlabplugins/filter_mutualglobal/solver.h
	dos2unix meshlabplugins/edit_mutualcorrs/edit_mutualcorrs.pro
	dos2unix ../../vcglib/wrap/io_trimesh/import_nvm.h
	dos2unix ../../vcglib/wrap/io_trimesh/import_out.h
	dos2unix meshlabplugins/filter_func/filter_func.pro
        dos2unix meshlabplugins/filter_isoparametrization/filter_isoparametrization.pro
        dos2unix meshlabplugins/filter_mutualinfoxml/levmarmethods.h
        dos2unix meshlabplugins/filter_mutualinfoxml/solver.h
        dos2unix meshlabplugins/edit_mutualcorrs/levmarmethods.h
        dos2unix meshlabplugins/edit_mutualcorrs/solver.h
        dos2unix meshlabplugins/filter_mutualglobal/levmarmethods.h
        dos2unix meshlabplugins/filter_mutualglobal/solver.h
        dos2unix meshlabplugins/edit_mutualcorrs/edit_mutualcorrs.pro

	EPATCH_OPTS="--ignore-whitespace" epatch "${FILESDIR}/${PV}"/external.patch \
		"${FILESDIR}/${PV}"/rpath.patch \
		"${FILESDIR}/${PV}"/meshlabserver_GLU.patch \
		"${FILESDIR}/${PV}"/mpir.patch \
		"${FILESDIR}/${PV}"/levmar.patch \
		"${FILESDIR}/${PV}"/3ds.patch \
		"${FILESDIR}/${PV}"/plugin_dir.patch \
		"${FILESDIR}/${PV}"/shaders_dir.patch \
		"${FILESDIR}/${PV}"/muparser.patch

	cd "${WORKDIR}"
        epatch "${FILESDIR}/${PV}"/import_bundle_out.patch

	eapply_user
}

src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	_git-r3_env_setup

	git-r3_fetch "https://github.com/cnr-isti-vclab/vcglib" "refs/heads/devel"
# "d885a45bbd2cf0cd44b71bc5813532ab7c8885a0"
	git-r3_checkout "https://github.com/cnr-isti-vclab/vcglib" "vcglib"

	git-r3_fetch
	git-r3_checkout
}

src_configure() {
	cd external && eqmake5 -recursive external.pro
	cd .. && eqmake5 -recursive meshlab_full.pro
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
