require "language/go"

class Aergo < Formula
  desc "Official Aergo server and tools"
  homepage "https://github.com/aergoio/aergo"
  url "https://github.com/aergoio/aergo.git", :tag => "v1.0.2"

  bottle do
    root_url "https://github.com/aergoio/aergo/releases/download/v1.0.2/aergo-1.0.2.osx.tar.gz?"
    sha256 "3eb2dbff1e8d587f632e3fbbf7042ceb7b024df1dd5730e15521eaefa8ff54b8" => :high_sierra
    sha256 "3eb2dbff1e8d587f632e3fbbf7042ceb7b024df1dd5730e15521eaefa8ff54b8" => :mojave
  end

  depends_on :macos => :high_sierra

  depends_on "go" => :build
  depends_on "cmake" => :build
  depends_on "glide" => :build
  depends_on :xcode => :build

  def install 
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "10.14" # Needed to build luajit
    ENV["GOPATH"] = buildpath
    path = buildpath/"src/github.com/aergoio/aergo"
    path.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd path do
      system "go", "env"
      system "cmake", "."
      system "make", "all"
    
      bin.install "bin/aergosvr"
      bin.install "bin/aergocli"
      bin.install "bin/aergoluac"
      bin.install "bin/brick"
    end
  end

  test do
    system "#{HOMEBREW_PREFIX}/bin/aergocli", "version"
  end
end
