require 'spec_helper'
include MacOS

describe MacOS::Xcode do
  context 'when initialized without a download url and Xcode betas available' do
    before do
      allow_any_instance_of(MacOS::Xcode).to receive(:installed_path).and_return nil
      allow(MacOS::XCVersion).to receive(:available_versions)
        .and_return(["4.3 for Lion\n",
                     "4.3.1 for Lion\n",
                     "4.3.2 for Lion\n",
                     "4.3.3 for Lion\n",
                     "4.4\n",
                     "4.4.1\n",
                     "4.5\n",
                     "4.5.1\n",
                     "4.5.2\n",
                     "4.6\n",
                     "4.6.1\n",
                     "4.6.2\n",
                     "4.6.3\n",
                     "5\n",
                     "5.0.1\n",
                     "5.0.2\n",
                     "5.1\n",
                     "5.1.1\n",
                     "6.0.1\n",
                     "6.1\n",
                     "6.1.1\n",
                     "6.2\n",
                     "6.3\n",
                     "6.3.1\n",
                     "6.3.2\n",
                     "6.4\n",
                     "7\n",
                     "7.0.1\n",
                     "7.1\n",
                     "7.1.1\n",
                     "7.2\n",
                     "7.2.1\n",
                     "7.3\n",
                     "7.3.1\n",
                     "8\n",
                     "8.1\n",
                     "8.2\n",
                     "8.2.1\n",
                     "8.3\n",
                     "8.3.1\n",
                     "8.3.2\n",
                     "8.3.3\n",
                     "9\n",
                     "9.0.1\n",
                     "9.1\n",
                     "9.2\n",
                     "9.3\n",
                     "9.4.1\n",
                     "9.4.2 beta 2\n",
                     "9.4.2\n",
                     "10 beta 1\n",
                     "10 GM seed\n",
                     "10\n",
                     "10.1\n",
                     "10.2.1\n",
                     "10.2\n",
                     "10.3\n",
                     "11\n",
                     "11.1\n",
                     "11.2\n",
                     "11.2.1\n",
                     "11.3 beta\n",
                     "11.3\n",
                     "11.3.1\n",
                     "11.4 beta\n",
                     "11.4\n",
                     "11.4 beta 3\n",
                     "11.4 beta 2\n",
                     "11.4.1\n",
                     "11.5 beta\n",
                     "11.5\n",
                     "11.5 GM Seed\n",
                     "11.5 beta 2\n",
                     "11.6 beta\n",
                     "12 beta 4\n",
                     "12 for macOS Universal Apps beta\n",
                     "12 beta 3\n",
                     "12 beta 2\n",
                     "12 for macOS Universal Apps beta 2\n",
                     "12 beta\n"]
                   )
    end
    it 'returns the name of Xcode 11.5 official when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('12.0', '/Applications/Xcode.app')
      expect(xcode.version).to eq '12 beta 4'
      expect(xcode.version).to_not eq '12 beta'
      expect(xcode.version).to_not eq '12 for macOS Universal Apps beta'
    end
    it 'returns the name of Xcode 11.5 official when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('11.5', '/Applications/Xcode.app')
      expect(xcode.version).to eq '11.5'
      expect(xcode.version).to_not eq '11.5 beta'
      expect(xcode.version).to_not eq '11.5 GM Seed'
    end
    it 'returns the name of Xcode 10 official when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('10.0', '/Applications/Xcode.app')
      expect(xcode.version).to eq '10'
      expect(xcode.version).to_not eq '10 GM seed'
      expect(xcode.version).to_not eq '10 beta 1'
    end
    it 'returns the name of Xcode 9.4.2 official when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('9.4.2', '/Applications/Xcode.app')
      expect(xcode.version).to eq '9.4.2'
      expect(xcode.version).to_not eq '9.4.2 beta 2'
      expect(xcode.version).to_not eq '9.4.2 beta 3'
    end
    it 'returns the temporary beta path set by xcversion when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('9.4.2', '/Applications/Xcode.app')
      expect(xcode.current_path).to eq '/Applications/Xcode-9.4.2.app'
    end
    it 'returns the name of Xcode 9.3 when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('9.3', '/Applications/Xcode.app')
      expect(xcode.version).to eq '9.3'
    end
    it 'returns the name of Xcode 9 when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('9.0', '/Applications/Xcode.app')
      expect(xcode.version).to eq '9'
    end
    it 'returns the name of Xcode 8.3.3 when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('8.3.3', '/Applications/Xcode.app')
      expect(xcode.version).to eq '8.3.3'
    end
    it 'correctly determines platform compatibility for Xcode 11' do
      xcode = MacOS::Xcode.new('11.0', '/Applications/Xcode.app')
      expect(xcode.compatible_with_platform?('10.14.4')).to be true
      expect(xcode.compatible_with_platform?('10.14.3')).to be false
      expect(xcode.compatible_with_platform?('10.13.6')).to be false
      expect(xcode.compatible_with_platform?('10.13.2')).to be false
      expect(xcode.compatible_with_platform?('10.12.6')).to be false
      expect(xcode.compatible_with_platform?('0')).to be false
    end
    it 'correctly determines platform compatibility for Xcode 10.3' do
      xcode = MacOS::Xcode.new('10.3', '/Applications/Xcode.app')
      expect(xcode.compatible_with_platform?('10.14.4')).to be true
      expect(xcode.compatible_with_platform?('10.14.3')).to be true
      expect(xcode.compatible_with_platform?('10.13.6')).to be false
      expect(xcode.compatible_with_platform?('10.13.2')).to be false
      expect(xcode.compatible_with_platform?('10.12.6')).to be false
      expect(xcode.compatible_with_platform?('0')).to be false
    end
    it 'correctly determines platform compatibility for Xcode 10.1' do
      xcode = MacOS::Xcode.new('10.1', '/Applications/Xcode.app')
      expect(xcode.compatible_with_platform?('10.14.4')).to be true
      expect(xcode.compatible_with_platform?('10.14.3')).to be true
      expect(xcode.compatible_with_platform?('10.13.6')).to be true
      expect(xcode.compatible_with_platform?('10.13.2')).to be false
      expect(xcode.compatible_with_platform?('10.12.6')).to be false
      expect(xcode.compatible_with_platform?('0')).to be false
    end
    it 'correctly determines platform compatibility for Xcode 9.4.1' do
      xcode = MacOS::Xcode.new('9.4.1', '/Applications/Xcode.app')
      expect(xcode.compatible_with_platform?('10.14.4')).to be true
      expect(xcode.compatible_with_platform?('10.14.3')).to be true
      expect(xcode.compatible_with_platform?('10.13.6')).to be true
      expect(xcode.compatible_with_platform?('10.13.2')).to be true
      expect(xcode.compatible_with_platform?('10.12.6')).to be false
      expect(xcode.compatible_with_platform?('0')).to be false
    end
    it 'correctly determines platform compatibility for a vintage Xcode' do
      xcode = MacOS::Xcode.new('9.2', '/Applications/Xcode.app')
      expect(xcode.compatible_with_platform?('10.14.4')).to be true
      expect(xcode.compatible_with_platform?('10.14.3')).to be true
      expect(xcode.compatible_with_platform?('10.13.6')).to be true
      expect(xcode.compatible_with_platform?('10.13.2')).to be true
      expect(xcode.compatible_with_platform?('10.12.6')).to be true
      expect(xcode.compatible_with_platform?('0')).to be true # not enforcing compatibilty for vintage or obsolete Xcodes
    end
    it 'correctly determines platform compatibility for an obsolete Xcode' do
      xcode = MacOS::Xcode.new('8.2.1', '/Applications/Xcode.app')
      expect(xcode.compatible_with_platform?('10.14.4')).to be true
      expect(xcode.compatible_with_platform?('10.14.3')).to be true
      expect(xcode.compatible_with_platform?('10.13.6')).to be true
      expect(xcode.compatible_with_platform?('10.13.2')).to be true
      expect(xcode.compatible_with_platform?('10.12.6')).to be true
      expect(xcode.compatible_with_platform?('0')).to be true # not enforcing compatibilty for vintage or obsolete Xcodes
    end
  end
end

describe MacOS::Xcode do
  context 'when initialized with an Xcode download url and Xcode betas available' do
    before do
      allow(MacOS::XCVersion).to receive(:available_versions).and_return(["10 GM seed\n"])
    end
    it 'returns the download url' do
      xcode = MacOS::Xcode.new('10.0', '/Applications/Xcode.app', 'https://www.apple.com')
      expect(xcode.download_url).to eq 'https://www.apple.com'
    end

    it 'ignores the Apple version list and uses the provided version' do
      xcode = MacOS::Xcode.new('0.0', '/Applications/Xcode.app', 'https://www.apple.com')
      expect(xcode.version).to eq '0.0'
    end

    it 'ignores the Apple version list and uses the provided version' do
      xcode = MacOS::Xcode.new('2', '/Applications/Xcode.app', 'https://www.apple.com')
      expect(xcode.version).to eq '2'
    end
  end
end

describe MacOS::Xcode::Simulator do
  context 'when provided an available list of simulators' do
    before do
      allow_any_instance_of(MacOS::Xcode::Simulator).to receive(:available_versions)
        .and_return(<<-XCVERSION_OUTPUT
                    Xcode 9.2 (/Applications/Xcode-9.2.app)
                    iOS 8.1 Simulator (not installed)
                    iOS 8.2 Simulator (not installed)
                    iOS 8.3 Simulator (not installed)
                    iOS 8.4 Simulator (not installed)
                    iOS 9.0 Simulator (not installed)
                    iOS 9.1 Simulator (not installed)
                    iOS 9.2 Simulator (not installed)
                    iOS 9.3 Simulator (not installed)
                    iOS 10.0 Simulator (not installed)
                    iOS 10.1 Simulator (not installed)
                    tvOS 9.0 Simulator (not installed)
                    tvOS 9.1 Simulator (not installed)
                    tvOS 9.2 Simulator (not installed)
                    tvOS 10.0 Simulator (not installed)
                    watchOS 2.0 Simulator (not installed)
                    watchOS 2.1 Simulator (not installed)
                    watchOS 2.2 Simulator (not installed)
                    tvOS 10.1 Simulator (not installed)
                    iOS 10.2 Simulator (not installed)
                    watchOS 3.1 Simulator (not installed)
                    iOS 10.3.1 Simulator (not installed)
                    watchOS 3.2 Simulator (not installed)
                    tvOS 10.2 Simulator (not installed)
                    iOS 11.0 Simulator (not installed)
                    watchOS 4.0 Simulator (not installed)
                    tvOS 11.0 Simulator (not installed)
                    tvOS 11.1 Simulator (not installed)
                    watchOS 4.1 Simulator (not installed)
                    iOS 11.1 Simulator (not installed)
        XCVERSION_OUTPUT
                   )
    end
    it 'returns the latest semantic version of iOS 11' do
      simulator = MacOS::Xcode::Simulator.new('11')
      expect(simulator.version).to eq 'iOS 11.1'
    end
    it 'returns the latest semantic version of iOS 10' do
      simulator = MacOS::Xcode::Simulator.new('10')
      expect(simulator.version).to eq 'iOS 10.3.1'
    end
    it 'returns the latest semantic version of iOS 9' do
      simulator = MacOS::Xcode::Simulator.new('9')
      expect(simulator.version).to eq 'iOS 9.3'
    end

    context 'when provided a list of device SDKs included with Xcode' do
      before do
        allow_any_instance_of(MacOS::Xcode::Simulator).to receive(:show_sdks)
          .and_return(<<-XCODEBUILD_OUTPUT
                    iOS SDKs:
                            iOS 11.2                      	-sdk iphoneos11.2

                    iOS Simulator SDKs:
                            Simulator - iOS 11.2          	-sdk iphonesimulator11.2

                    macOS SDKs:
                            macOS 10.13                   	-sdk macosx10.13

                    tvOS SDKs:
                            tvOS 11.2                     	-sdk appletvos11.2

                    tvOS Simulator SDKs:
                            Simulator - tvOS 11.2         	-sdk appletvsimulator11.2

                    watchOS SDKs:
                            watchOS 4.2                   	-sdk watchos4.2

                    watchOS Simulator SDKs:
                            Simulator - watchOS 4.2       	-sdk watchsimulator4.2
          XCODEBUILD_OUTPUT
                     )
      end
      it 'determines that iOS 11 is included with this Xcode' do
        simulator = MacOS::Xcode::Simulator.new('11')
        expect(simulator.included_with_xcode?).to be true
      end
      it 'determines that iOS 10 is not included with this Xcode' do
        simulator = MacOS::Xcode::Simulator.new('10')
        expect(simulator.included_with_xcode?).to be false
      end
    end
  end
end

describe MacOS::Xcode::Version do
  context 'when initalized with a new major release of Xcode' do
    it 'recognizes a major release' do
      xcode = MacOS::Xcode::Version.new('9')
      expect(xcode.major_release?).to be true
      expect(xcode.minor_release?).to be false
      expect(xcode.patch_release?).to be false
    end
  end

  context 'when initalized with a new major release of Xcode' do
    it 'recognizes a major release' do
      xcode = MacOS::Xcode::Version.new('9.0')
      expect(xcode.major_release?).to be true
      expect(xcode.minor_release?).to be false
      expect(xcode.patch_release?).to be false
    end
  end

  context 'when initalized with a new major release of Xcode' do
    it 'recognizes a major release' do
      xcode = MacOS::Xcode::Version.new('9.0.0')
      expect(xcode.major_release?).to be true
      expect(xcode.minor_release?).to be false
      expect(xcode.patch_release?).to be false
    end
  end

  context 'when initalized with a minor release of Xcode' do
    it 'recognizes a minor release' do
      xcode = MacOS::Xcode::Version.new('9.1')
      expect(xcode.major_release?).to be false
      expect(xcode.minor_release?).to be true
      expect(xcode.patch_release?).to be false
    end
  end

  context 'when initalized with a minor release of Xcode' do
    it 'recognizes a minor release' do
      xcode = MacOS::Xcode::Version.new('9.1.0')
      expect(xcode.major_release?).to be false
      expect(xcode.minor_release?).to be true
      expect(xcode.patch_release?).to be false
    end
  end

  context 'when initalized with a patch release of Xcode' do
    it 'recognizes a patch release' do
      xcode = MacOS::Xcode::Version.new('9.0.1')
      expect(xcode.major_release?).to be false
      expect(xcode.minor_release?).to be false
      expect(xcode.patch_release?).to be true
    end
  end

  context 'when initalized with a patch release of Xcode' do
    it 'recognizes a patch release' do
      xcode = MacOS::Xcode::Version.new('0.3.3')
      expect(xcode.major_release?).to be false
      expect(xcode.minor_release?).to be false
      expect(xcode.patch_release?).to be true
    end
  end
end
