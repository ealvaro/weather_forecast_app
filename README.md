# Weather Forecast Application

This is a simple weather forecast application that provides weather data for a given address. It integrates with the OpenWeatherMap API to fetch location and weather data.

## Setup

### Prerequisites

- Ruby (version 2.6 or higher)
- Rails (version 6.0 or higher)
- Bundler (for managing gem dependencies)
- httparty (for http request to 3rd party APIs)

### Installation

1. Clone the repository to your local machine:

   ```bash

   git clone <repository_url>

2. Navigate to the project directory:

   ```bash

	cd weather-forecast-app

3. Install dependencies:

   ```bash

	bundle install

4. Set up the environment variables:

	Rename the .env.example file to .env and provide your OpenWeatherMap API key ( or use mine but do not abuse it )

5. Create temporary file called caching-dev.txt for caching purposes

   ```bash

	touch tmp/caching-dev.txt

6. Run the application:

   ```bash

	rails server

	The application will start running at http://localhost:3000.

## Usage

### API Endpoints

#### Fetch Weather Forecast

- URL: /forecast
- Method: GET
- Parameters:
-- address (required): The address for which weather forecast is requested in String format "New York, NY, US"
- Response:

If successful:

	```JSON
	{
	  "address": "New York, NY, US",
	  "temperature": 15,
	  "high": 20,
	  "low": 10,
	  "cached": false
	}

If error:

	```JSON
	{
	  "error": "Address is required"
	}

### Sample Requests

Fetch Weather Forecast for a Specific Address

   ```bash
   curl -X GET "http://localhost:3000/forecast?address=New%20York,NY,US"

Fetch Weather Forecast without Providing Address

   ```bash
   curl -X GET "http://localhost:3000/forecast"

## Testing

The application includes both controller tests and request tests.

To run the tests, execute the following command:

   ```bash
   bundle exec rspec

## Credits

This application was created by Alvaro Escobar

## License

This project is licensed under the MIT License.

