require 'oystercard'

describe Oystercard do

    let(:station) {double :station}
    let(:entry_station) {double :entry_station}
    let(:exit_station)  {double :exit_station}
    let(:journey) {double :journey}

  it 'should check if there are empty lists of journeys' do
    expect(subject.journeys).to match_array([])
  end

  it 'is not in a journey' do
    expect(subject).not_to be_in_journey
  end

describe '#touch_in' do


  it 'records the entry station' do
    subject.top_up(1)
    subject.touch_in(station)
    expect(subject.entry_station).to eq station
  end

  let(:journey){ {entry_station: entry_station, exit_station: exit_station} }

  it 'stores a journey' do
    subject.top_up(10)
    subject.touch_in(entry_station)
    subject.touch_out(exit_station)
    expect(subject.journeys).to include journey
  end

end

describe '#touch_out' do

  before :each do
    subject.top_up(5)
    subject.touch_in(station)

  end

  it 'can touch out' do
    subject.touch_out(station)
    expect(subject.in_journey).to be false
  end

  it 'stores the exit station' do
    subject.touch_out(station)
    expect(subject.exit_station).to eq station
  end

  it 'deducts the correct money after the journey' do
    expect { subject.touch_out(station) }.to change { subject.balance }.by (-Oystercard::MINIMUM_BALANCE)
  end

end

  it "won't touch in if below minimum balance" do
    expect{subject.touch_in(station)}.to raise_error 'Insufficient funds for jouney'
  end

  describe 'top_up' do
    before :each do
      @balance = Oystercard::MAXIMUM_BALANCE
    end


    it 'raises an exception if maximum balance is exceeded' do
      subject.top_up(@balance)
      expect{subject.top_up 5}.to raise_error "Maximum balance of #{Oystercard::MAXIMUM_BALANCE} exceeded"
    end
  end

    it 'should charge penalty fare if you try to touch in twice in a-row' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      expect{subject.touch_in(Station.new)}.to change{subject.balance}.by (-Oystercard::PENALTY_FARE)
    end

end
