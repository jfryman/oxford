describe 'Oxford' do
  it 'should run without errors' do
    path = File.join(File.dirname(__FILE__),"/../oxford.rb")
    p path
    %x{#{File.join(File.dirname(__FILE__),"/..","/oxford.rb")}}.should be(0)
  end
end

