class McpGateway < Formula
  desc "MCP 统一网关 - 连接多个 MCP 服务器的统一网关"
  homepage "https://github.com/lpreterite/mcp-gateway"
  version "v1.0.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-darwin-arm64"
      sha256 "95960c52a90a6f7472711bb33b293cf2dcde1aee36991480328635f7a552f764"
    else
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-darwin-amd64"
      sha256 "2b6ae51ea54c3cdf59a8e10232b23944f8796a96c4b97dc031049e424a327094"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-linux-arm64"
      sha256 "57f4eeffa1665d675921f301dc3aa76b68b6cddfec5f88bb926336e398d0b9f2"
    else
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-linux-amd64"
      sha256 "4561bd9eb3e9eb14b5f6e9168f254304fe0614bf8268cc5a9cd1d63fcfd805a8"
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
    run opt_bin/"mcp-gateway"
    run_args ["--config", etc/"mcp-gateway/config.json"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path "#{var}/log/mcp-gateway.log"
    error_log_path "#{var}/log/mcp-gateway.err.log"
  end

  test do
    system "#{bin}/mcp-gateway", "--version"
  end
end
