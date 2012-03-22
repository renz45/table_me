require_relative '../../lib/table_me/builder'
describe TableMe::Builder do
  let(:email) { 'name@email.com' }
  let(:name) { 'bob' }
  let(:object) { {email: email, name: name} }
  let(:builder) { described_class.new(object) }

  it 'requires an object when instantiated' do
    builder.class.should eq described_class
  end

  describe '.options' do
    it 'returns the builder_object that was passed into the constructor' do
      builder.options.should eq object
    end
  end

  describe '.column' do
    it 'requires a column name and optional block' do
      builder.stub!(:column)
    end
  end

end