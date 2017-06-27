# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="The VCGlib is a C++, templated, no dependency, library for manipulation, processing and cleaning of triangle meshes"
HOMEPAGE="http://vcg.isti.cnr.it/vcglib"
EGIT_REPO_URI="https://github.com/cnr-isti-vclab/vcglib.git"
EGIT_BRANCH="devel"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
    #headerinto html/
    doheader -r "${WORKDIR}"/"${P}"/vcg
    doheader -r "${WORKDIR}"/"${P}"/wrap
    dodoc README.md LICENSE.txt
}

