require 'recent_rubies'

describe 'RecentRubies' do
  let(:subject) { RecentRubies.new }

  context 'initialize' do
    it 'should have set @recent_versions to an empty array' do
      expect(subject.instance_variable_get(:@recent_versions)).to eq([])
    end

    it 'should have set @installed_rubies to an empty array' do
      expect(subject.instance_variable_get(:@installed_rubies)).to eq([])
    end

    it 'should have set @recent_count to 2 when I DEFAULT_COUNT is 2 by default' do
      expect(subject.instance_variable_get(:@recent_count)).to eq(2)
    end
  end

  context 'run' do
    it 'should call the #install and #cleanup method exactly once' do
      expect(subject).to receive(:cleanup).exactly(:once)
      expect(subject).to receive(:install).exactly(:once)
      subject.run
    end
  end

  context 'install' do
    context 'when there are 5 new_rubies to be installed' do
      let(:new_rubies) { ["2.5.0", "2.4.3", "2.4.2", "2.4.1", "2.4.0"] }

      it 'should call rvm install 5 times' do
        RVM = double("RVM")
        expect(subject).to receive(:new_rubies).and_return(new_rubies)
        expect(RVM).to receive(:run).with(/rvm install \d.\d.\d/).exactly(5).times
        subject.install
      end
    end

    context 'when there are no new_rubies to be installed' do
      let(:new_rubies) { [] }

      it 'should not call rvm to install any versions' do
        RVM = double("RVM")
        expect(subject).to receive(:new_rubies).and_return(new_rubies)
        expect(RVM).to_not receive(:run)
        subject.install
      end
    end
  end
end
