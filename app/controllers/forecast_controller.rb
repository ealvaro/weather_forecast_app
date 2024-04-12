require 'httparty'

class ForecastController < ApplicationController
  def show
    address = params[:address]
    forecast_data = fetch_forecast(address)

    if forecast_data[:error]
      render json: forecast_data, status: :unprocessable_entity
    else
      render json: forecast_data
    end
  end

  private

  def fetch_forecast(address)
    cached_forecast = Rails.cache.read("forecast_#{address}")
    return cached_forecast if cached_forecast.present?

    weather_data = fetch_weather_data(address)

    if weather_data[:error]
      weather_data
    else
      cache_forecast(address, weather_data)
    end
    weather_data
  end

  def fetch_weather_data(address)
    return { error: 'Address is required' } unless address.present?

    location = fetch_location(address)
    return { error: 'Unable to fetch location data' } unless location

    weather = fetch_weather(location['lat'], location['lon'])
    return { error: 'Unable to fetch weather data' } unless weather

    {
      address:,
      temperature: weather['main']['temp'],
      high: weather['main']['temp_max'],
      low: weather['main']['temp_min'],
      cached: false
    }
  end

  def fetch_location(address)
    begin
      response = HTTParty.get("#{ENV['OPENWEATHERMAP_GEO_API_URL']}?limit=1&q=#{address}&appid=#{ENV['OPENWEATHERMAP_API_KEY']}")
    rescue HTTParty::Error
      return nil
    end
    JSON.parse(response.body).first
  end

  def fetch_weather(latitude, longitude)
    begin
      response = HTTParty.get("#{ENV['OPENWEATHERMAP_WEATHER_API_URL']}?lat=#{latitude}&lon=#{longitude}&appid=#{ENV['OPENWEATHERMAP_API_KEY']}&units=imperial")
    rescue HTTParty::Error
      return nil
    end
    JSON.parse(response.body)
  end

  def cache_forecast(address, weather_data)
    Rails.cache.fetch("forecast_#{address}", expires_in: 30.minutes) do
      weather_data.merge(cached: true)
    end
  end
end
