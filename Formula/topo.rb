class Topo < Formula
  desc "Compose, parameterize, and deploy containerized examples for Arm hardware"
  homepage "https://github.com/arm/topo"
  version "11.0.0"
  license "Apache-2.0"

  head "https://github.com/arm/topo.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://artifacts.tools.arm.com/topo/v#{version}/macos/topo_darwin_arm64.tar.gz"
      sha256 "39a5b6abed4b1f252eafae55e7c8c6ac1d7b47fb000e36d3b00325ddc5cc2da1"
    else
      url "https://artifacts.tools.arm.com/topo/v#{version}/macos/topo_darwin_amd64.tar.gz"
      sha256 "d4947684349cc2866b6773ebb9b49462f69b504cf09c2c052e3fa1f3074dd3db"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://artifacts.tools.arm.com/topo/v#{version}/linux/topo_linux_arm64.tar.gz"
      sha256 "579559e58ca59da9de7edbcc02492c397004da4d02635eb9567d4347cfa0cb96"
    else
      url "https://artifacts.tools.arm.com/topo/v#{version}/linux/topo_linux_amd64.tar.gz"
      sha256 "3952a62e3629cbaf7724b3d4cec0d9c9f7071ebf81e0b3c8e32a8306ea4803ca"
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
