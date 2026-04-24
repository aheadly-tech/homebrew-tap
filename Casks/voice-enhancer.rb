cask "voice-enhancer" do
  version "1.0.0"
  sha256 "c32c8571386168cd7f859406109abaa904fff22fad6b4e33902592bb25b861b7"

  url "https://github.com/aheadly-tech/voice-enhancer/releases/download/v#{version}/Voice-Enhancer-#{version}.zip"
  name "Voice Enhancer"
  desc "Real-time voice processing for macOS meetings"
  homepage "https://github.com/aheadly-tech/voice-enhancer"

  depends_on macos: ">= :ventura"

  app "Voice Enhancer.app"
  artifact "VoiceEnhancer.driver", target: "/Library/Audio/Plug-Ins/HAL/VoiceEnhancer.driver"

  postflight do
    system_command "/usr/sbin/chown",
                   args: ["-R", "root:wheel", "/Library/Audio/Plug-Ins/HAL/VoiceEnhancer.driver"],
                   sudo: true
    system_command "/bin/chmod",
                   args: ["-R", "go-w", "/Library/Audio/Plug-Ins/HAL/VoiceEnhancer.driver"],
                   sudo: true
    system_command "/usr/bin/killall",
                   args: ["-9", "coreaudiod"],
                   sudo: true
  end

  uninstall delete: "/Library/Audio/Plug-Ins/HAL/VoiceEnhancer.driver"

  zap trash: [
    "~/Library/Preferences/tech.aheadly.voice-enhancer.plist",
  ]
end
