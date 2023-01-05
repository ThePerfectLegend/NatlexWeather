# NatlexWeather
The project uses MVVM Architecture, SwiftUI, Combine, CoreData, CoreLocation. Live weather data is downloaded from OpenWeather API.

![GitHubDemoNatlexWeather](https://user-images.githubusercontent.com/94032706/210735640-3aea4f2f-a961-4778-9bc1-3cbfc8d1a315.png)
![GitHubDemoNatlexWeather2](https://user-images.githubusercontent.com/94032706/210735652-d6f29e4f-b9fc-4c18-8c8c-8a6c7a2b475c.png)

## Technologies & Functionality

- Project uses MVVM Architecture with additional layers between Model and Views. API request created in independent network layer of class `NetworkingManager` and using in different `WeatherDataService` and `GeocodingDataService`.
- `WeatherDataService` and `GeocodingDataService` connected with ViewModel by `@Publisher` and `@Subcribers` pattern from `Combine` framework. It allows to keep data actual condition.
- User can give access to location and get current weather. For getting user location used `LocationManager` build on `CoreLocation` framework.
- User can search city and add it to portfolio. All portfolio data saves in `CoreData`.
- In `WeatherDetailView` created line chart by `Charts`. Downloaded data is filtered by days, using the last response for each day. User can apply custom filter for weather by dates.
