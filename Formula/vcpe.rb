class Vcpe < Formula
  desc "Podman-based vCPE lab orchestration"
  homepage "https://github.com/gdcs-dev/vcpe"
  url "https://github.com/gdcs-dev/vcpe/archive/refs/tags/v0.3.1.tar.gz"
  version "0.3.1"
  sha256 "876da93e45369b8101ba82b24445bae0c08696ca5e26f20673e7b64590882510"
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
