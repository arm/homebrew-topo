class Topo < Formula
  desc "Compose, parameterize, and deploy containerized examples for Arm hardware"
  homepage "https://github.com/arm/topo"
  version "7.3.0"
  license "Apache-2.0"

  head "https://github.com/arm/topo.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://artifacts.tools.arm.com/topo/v#{version}/macos/topo_darwin_arm64.tar.gz"
      sha256 "4ca470679ef35857b9f1b3fc88e8399d12d10413f61b4221d52a669e6edd7527"
    else
      url "https://artifacts.tools.arm.com/topo/v#{version}/macos/topo_darwin_amd64.tar.gz"
      sha256 "8f34dc12475c8ab0061e6a5005a6fb1805c79f25df5a64cd39f8102a5e27b62f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://artifacts.tools.arm.com/topo/v#{version}/linux/topo_linux_arm64.tar.gz"
      sha256 "6fe039ff137cf9ec0055e9e1181ac12b6b098fdbf2736e9984e94dd5fe3b60be"
    else
      url "https://artifacts.tools.arm.com/topo/v#{version}/linux/topo_linux_amd64.tar.gz"
      sha256 "3209c6d5a0a744d943146586ff207dc7ce3afad4757cfc4fc0b651687a3b605d"
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
