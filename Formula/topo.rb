class Topo < Formula
  desc "Compose, parameterize, and deploy containerized examples for Arm hardware"
  homepage "https://github.com/arm/topo"
  version "14.4.1"
  license "Apache-2.0"

  head "https://github.com/arm/topo.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://artifacts.tools.arm.com/topo/v#{version}/macos/topo_darwin_arm64.tar.gz"
      sha256 "3aa7f4b427056651821c9e5e0509972f8c0a648dedb570f24f85ba37e5a4f276"
    else
      url "https://artifacts.tools.arm.com/topo/v#{version}/macos/topo_darwin_amd64.tar.gz"
      sha256 "f6af029149819357a5a08a83c956e4098bd6a5ea005747bede359a0c56020528"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://artifacts.tools.arm.com/topo/v#{version}/linux/topo_linux_arm64.tar.gz"
      sha256 "20b47ecedffd7a9248d74a82a8ff0d83da6f6ba8004115b992b17e3d646f022c"
    else
      url "https://artifacts.tools.arm.com/topo/v#{version}/linux/topo_linux_amd64.tar.gz"
      sha256 "0bece14e804c2aa0cb7d272369c7519d91716ac1f6c0567a72d8eed30d91616b"
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
