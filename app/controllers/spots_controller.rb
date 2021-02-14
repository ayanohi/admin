class SpotsController < ApplicationController

  def new
    @spot = Spot.new
  end
end
