require 'rails_helper'

RSpec.describe ForecastController, type: :request do
  describe 'GET #show' do
    context 'when address is provided' do
      it 'returns forecast data' do
        get '/forecast', params: { address: 'New York,NY,US' }
        expect(response).to have_http_status(:success)
      end
    end

    context 'when address is not provided' do
      it 'returns an error' do
        get '/forecast'
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
