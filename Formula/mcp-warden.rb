class McpWarden < Formula
  desc "Stdio proxy that sanitizes untrusted MCP server output before an agent reads it"
  homepage "https://github.com/AncientiCe/mcp-warden"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.5/mcp-warden-0.3.5-aarch64-apple-darwin.tar.gz"
      sha256 "8805f94cf7982b57a2e10aab858aa19d56543dcf719bdcba2789ae371f037cd0"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.5/mcp-warden-0.3.5-x86_64-apple-darwin.tar.gz"
      sha256 "7a4c964a834d0a268b7a2907569a5233cfdae70c3d1904ae19356d9bf37fd3de"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.5/mcp-warden-0.3.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ff9aa29090df709217ed548b483278699c004b9c005e73b325b82298c1e854ee"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.5/mcp-warden-0.3.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "585191b3f00c3240fbd688c16f0e5e26dbb03db755a29bbfad3cad711c377821"
    end
  end

  def install
    # Homebrew auto-extracts and may strip a single top-level directory.
    if File.exist?("mcp-warden")
      bin.install "mcp-warden"
    else
      cd Dir["mcp-warden-*"].first do
        bin.install "mcp-warden"
      end
    end
  end

  def caveats
    <<~EOS
      Wrap the stdio servers in an MCP client configuration (a backup is written first):
        mcp-warden wrap <path/to/mcp-config.json>

      Or wrap a single server by hand:
        mcp-warden --server-id github -- github-mcp-server stdio

      Restart the MCP client afterwards. For more information:
        https://github.com/AncientiCe/mcp-warden
    EOS
  end

  test do
    assert_match "mcp-warden #{version}", shell_output("#{bin}/mcp-warden --version")
    assert_equal "plain text\n", pipe_output("#{bin}/mcp-warden scan", "plain text\n")
  end
end
