class McpGateway < Formula
  desc "MCP 统一网关 - 连接多个 MCP 服务器的统一网关"
  homepage "https://github.com/lpreterite/mcp-gateway"
  version "v1.0.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-darwin-arm64"
      sha256 "2c52fcb1bceb32fcabc2eac6b4e45f77a0dd7b15a7ab7cb60c95dc2b3d2ae2a7"
    else
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-darwin-amd64"
      sha256 "9ebeb545a895275665139239f4331747fdd0b78e8a7c39a4be3ec78136342986"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-linux-arm64"
      sha256 "a43c65538ddc04b8b17f016fbb2aec33fa1ed513954e5f360f3696c8afab288a"
    else
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-linux-amd64"
      sha256 "ac2c9d24913d9bbf540480a41da6ef2de35311815d4c0544bf26272a57c6e2ef"
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

    # 生成示例配置文件
    (etc/"mcp-gateway").mkpath
    (etc/"mcp-gateway/config.json").write <<~JSON
      {
        "gateway": {
          "host": "0.0.0.0",
          "port": 4298,
          "cors": true
        },
        "pool": {
          "minConnections": 1,
          "maxConnections": 5
        },
        "servers": [
          {
            "name": "example",
            "type": "local",
            "command": ["echo", "hello"],
            "enabled": true,
            "poolSize": 1
          }
        ],
        "mapping": {}
      }
    JSON
  end

  def post_install
    ohai "MCP Gateway 安装完成！"
    ohai ""
    ohai "配置文件: #{etc}/mcp-gateway/config.json"
    ohai "日志文件: #{var}/log/mcp-gateway.log"
    ohai ""
    ohai "请编辑 #{etc}/mcp-gateway/config.json 添加你的 MCP 服务器"
    ohai ""
    ohai "启动服务: brew services start #{name}"
    ohai "停止服务: brew services stop #{name}"
    ohai "查看日志: tail -f #{var}/log/mcp-gateway.log"
  end

  service do
    run [opt_bin/"mcp-gateway", "--config", etc/"mcp-gateway/config.json"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path "#{var}/log/mcp-gateway.log"
    error_log_path "#{var}/log/mcp-gateway.err.log"
  end

  test do
    system "#{bin}/mcp-gateway", "--version"
  end
end
