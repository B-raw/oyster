require 'journey_log'

describe JourneyLog do

  subject {described_class.new}

  it "should show journey history" do
    expect(subject.journeys).to match_array([])
  end



end
