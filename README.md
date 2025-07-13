# riderapp
Flutter Task - Rider Map View, Route Selection & Navigation
Objective
- Build a Flutter app screen for riders to:
- Display rider's current location on a map.
- Show markers for pickup locations and warehouse.
- Draw a full route from rider's current location through all pickups and ending at the warehouse.
- Enable a navigation experience using a 'Navigate' button to launch either in-app navigation or Google Maps.
Requirements
1. Job Route Screen (Main Task)
- Show Google Map with:
- Rider's current location (via GPS)
- Markers for pickup locations
- Marker for the warehouse location
- A polyline route that:
- Starts from rider's current location
- Goes through each pickup (in the given order)
- Ends at the warehouse
- Add a 'Navigate' button that:
- Either starts in-app navigation with live location updates and route following
- Or opens Google Maps with the full route using url_launcher
- Optional: Show distance/time to warehouse (mocked or API-based)
Data
final pickups = [
{
"id": 1,
"location": LatLng(12.971598, 77.594566),
"time_slot": "9AM-10AM",
"inventory": 5,
},
{
"id": 2,
"location": LatLng(12.972819, 77.595212),
"time_slot": "9AM-10AM",

"inventory": 3,
},
{
"id": 3,
"location": LatLng(12.963842, 77.609043),
"time_slot": "10AM-11AM",
"inventory": 7,
},
{
"id": 4,
"location": LatLng(12.970000, 77.592000),
"time_slot": "10AM-11AM",
"inventory": 4,
},
{
"id": 5,
"location": LatLng(12.968000, 77.596000),
"time_slot": "11AM-12PM",
"inventory": 6,
},
];
final warehouseLocation = LatLng(12.961115, 77.600000);
■ Developer Note (Mocking Data for Testing)
Important: The `pickups` array provides sample locations. However, during development and testing, do not use
these exact coordinates. Instead, mock 5 pickup locations within a 5 km radius of the rider’s current location, so
the flow resembles real-world usage where pickup points are near the rider. This ensures realistic routing,
marker clustering, and travel times.
Deliverables
- A single functional screen showing:
- Map with route from rider to pickups to warehouse
- All locations clearly marked
- Route drawn and displayed properly
- A 'Navigate' button with working navigation**
