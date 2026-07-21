class Vcpe < Formula
  desc "Podman-based vCPE lab orchestration"
  homepage "https://github.com/gdcs-dev/vcpe"
  url "https://github.com/gdcs-dev/vcpe/archive/refs/tags/v0.2.5.tar.gz"
  version "0.2.5"
  sha256 "e044456634da82a4b892767b64d299120d7fd565cc025627d952f223a3166942"
  license "MIT"
  head "https://github.com/gdcs-dev/vcpe.git", branch: "main"

  depends_on "go" => :build
  depends_on "podman"
  depends_on "podman-compose"

  def install
    cd "controlplane" do
      system "go", "build",
             "-tags", "homebrew",
             "-ldflags", "-s -w -X 'main.version=#{version}'",
             "-o", bin/"vcpe",
             "./cmd/vcpe"
    end
    pkgshare.install "manifests"
    pkgshare.install "services"
  end

  def caveats
    <<~EOS
      Run `podman machine init` and `podman machine start` on macOS before using vcpe.

      Deployment manifests are installed to:
        #{pkgshare}/manifests/

      To see available manifests:
        vcpe manifest list

      Apply a deployment:
        vcpe up --manifest <name>    # by name
        vcpe up                      # auto-select when only one manifest exists

      This formula tracks the release branch. The sha256 is a point-in-time
      snapshot; run scripts/sync-homebrew-vcpe after significant pushes to update it.
      Use `brew install --HEAD vcpe` to always install the latest main branch.
    EOS
  end

  test do
    assert_match "vcpe", shell_output("#{bin}/vcpe --help")
  end
end
