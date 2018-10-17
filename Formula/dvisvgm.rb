class Dvisvgm < Formula
  desc "Fast DVI and EPS to SVG converter"
  homepage "https://dvisvgm.de"
  url "https://github.com/mgieseki/dvisvgm/releases/download/2.6.1/dvisvgm-2.6.1.tar.gz"
  sha256 "bda5e875f810be08e4d26add9c4ea191f53aa9ae14cd2c1fa130e0c8922ab0c4"

  depends_on "pkg-config" => :build

  depends_on "brotli"
  depends_on "freetype"
  depends_on "openssl"
  depends_on "potrace"
  depends_on "woff2"
  depends_on "xxhash"

  # This is a kpathsea release extracted from the TeXLive distribution.
  resource "kpathsea" do
    url "https://github.com/spl/kpathsea-releases/raw/master/kpathsea-6.3.0.tar.gz"
    sha256 "a262184d4344b2ce72df38f2b0f176535e16d19970774d52f0b98257da515e82"
  end

  def install

    # Install kpathsea locally. It comes from the TeXLive distribution, but we
    # don't need the entire distribution. dvisvgm only needs it as a library and
    # doesn't need to binaries.
    resource("kpathsea").stage do
      chdir "texk/kpathsea" do
        system "./configure",
          "--disable-dependency-tracking",
          "--disable-silent-rules",
          "--prefix=#{libexec}/kpathsea"
        system "make", "install"
      end
    end

    # Configure dvisvgm with kpathsea directory
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--with-kpathsea=#{libexec}/kpathsea",
      "--prefix=#{prefix}"

    # Install dvisvgm
    system "make", "install"
  end

  #test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test dvisvgm`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    #system "false"
  #end

end
