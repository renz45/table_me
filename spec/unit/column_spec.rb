require_relative '../../lib/table_me/column'
describe TableMe::Column do
  let(:block) { proc{ } }
  let(:column_name) { :email }
  let(:column) { described_class.new(column_name, &block) }

  describe '.name' do
    it 'returns a column_name' do
      column.name.should eq column_name
    end
  end

  describe '.content' do
    it 'returns a block if it exists' do
      column.content.should eq block
    end
  end
end