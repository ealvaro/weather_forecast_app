# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ForecastController, type: :controller do
  describe 'GET #show' do
    let(:address) { 'New York,NY,US' }
    let(:lat) { 40.7128 }
    let(:lon) { -74.006 }

    context 'when address is provided' do
      it 'returns forecast data' do
        allow(controller).to receive(:fetch_location).and_return({ 'lat' => lat, 'lon' => lon })
        allow(controller).to receive(:fetch_weather).and_return({ 'main' => { 'temp' => 10, 'temp_max' => 15,
                                                                              'temp_min' => 5 } })

        get :show, params: { address: }

        expect(response).to have_http_status(:success)
        body = JSON.parse(response.body)
        expect(body['address']).to eq(address)
        expect(body['temperature']).to eq(10)
        expect(body['high']).to eq(15)
        expect(body['low']).to eq(5)
        expect(body['cached']).to eq(false)
      end
    end

    context 'when address is not provided' do
      it 'returns error' do
        get :show

        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body['error']).to eq('Address is required')
      end
    end

    context 'when location data is not found' do
      it 'returns error' do
        allow(controller).to receive(:fetch_location).and_return(nil)

        get :show, params: { address: }

        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body['error']).to eq('Unable to fetch location data')
      end
    end

    context 'when weather data is not found' do
      it 'returns error' do
        allow(controller).to receive(:fetch_location).and_return({ 'lat' => lat, 'lon' => lon })
        allow(controller).to receive(:fetch_weather).and_return(nil)

        get :show, params: { address: }

        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body['error']).to eq('Unable to fetch weather data')
      end
    end

    context 'when location data API returns an error' do
      it 'returns error' do
        allow(HTTParty).to receive(:get).and_raise(HTTParty::Error)

        get :show, params: { address: }

        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body['error']).to eq('Unable to fetch location data')
      end
    end

    context 'when weather data API returns an error' do
      it 'returns error' do
        allow(controller).to receive(:fetch_location).and_return({ 'lat' => lat, 'lon' => lon })
        allow(HTTParty).to receive(:get).and_raise(HTTParty::Error)

        get :show, params: { address: }

        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body['error']).to eq('Unable to fetch weather data')
      end
    end

    context 'when cache expires' do
      it 'fetches forecast data again' do
        allow(controller).to receive(:fetch_location).and_return({ 'lat' => lat, 'lon' => lon })
        allow(controller).to receive(:fetch_weather).and_return({ 'main' => { 'temp' => 10, 'temp_max' => 15,
                                                                              'temp_min' => 5 } })

        # Cache forecast data for 30 minutes
        Rails.cache.write("forecast_#{address}", { address:, temperature: 10, high: 15, low: 5, cached: true },
                          expires_in: 5.seconds)

        # Wait for cache to expire
        sleep(6.seconds)

        get :show, params: { address: }

        expect(response).to have_http_status(:success)
        body = JSON.parse(response.body)
        expect(body['address']).to eq(address)
        expect(body['temperature']).to eq(10)
        expect(body['high']).to eq(15)
        expect(body['low']).to eq(5)
        expect(body['cached']).to eq(false)
      end
    end
  end
end
