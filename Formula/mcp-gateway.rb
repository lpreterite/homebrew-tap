class McpGateway < Formula
  desc "MCP 统一网关 - 连接多个 MCP 服务器的统一网关"
  homepage "https://github.com/lpreterite/mcp-gateway"
  version "v1.0.0"

  depends_on "go" => :build

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-darwin-arm64"
      sha256 "f0e60ccb1b3102666454694903d22e4883b6d1ade8bb29d81bf7e69d9d78b764"
    else
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-darwin-amd64"
      sha256 "ef021305ab64dced084bbd01595f499518c985a3297c83008aa51ec9a162e84f"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-linux-arm64"
      sha256 "a30d16ecc0d34426f7bb2c2dd34d1ffe444ace64ece82b8e6f6a9981b0413963"
    else
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-linux-amd64"
      sha256 "f2c02b1f90c483c90b6ddea7a88812347c30e016a382d1b837e6f92785891cac"
    end
  end

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "mcp-gateway-darwin-arm64" => "mcp-gateway"
      else
        bin.install "mcp-gateway-darwin-amd64" => "mcp-gateway"
      end
    else
      if Hardware::CPU.arm?
        bin.install "mcp-gateway-linux-arm64" => "mcp-gateway"
      else
        bin.install "mcp-gateway-linux-amd64" => "mcp-gateway"
      end
    end
  end

  test do
    system "#{bin}/mcp-gateway", "--version"
  end
end
