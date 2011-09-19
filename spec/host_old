describe "Interfacing with Host in LDAP" do
  context "network devices" do 
    it 'should be able to list all network devices on galactica' do
      host = Host.new('galactica')
      host.list_network_devices.should == ['eth0', 'lo0']
    end

    it 'should be able to list all network devices on odin' do
      host = Host.new('odin')
      host.list_network_devices.should == ['eth0', 'eth1', 'lo0']
    end

    it 'should be able to get information on eth0 from galactica' do
      a = {
        'factInterface'  => 'eth0',
        'factIpAddress'  => '192.168.1.100',
        'factMacAddress' => '11:11:11:11:11:11',
        'factNetwork'    => '255.255.255.0'
      }
     
      host = Host.new('galactica')
      host.get_network_info('eth0').should == a
    end

    it 'should be able to create a new network device' do
      host = Host.new('galactica')
      host.create_network_device('eth1')
      host.list_network_devices.include?('eth1').should == true
    end

    it 'should be able to write a new network device entry' do
      b = {
        'factInterface'  => 'eth1',
        'factIpAddress'  => '192.168.2.100',
        'factMacAddress' => '22:22:22:22:22:22',
        'factNetwork'    => '255.255.255.0',
      }
      host = Host.new('galactica')
      host.write_network_info(b['factInterface'], b)

      host.list_network_devices.should == ['eth0', 'eth1', 'lo0']
      host.get_network_info(b['factInterface']).should == b
    end

    it 'should be able to delete a network device' do
      host = Host.new('galactica')
      host.delete_network_device('eth1')
      host.list_network_devices.include?('eth1').should == false
    end

    it 'should be able to tell me everything about all network devices' do
      a = {
        'lo0'  => Hash.new,
        'eth0' => {
          'factNetwork'    => '255.255.255.0',
          'factIpAddress'  => '192.168.1.100',
          'factInterface'  => 'eth0',
          'factMacAddress' => '11:11:11:11:11:11'
        }
      }

      host = Host.new('galactica')
      host.get_all_network_info.should == a
    end
  end

  context "processors" do
    it 'should be able to list all processors on galactica' do
      host = Host.new('galactica')
      processors = host.list_processors
      processors.should == ['processor0']
    end

    it 'should be able to list all processors on odin' do
      host = Host.new('odin')
      processors = host.list_processors
      processors.should == ['processor0', 'processor1']
    end

    it 'should be able to get information on processor0 from galactica' do
      a = {
        'factProcessorId'   => '0',
        'factProcessorInfo' => 'testing'
      }
     
      host = Host.new('galactica')
      host.get_processor_info(0).should == a
    end
    
    it 'should be able to get information on processor1 from odin' do
      a = {
        'factProcessorId'   => '1',
        'factProcessorInfo' => 'testing'
      }
     
      host = Host.new('odin')
      host.get_processor_info(1).should == a
    end

    it 'should be able to create a new network device' do
      host = Host.new('galactica')
      host.create_processor(1)
      host.list_processors.include?('processor0').should == true
    end

    it 'should be able to write a processor entry to galactica' do
      a = {
        'factProcessorId'   => '1',
        'factProcessorInfo' => 'test-writing-to-galactica'
      }

      host = Host.new('galactica')
      host.write_processor_info(1, a).should == true
      host.list_processors.should == ['processor0', 'processor1']
      host.get_processor_info(1).should == a
    end

    it 'should be able to delete a processor device' do
      host = Host.new('galactica')
      host.delete_processor(1)
      host.list_network_devices.include?('processor1').should == false
    end

    it 'should be able to tell me all known facts about processors' do
      a = {
        'processor0' => {
          'factProcessorInfo' => 'testing',
          'factProcessorId'   => '0'
        },
        'processor1' => {
          'factProcessorInfo' => 'testing',
          'factProcessorId'   => '1',
        }
      }
      host = Host.new('odin')
      host.get_all_processor_info.should == a
    end
  end

  context "bare" do
    it 'should be able to write a fact' do
      host = Host.new('galactica')
      host.set_fact('factFqdn', 'galactica.test.com').should == true
    end

    it 'should gracefully handle an unknown fact' do
      host = Host.new('galactica')
      host.set_fact('fqdn', 'galactica.test.com').should == nil
    end

    it 'should be able to tell me all known facts about a system' do
      a = {
        'eth0' => {
          'factNetwork'    => '255.255.255.0',
          'factIpAddress'  => '192.168.1.100',
          'factInterface'  => 'eth0',
          'factMacAddress' => '11:11:11:11:11:11'
        },
        'factFqdn'   => 'galactica.test.com',
        'lo0'        => Hash.new,
        'processor0' => {
          'factProcessorInfo' => 'testing',
          'factProcessorId'   => '0'
        }
      }
      host = Host.new('galactica')
      host.get_all_facts.should == {'factFqdn' => 'galactica.test.com'}
    end
  end
end
