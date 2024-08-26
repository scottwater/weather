# README

This is a sample Weather app. You should be able to type in an address and get a detailed weather report for the next week or so.

I wanted to ensure you could download the code and just run it, without the need to set up environment variables and/or sign up for a 3rd party service (like Google's address service). Because of this goal, I am not able to cache at the zip code and instead chose to cache at the address.

## Set up

1. Clone the Repo: `git clone <repo_url>`
1. Run `bin/setup`
1. Run `bin/dev`

From there, you should be able to navigate to http://localhost:3000

## Run the tests

After completing the setup above, run `bin/rails test`

The tests make use of the VCR gem. This lets you execute the various 3rd party APIs and cache the results locally for subsequent runs.

## Code Choices

This app makes use of mostly what is standard in a Rails 7.2 app (Turbo/Stimulus/etc.). For most of the UI, I chose to use the ViewComponent gem. The components here are rather simple, but overall I find them far better suited for code reuse than partials and they are far easier to test.

Another notable addition is Solid Cache. I chose to enable this in development to make it easier to see the results of caching. It uses a SQLite database, so again there is no need to set anything up.

## How do we find the weather?

There are two ways we look up the weather in this app.

### Option 1

1. An address (or even just a city/state/zip code) is entered into the search box
2. The search box sets the visitor to the /weather page.
3. The /weather page renders a message (with image and spinner) letting the visitor know we are looking up the weather. A request is made to the Forecast controller from a TurboFrame.
4. The Forecast controller uses the WeatherService (more below) to look up the weather based on the address.
5. If a weather forecast can be found, WeatherComponent is rendered and displays the results (there is a localized timestamp at the bottom of the results to show when they were last refreshed)
6. If no weather forecast can be found, NoWeatherComponent is rendered and displays a message
7. Regardless of which component is used, the HTML is cached, and on subsequent requests for this address, it is re-used.

I like this approach of two different components rendered via TurboStreams because it keeps all the logic out of the UI and allows Rails to make requests and then plug in the dynamic parts.

### Option 2

As an attempt to make things interesting for new visitors, we try and look up their weather by their IP address. It uses the same basic steps as Option 1, except we do not display anything if we can find an address for the IP Address. If we are successful, a banner is displayed with a quick summary of the current weather and link to the full forecast. If a visitor closes the banner, we do not display it again (for 24 hours)

## Services

With my chosen path to find the weather, there are three steps involved:

1. Take the address and find lon and lat.
2. Convert the lon and lat to a set of grid points needed for the weather API
3. Use the grid points to query for the forecast for this address/location

There are separate client libraries (app/clients) for each service used. There are then two service classes that wrap up using each of these client libraries to perform the current task.

1. WeatherService - takes an address and does the 3 steps above to find and return a weather forecast
2. LocalWeatherService - takes an IP address, looks up the address, and then invokes the WeatherService.

Similar to ViewComponents, I like this approach of breaking down the clients individually. This allows them to be tested and then rolling them up in service objects to complete higher-level tasks.

## Future Improvements

1. My initial plan was to push the forecast lookups to a background job. However, they consistently returned very quickly and that seemed like unnecessary overhead.
2. The images supplied by the weather API are a nice touch, but I suspect there are nicer options available that would render nicer.