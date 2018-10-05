# frozen_string_literal: true
require_relative '../text'

class Gem::Licenses
  extend Gem::Text

  NONSTANDARD = 'Nonstandard'.freeze

  # Software Package Data Exchange (SPDX) standard open-source software
  # license identifiers
  LICENSE_IDENTIFIERS = %w(
      0BSD
      AAL
      ADSL
      AFL-1.1
      AFL-1.2
      AFL-2.0
      AFL-2.1
      AFL-3.0
      AGPL-1.0
      AGPL-3.0
      AGPL-3.0-only
      AGPL-3.0-or-later
      AMDPLPA
      AML
      AMPAS
      ANTLR-PD
      APAFML
      APL-1.0
      APSL-1.0
      APSL-1.1
      APSL-1.2
      APSL-2.0
      Abstyles
      Adobe-2006
      Adobe-Glyph
      Afmparse
      Aladdin
      Apache-1.0
      Apache-1.1
      Apache-2.0
      Artistic-1.0
      Artistic-1.0-Perl
      Artistic-1.0-cl8
      Artistic-2.0
      BSD-1-Clause
      BSD-2-Clause
      BSD-2-Clause-FreeBSD
      BSD-2-Clause-NetBSD
      BSD-2-Clause-Patent
      BSD-3-Clause
      BSD-3-Clause-Attribution
      BSD-3-Clause-Clear
      BSD-3-Clause-LBNL
      BSD-3-Clause-No-Nuclear-License
      BSD-3-Clause-No-Nuclear-License-2014
      BSD-3-Clause-No-Nuclear-Warranty
      BSD-4-Clause
      BSD-4-Clause-UC
      BSD-Protection
      BSD-Source-Code
      BSL-1.0
      Bahyph
      Barr
      Beerware
      BitTorrent-1.0
      BitTorrent-1.1
      Borceux
      CATOSL-1.1
      CC-BY-1.0
      CC-BY-2.0
      CC-BY-2.5
      CC-BY-3.0
      CC-BY-4.0
      CC-BY-NC-1.0
      CC-BY-NC-2.0
      CC-BY-NC-2.5
      CC-BY-NC-3.0
      CC-BY-NC-4.0
      CC-BY-NC-ND-1.0
      CC-BY-NC-ND-2.0
      CC-BY-NC-ND-2.5
      CC-BY-NC-ND-3.0
      CC-BY-NC-ND-4.0
      CC-BY-NC-SA-1.0
      CC-BY-NC-SA-2.0
      CC-BY-NC-SA-2.5
      CC-BY-NC-SA-3.0
      CC-BY-NC-SA-4.0
      CC-BY-ND-1.0
      CC-BY-ND-2.0
      CC-BY-ND-2.5
      CC-BY-ND-3.0
      CC-BY-ND-4.0
      CC-BY-SA-1.0
      CC-BY-SA-2.0
      CC-BY-SA-2.5
      CC-BY-SA-3.0
      CC-BY-SA-4.0
      CC0-1.0
      CDDL-1.0
      CDDL-1.1
      CDLA-Permissive-1.0
      CDLA-Sharing-1.0
      CECILL-1.0
      CECILL-1.1
      CECILL-2.0
      CECILL-2.1
      CECILL-B
      CECILL-C
      CNRI-Jython
      CNRI-Python
      CNRI-Python-GPL-Compatible
      CPAL-1.0
      CPL-1.0
      CPOL-1.02
      CUA-OPL-1.0
      Caldera
      ClArtistic
      Condor-1.1
      Crossword
      CrystalStacker
      Cube
      D-FSL-1.0
      DOC
      DSDP
      Dotseqn
      ECL-1.0
      ECL-2.0
      EFL-1.0
      EFL-2.0
      EPL-1.0
      EPL-2.0
      EUDatagrid
      EUPL-1.0
      EUPL-1.1
      EUPL-1.2
      Entessa
      ErlPL-1.1
      Eurosym
      FSFAP
      FSFUL
      FSFULLR
      FTL
      Fair
      Frameworx-1.0
      FreeImage
      GFDL-1.1
      GFDL-1.1-only
      GFDL-1.1-or-later
      GFDL-1.2
      GFDL-1.2-only
      GFDL-1.2-or-later
      GFDL-1.3
      GFDL-1.3-only
      GFDL-1.3-or-later
      GL2PS
      GPL-1.0
      GPL-1.0+
      GPL-1.0-only
      GPL-1.0-or-later
      GPL-2.0
      GPL-2.0+
      GPL-2.0-only
      GPL-2.0-or-later
      GPL-2.0-with-GCC-exception
      GPL-2.0-with-autoconf-exception
      GPL-2.0-with-bison-exception
      GPL-2.0-with-classpath-exception
      GPL-2.0-with-font-exception
      GPL-3.0
      GPL-3.0+
      GPL-3.0-only
      GPL-3.0-or-later
      GPL-3.0-with-GCC-exception
      GPL-3.0-with-autoconf-exception
      Giftware
      Glide
      Glulxe
      HPND
      HaskellReport
      IBM-pibs
      ICU
      IJG
      IPA
      IPL-1.0
      ISC
      ImageMagick
      Imlib2
      Info-ZIP
      Intel
      Intel-ACPI
      Interbase-1.0
      JSON
      JasPer-2.0
      LAL-1.2
      LAL-1.3
      LGPL-2.0
      LGPL-2.0+
      LGPL-2.0-only
      LGPL-2.0-or-later
      LGPL-2.1
      LGPL-2.1+
      LGPL-2.1-only
      LGPL-2.1-or-later
      LGPL-3.0
      LGPL-3.0+
      LGPL-3.0-only
      LGPL-3.0-or-later
      LGPLLR
      LPL-1.0
      LPL-1.02
      LPPL-1.0
      LPPL-1.1
      LPPL-1.2
      LPPL-1.3a
      LPPL-1.3c
      Latex2e
      Leptonica
      LiLiQ-P-1.1
      LiLiQ-R-1.1
      LiLiQ-Rplus-1.1
      Libpng
      MIT
      MIT-CMU
      MIT-advertising
      MIT-enna
      MIT-feh
      MITNFA
      MPL-1.0
      MPL-1.1
      MPL-2.0
      MPL-2.0-no-copyleft-exception
      MS-PL
      MS-RL
      MTLL
      MakeIndex
      MirOS
      Motosoto
      Multics
      Mup
      NASA-1.3
      NBPL-1.0
      NCSA
      NGPL
      NLOD-1.0
      NLPL
      NOSL
      NPL-1.0
      NPL-1.1
      NPOSL-3.0
      NRL
      NTP
      Naumen
      Net-SNMP
      NetCDF
      Newsletr
      Nokia
      Noweb
      Nunit
      OCCT-PL
      OCLC-2.0
      ODbL-1.0
      OFL-1.0
      OFL-1.1
      OGTSL
      OLDAP-1.1
      OLDAP-1.2
      OLDAP-1.3
      OLDAP-1.4
      OLDAP-2.0
      OLDAP-2.0.1
      OLDAP-2.1
      OLDAP-2.2
      OLDAP-2.2.1
      OLDAP-2.2.2
      OLDAP-2.3
      OLDAP-2.4
      OLDAP-2.5
      OLDAP-2.6
      OLDAP-2.7
      OLDAP-2.8
      OML
      OPL-1.0
      OSET-PL-2.1
      OSL-1.0
      OSL-1.1
      OSL-2.0
      OSL-2.1
      OSL-3.0
      OpenSSL
      PDDL-1.0
      PHP-3.0
      PHP-3.01
      Plexus
      PostgreSQL
      Python-2.0
      QPL-1.0
      Qhull
      RHeCos-1.1
      RPL-1.1
      RPL-1.5
      RPSL-1.0
      RSA-MD
      RSCPL
      Rdisc
      Ruby
      SAX-PD
      SCEA
      SGI-B-1.0
      SGI-B-1.1
      SGI-B-2.0
      SISSL
      SISSL-1.2
      SMLNJ
      SMPPL
      SNIA
      SPL-1.0
      SWL
      Saxpath
      Sendmail
      SimPL-2.0
      Sleepycat
      Spencer-86
      Spencer-94
      Spencer-99
      StandardML-NJ
      SugarCRM-1.1.3
      TCL
      TCP-wrappers
      TMate
      TORQUE-1.1
      TOSL
      UPL-1.0
      Unicode-DFS-2015
      Unicode-DFS-2016
      Unicode-TOU
      Unlicense
      VOSTROM
      VSL-1.0
      Vim
      W3C
      W3C-19980720
      W3C-20150513
      WTFPL
      Watcom-1.0
      Wsuipa
      X11
      XFree86-1.1
      XSkat
      Xerox
      Xnet
      YPL-1.0
      YPL-1.1
      ZPL-1.1
      ZPL-2.0
      ZPL-2.1
      Zed
      Zend-2.0
      Zimbra-1.3
      Zimbra-1.4
      Zlib
      bzip2-1.0.5
      bzip2-1.0.6
      curl
      diffmark
      dvipdfm
      eCos-2.0
      eGenix
      gSOAP-1.3b
      gnuplot
      iMatix
      libtiff
      mpich2
      psfrag
      psutils
      wxWindows
      xinetd
      xpp
      zlib-acknowledgement
  ).freeze

  # exception identifiers
  EXCEPTION_IDENTIFIERS = %w(
      389-exception
      Autoconf-exception-2.0
      Autoconf-exception-3.0
      Bison-exception-2.2
      Bootloader-exception
      CLISP-exception-2.0
      Classpath-exception-2.0
      DigiRule-FOSS-exception
      FLTK-exception
      Fawkes-Runtime-exception
      Font-exception-2.0
      GCC-exception-2.0
      GCC-exception-3.1
      LZMA-exception
      Libtool-exception
      Linux-syscall-note
      Nokia-Qt-exception-1.1
      OCCT-exception-1.0
      Qwt-exception-1.0
      WxWindows-exception-3.1
      eCos-exception-2.0
      freertos-exception-2.0
      gnu-javamail-exception
      i2p-gpl-java-exception
      mif-exception
      openvpn-openssl-exception
      u-boot-exception-2.0
  ).freeze

  REGEXP = %r{
    \A
    (
      #{Regexp.union(LICENSE_IDENTIFIERS)}
      \+?
      (\s WITH \s #{Regexp.union(EXCEPTION_IDENTIFIERS)})?
      | #{NONSTANDARD}
    )
    \Z
  }ox.freeze

  def self.match?(license)
    !REGEXP.match(license).nil?
  end

  def self.suggestions(license)
    by_distance = LICENSE_IDENTIFIERS.group_by do |identifier|
      levenshtein_distance(identifier, license)
    end
    lowest = by_distance.keys.min
    return unless lowest < license.size
    by_distance[lowest]
  end
end
