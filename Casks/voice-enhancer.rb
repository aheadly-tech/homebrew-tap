cask "voice-enhancer" do
  version "1.0.0"
  sha256 "a406d004ed095693da2ef09592f5817606e7defcb54684219a451be6550d69d1"

  url "https://github.com/aheadly-tech/voice-enhancer/releases/download/v#{version}/Voice-Enhancer-#{version}.zip"
  name "Voice Enhancer"
  desc "Real-time voice processing for macOS meetings"
  homepage "https://github.com/aheadly-tech/voice-enhancer"

  depends_on macos: ">= :ventura"

  app "Voice Enhancer.app"
  artifact "VoiceEnhancer.driver", target: "/Library/Audio/Plug-Ins/HAL/VoiceEnhancer.driver"

  postflight do
    # Remove quarantine (app is not notarized yet)
    system_command "/usr/bin/xattr",
                   args: ["-rc", "/Applications/Voice Enhancer.app"],
                   sudo: true
    system_command "/usr/bin/xattr",
                   args: ["-rc", "/Library/Audio/Plug-Ins/HAL/VoiceEnhancer.driver"],
                   sudo: true
    # Driver must be owned by root for coreaudiod to load it
    system_command "/usr/sbin/chown",
                   args: ["-R", "root:wheel", "/Library/Audio/Plug-Ins/HAL/VoiceEnhancer.driver"],
                   sudo: true
    system_command "/bin/chmod",
                   args: ["-R", "go-w", "/Library/Audio/Plug-Ins/HAL/VoiceEnhancer.driver"],
                   sudo: true
    # Restart coreaudiod so it picks up the new driver
    system_command "/usr/bin/killall",
                   args: ["-9", "coreaudiod"],
                   sudo: true
  end

  uninstall delete: "/Library/Audio/Plug-Ins/HAL/VoiceEnhancer.driver"

  zap trash: [
    "~/Library/Preferences/tech.aheadly.voice-enhancer.plist",
  ]
end
