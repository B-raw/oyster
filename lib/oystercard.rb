class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  PENALTY_FARE = 6

attr_reader :balance, :entry_station, :exit_station, :in_journey, :journeys
  def initialize
    @balance = 0
    @in_journey = false
    @journeys = []
  end


  def top_up(amount)
    fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def in_journey?
    !!entry_station
  end

  def touch_in(station)
    fail 'Insufficient funds for jouney' if @balance < MINIMUM_BALANCE
    charge_penalty_fare if @current_journey #if a current journey still exists, need to charge penalty fare...
    new_journey(station)
    @in_journey = true
    @entry_station = station

  end

  def touch_out(station)
    @exit_station = station
    deduct(MINIMUM_BALANCE)
    end_journey(station)
    journey
  end


private

  def journey
    @journeys.push({entry_station: entry_station, exit_station: exit_station})
    @in_journey = false
  end

  def deduct(amount)
    @balance -= amount
  end

  def new_journey(station)
    @current_journey = Journey.new(station)
  end

  def end_journey(station)
    @current_journey.finish_journey(station)
    @current_journey = nil
  end

  def charge_penalty_fare
    @balance -= PENALTY_FARE
    "You have been charged £#{PENALTY_FARE} for not touching-out of last station"
  end


end
