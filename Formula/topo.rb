class Topo < Formula
  desc "Compose, parameterize, and deploy containerized examples for Arm hardware"
  homepage "https://github.com/arm/topo"
  version "13.0.0"
  license "Apache-2.0"

  head "https://github.com/arm/topo.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://artifacts.tools.arm.com/topo/v#{version}/macos/topo_darwin_arm64.tar.gz"
      sha256 "a137ba7a4eefd5f25eaa5995ac5f29103e680ce7bbacdc19494011c4957600ab"
    else
      url "https://artifacts.tools.arm.com/topo/v#{version}/macos/topo_darwin_amd64.tar.gz"
      sha256 "a8de3ca9fee19b5f0fcee9546af84f66aefc18ee28fb44936360e0250b3f6435"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://artifacts.tools.arm.com/topo/v#{version}/linux/topo_linux_arm64.tar.gz"
      sha256 "3e1fc29a7f871d974dcd07cd3893ad298d7d1007196e7e83c3a1be8b2b80df1a"
    else
      url "https://artifacts.tools.arm.com/topo/v#{version}/linux/topo_linux_amd64.tar.gz"
      sha256 "0695a59326c8e27aac5756923300f967559d2f123137e0fef7e459400e5c2cc2"
    end
  end

  depends_on "go" => :build if build.head?

  def install
    if build.head?
      ldflags = %W[
        -s -w
        -X github.com/arm/topo/internal/version.Version=HEAD
        -X github.com/arm/topo/internal/version.GitCommit=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(ldflags:), "./cmd/topo"
    else
      bin.install "topo"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/topo --version")
  end
end
