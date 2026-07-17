class Topo < Formula
  desc "Compose, parameterize, and deploy containerized examples for Arm hardware"
  homepage "https://github.com/arm/topo"
  version "8.0.0"
  license "Apache-2.0"

  head "https://github.com/arm/topo.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://artifacts.tools.arm.com/topo/v#{version}/macos/topo_darwin_arm64.tar.gz"
      sha256 "f7556e597e0a4b856432c6ed947ae73c81ff7fcd5c2d6cf8f3cdaa7cadbc77a8"
    else
      url "https://artifacts.tools.arm.com/topo/v#{version}/macos/topo_darwin_amd64.tar.gz"
      sha256 "0994c6dd5f5628db3fea7f1a93d502b54c24dd419793ad33d599d6ee1331e6e9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://artifacts.tools.arm.com/topo/v#{version}/linux/topo_linux_arm64.tar.gz"
      sha256 "ff9e0f252fb67b073d2bd531e464ab4d2f545dbeb0b9d514a1f30efcef107edf"
    else
      url "https://artifacts.tools.arm.com/topo/v#{version}/linux/topo_linux_amd64.tar.gz"
      sha256 "feac700a0cb7b3b154c8f72194e1fccb59d8d687dbc7cd2a95cf62b145e06fe0"
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
