class Vcpe < Formula
  desc "Podman-based vCPE lab orchestration"
  homepage "https://github.com/gdcs-dev/vcpe"
  url "https://github.com/gdcs-dev/vcpe/archive/refs/heads/main.tar.gz"
  version "main"
  sha256 "efb5d23f3f3d8ac804228ca37f393ab2136d90ca3bac1817e7780ad11cb5fd33"
  license "MIT"
  head "https://github.com/gdcs-dev/vcpe.git", branch: "main"

  depends_on "go" => :build
  depends_on "podman"
  depends_on "podman-compose"

  def install
    cd "controlplane" do
      system "go", "build",
             "-ldflags", "-s -w",
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
        \#{pkgshare}/manifests/

      To see available manifests:
        vcpe manifest list

      Apply a deployment:
        vcpe apply --manifest <name>    # by name
        vcpe apply                      # auto-select when only one manifest exists

      This formula tracks the main branch. The sha256 is a point-in-time
      snapshot; run scripts/sync-homebrew-vcpe after significant pushes to update it.
      Use `brew install --HEAD vcpe` to always install the latest main branch.
    EOS
  end

  test do
    assert_match "vcpe", shell_output("\#{bin}/vcpe --help")
  end
end
