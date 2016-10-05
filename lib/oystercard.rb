class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  PENALTY_FARE = 6

attr_reader :balance, :journeys
  def initialize
    @balance = 0
    @journeys = []
  end


  def top_up(amount)
    fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(station)
    fail 'Insufficient funds for jouney' if @balance < MINIMUM_BALANCE
    charge_penalty_fare if @current_journey #if a current journey still exists, need to charge penalty fare...
    new_journey(station)
  end

  def touch_out(station)
    deduct(MINIMUM_BALANCE)
    end_journey(station)
  end

private

  def deduct(amount)
    @balance -= amount
  end

  def new_journey(station)
    @current_journey = Journey.new(station)
  end

  def end_journey(station)
    @current_journey.finish_journey(station)
    @journeys << @current_journey.journey
    @current_journey = nil
  end

  def charge_penalty_fare
    @balance -= PENALTY_FARE
    @journeys << @current_journey.journey
    "You have been charged £#{PENALTY_FARE} for not touching-out of last station"
  end


end
