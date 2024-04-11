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
    weather_data = fetch_weather_data(address)
    cache_forecast(address, weather_data)
  end

  def fetch_weather_data(address)
    location = fetch_location(address)
    return { error: 'Unable to fetch location data' } unless location

    weather = fetch_weather(location['lat'], location['lon'])
    return { error: 'Unable to fetch weather data' } unless weather

    {
      address: address,
      temperature: weather['main']['temp'],
      high: weather['main']['temp_max'],
      low: weather['main']['temp_min'],
      cached: false
    }
  end

  def fetch_location(address)
    response = HTTParty.get("http://api.openweathermap.org/geo/1.0/direct?limit=1&q=#{address}&appid=#{OPENWEATHERMAP_API_KEY}")
    JSON.parse(response.body).first
  end

  def fetch_weather(latitude, longitude)
    response = HTTParty.get("http://api.openweathermap.org/data/2.5/weather?lat=#{latitude}&lon=#{longitude}&appid=#{OPENWEATHERMAP_API_KEY}&units=imperial")
    return nil unless response.code == 200

    JSON.parse(response.body)
  end

  def cache_forecast(address, weather_data)
    Rails.cache.fetch("forecast_#{address}", expires_in: 30.minutes) do
      weather_data.merge(cached: true)
    end
  end
end
