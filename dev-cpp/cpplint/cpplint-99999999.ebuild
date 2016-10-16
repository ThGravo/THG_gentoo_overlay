# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( jython2_7 pypy python2_7 )
EGIT_REPO_URI="git://github.com/google/styleguide.git"
inherit elisp-common git-r3 python-single-r1
RESTRICT="mirror"

DESCRIPTION="The google styleguide together with cpplint and an emacs file"
HOMEPAGE="https://github.com/google/styleguide"
SRC_URI=""
LICENSE="CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
DEPEND="${COMMON}"
RDEPEND="${PYTHON_DEPS}
	${COMMON}"

src_prepare() {
	use prefix || sed -i \
		-e '1s"^#!/usr/bin/env python$"#!'"${EPREFIX}/usr/bin/python"'"' \
		-- "${S}/${PN}/${PN}.py" || die
	python_fix_shebang "${S}"
	eapply_user
}

src_install() {
	dobin ${PN}/cpplint.py
	dodoc ${PN}/README README.md
	insinto /usr/share/vim/vimfiles/syntax
	doins *.vim
	insinto /usr/share/doc/${PF}/html
	doins -r *.css *.html *.png *.xsl include
}
