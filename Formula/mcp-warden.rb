class McpWarden < Formula
  desc "Stdio proxy that sanitizes untrusted MCP server output before an agent reads it"
  homepage "https://github.com/AncientiCe/mcp-warden"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.4.0/mcp-warden-0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "5607176f50c4db13fdef3bdf2a96510ba699fc3af83945a4039da80b01714016"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.4.0/mcp-warden-0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "4c8db0de47c8a0606b9926fc35856c5825e442be2998ece1bded9f3a2fdf7454"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.4.0/mcp-warden-0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6458d7e09a456b1c546055e44eb33e0ece8a3a6fe38c3a6453a01a390c9a3c4e"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.4.0/mcp-warden-0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2897c07345141a61ab2f5be1ce44e85dde86677f4b8487933b8448e8eb2039b6"
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
