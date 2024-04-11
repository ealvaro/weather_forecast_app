class ForecastController < ApplicationController
  def show
    address = params[:address]
    forecast_data = fetch_forecast(address)
    render json: forecast_data
  end

  private

  def fetch_forecast(address)
    # Fetch forecast data from API
    weather_data = fetch_weather_data(address)

    # Cache forecast data for 30 minutes
    Rails.cache.fetch("forecast_#{address}", expires_in: 30.minutes) do
      weather_data.merge(cached: false) # Indicate that the data was not pulled from cache
    end
  end

  def fetch_weather_data(address)
    {
      address: address,
      temperature: rand(32..90), # Generate a random temperature for demonstration
      high: rand(60..90),
      low: rand(32..60),
      extended_forecast: ['Sunny', 'Partly Cloudy', 'Rainy', 'Rain Storms', 'Hurricane Winds'].sample,
      cached: true # Indicate that the data was pulled from cache
    }
  end
end
