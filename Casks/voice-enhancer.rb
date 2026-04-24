cask "voice-enhancer" do
  version "1.0.0"
  sha256 "81465a8500225dee9edf81691ba92082f2fcd89aeacab36ef9fc898428a8a83c"

  url "https://github.com/aheadly-tech/voice-enhancer/releases/download/v#{version}/Voice-Enhancer-#{version}.zip"
  name "Voice Enhancer"
  desc "Real-time voice processing for macOS meetings"
  homepage "https://github.com/aheadly-tech/voice-enhancer"

  depends_on macos: ">= :ventura"

  app "Voice Enhancer.app"
  artifact "VoiceEnhancer.driver", target: "/Library/Audio/Plug-Ins/HAL/VoiceEnhancer.driver"

  postflight do
    system_command "/usr/bin/killall",
                   args: ["-9", "coreaudiod"],
                   sudo: true
  end

  uninstall delete: "/Library/Audio/Plug-Ins/HAL/VoiceEnhancer.driver"

  zap trash: [
    "~/Library/Preferences/tech.aheadly.voice-enhancer.plist",
  ]
end
