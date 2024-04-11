# frozen_string_literal: true

require 'httparty'

class ForecastController < ApplicationController
  OPENWEATHERMAP_API_KEY = 'fbe6c738c1118e617d9495aa2b858bd3'

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
    # http://api.openweathermap.org/geo/1.0/direct?limit=1&q=Davie,FL,US&appid=fbe6c738c1118e617d9495aa2b858bd3
    response = HTTParty.get("http://api.openweathermap.org/geo/1.0/direct?limit=1&q=#{address}&appid=fbe6c738c1118e617d9495aa2b858bd3")
    response = JSON.parse(response.body)
    # http://api.openweathermap.org/data/2.5/weather?lat=26.0628665&lon=-80.2331038&appid=fbe6c738c1118e617d9495aa2b858bd3&units=imperial
    response = HTTParty.get("http://api.openweathermap.org/data/2.5/weather?lat=#{response[0]['lat']}&lon=#{response[0]['lon']}&appid=#{OPENWEATHERMAP_API_KEY}&units=imperial")

    if response.code == 200
      weather = JSON.parse(response.body)
      {
        address:,
        temperature: weather['main']['temp'],
        high: weather['main']['temp_max'],
        low: weather['main']['temp_min'],
        cached: false
      }
    else
      { error: 'Unable to fetch weather data' }
    end
  end
end
