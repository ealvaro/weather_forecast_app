require 'swagger_helper'

RSpec.describe ForecastController, type: :request do

  path '/forecast' do

    get('show forecast') do
      
      parameter name: :address, in: :query, type: :string

      response(200, 'successful') do
        let(:address) { 'New York,NY,US' }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(422, 'unsuccessful') do
        let(:address) { }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
