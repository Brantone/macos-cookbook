require 'spec_helper'

describe 'xcode' do
  step_into :xcode
  platform 'mac_os_x'

  default_attributes['macos']['apple_id']['user'] = 'developer@apple.com'
  default_attributes['macos']['apple_id']['password'] = 'apple_id_password'

  before(:each) do
    allow_any_instance_of(MacOS::DeveloperAccount).to receive(:authenticate_with_apple)
      .and_return(true)
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
                   "12 beta\n"])
    allow(File).to receive(:exist?).and_call_original
    allow(FileUtils).to receive(:touch).and_return(true)
    allow(FileUtils).to receive(:chown).and_return(true)
  end

  context 'with no Xcodes installed' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([])
      stub_command('test -L /Applications/Xcode.app').and_return(true)
    end

    recipe do
      xcode '10.0' do
        version '10.0'
      end
    end

    it { is_expected.to run_execute('install Xcode 10') }
    it { is_expected.to delete_link('/Applications/Xcode.app') }

    it { is_expected.to run_execute('move /Applications/Xcode-10.app to /Applications/Xcode.app') }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Xcode.app') }
  end

  context 'with no Xcodes installed, and a beta Xcode requested' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([])
      stub_command('test -L /Applications/Xcode.app').and_return(true)
    end

    recipe do
      xcode 'betamax!' do
        version '11.6'
      end
    end

    it { is_expected.to run_execute('install Xcode 11.6 beta') }
    it { is_expected.to delete_link('/Applications/Xcode.app') }

    it { is_expected.to run_execute('move /Applications/Xcode-11.6.beta.app to /Applications/Xcode.app').with(command: ['mv', '/Applications/Xcode-11.6.beta.app', '/Applications/Xcode.app']) }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Xcode.app') }
  end

  context 'with no Xcodes installed, and the URL property defined' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([])
      stub_command('test -L /Applications/Xcode.app').and_return(true)
    end

    recipe do
      xcode '10.1' do
        download_url 'https://apple.com'
        version '0.0'
      end
    end

    it { is_expected.to run_execute('install Xcode 0.0') }
    it { is_expected.to delete_link('/Applications/Xcode.app') }

    it { is_expected.to run_execute('move /Applications/Xcode-0.0.app to /Applications/Xcode.app') }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Xcode.app') }
  end

  context 'with no Xcodes installed, and a modern Xcode requested on an older platform' do
    automatic_attributes['platform_version'] = '10.12'
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([])
    end

    recipe do
      xcode '10.1'
    end

    it 'raises an error' do
      expect { subject }.to raise_error(RuntimeError, /Xcode 10\.1 not supported on 10.12/)
    end
  end

  context 'with no Xcodes installed, and a vintage Xcode requested on an older platform' do
    automatic_attributes['platform_version'] = '10.12'
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([])
      stub_command('test -L /Applications/Xcode.app').and_return(true)
    end

    recipe do
      xcode '9.2'
    end

    it 'does not raise an error' do
      expect { subject }.to_not raise_error
    end
  end

  context 'with requested Xcode installed' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([{ '10.0' => '/Applications/Xcode.app' }])
      stub_command('test -L /Applications/Xcode.app').and_return(false)
    end

    recipe do
      xcode '10.0'
    end

    it { is_expected.not_to run_execute('install Xcode 10') }
    it { is_expected.not_to delete_link('/Applications/Xcode.app') }

    it { is_expected.not_to run_execute('move /Applications/Xcode-10.app to /Applications/Xcode.app') }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Xcode.app') }
  end

  context 'with requested Xcode installed at a different path' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([{ '10.0' => '/Applications/Some_Weird_Path.app' }])
      stub_command('test -L /Applications/Xcode.app').and_return(false)
    end

    recipe do
      xcode '10.0' do
        path '/Applications/Chef_Managed_Xcode.app'
      end
    end

    it { is_expected.not_to run_execute('install Xcode 10') }
    it { is_expected.not_to delete_link('/Applications/Xcode.app') }

    it { is_expected.to run_execute('move /Applications/Some_Weird_Path.app to /Applications/Chef_Managed_Xcode.app') }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Chef_Managed_Xcode.app') }
  end

  context 'with requested Xcode version not installed, and something at the requested path' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([{ '9.3' => '/Applications/Xcode.app' }])
      stub_command('test -L /Applications/Xcode.app').and_return(true)
    end

    recipe do
      xcode '10.0' do
        path '/Applications/Xcode.app'
      end
    end

    it { is_expected.to run_execute('install Xcode 10') }
    it { is_expected.to delete_link('/Applications/Xcode.app') }

    it { is_expected.to run_execute('move /Applications/Xcode-10.app to /Applications/Xcode.app') }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Xcode.app') }
  end
end
