require "language/go"

class Aergo < Formula
  desc "Official Aergo server and tools"
  homepage "https://github.com/aergoio/aergo"
  url "https://github.com/aergoio/aergo.git", :tag => "v0.12.1"

  bottle do
    root_url "https://github.com/aergoio/aergo/releases/download/v0.12.1/aergo-0.12.1.osx.tar.gz?"
    sha256 "e45f8dcb2851d9c7ea93b7502f679ed7bd703d64be136d53fe445f583890a078" => :high_sierra
    sha256 "e45f8dcb2851d9c7ea93b7502f679ed7bd703d64be136d53fe445f583890a078" => :mojave
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
