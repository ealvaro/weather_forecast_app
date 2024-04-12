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

## Scalability Considerations

### Caching: 
- Implementing caching mechanisms, as done in the provided code, can greatly improve performance by reducing the number of requests made to external APIs. However, it is essential to design the caching strategy carefully to balance the freshness of the data with the load on the caching system.

### Load Balancing: 

- As traffic to the Forecast endpoint increases, distributing the load across multiple servers can improve response times and handle higher concurrent request volumes. Load balancing techniques like round-robin, least connections, or IP hash can be employed to evenly distribute incoming requests.

### Horizontal Scaling: 

- Scaling horizontally by adding more servers or instances of the application can help handle increased traffic. Containerization technologies like Docker and orchestration platforms like Kubernetes can facilitate the deployment and management of multiple instances of the application.

### Asynchronous Processing: 

- We can consider offloading long-running or resource-intensive tasks to background jobs or worker processes. For example, fetching weather data from external APIs can sometimes be slow, so using asynchronous processing can prevent blocking the main application thread and improve responsiveness.

### Rate Limiting and Throttling: 

- We can implement rate limiting and request throttling to prevent abuse, protect against denial-of-service attacks, and ensure fair usage of resources. This can help maintain the availability and stability of the service during periods of high traffic.

