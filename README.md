# Arch App

<br>

<p align="center">
    <img src="https://user-images.githubusercontent.com/19389561/207950550-39e397d4-d741-4d98-a209-ed288d8dff67.png" />
</p>

<p align="center">https://www.arch-app.com/ </p>

<br>

Arch app was an iOS app written in swift. Users could create events at our partnered venues and then receive tiered discounts/promotions for food/drinks. Attendance rates were determined using user location services, and as more people attended an event, better discounts/promotions were offered by the venue.

Users were authenticated with Firebase, allowing them to log-in with their Facebook account. Both the user-facing iOS app and the partner-facing Django website used a Django-REST API to communicate with a Postgres database, which was hosted on AWS and stored data pertaining to users, venues, and events.

<br>

<h4 align="center"> Arch App is no longer mantained, but screenshots from its days in production are displayed below. </h3>

<br>

## Venue Tab

Users could scroll through our partnered venues on the `Venue Tab` to browse the latest offers/promotions. Selecting a venue would open the `VenueView`, which allowed our users to create an event and invite their Facebook friends. 

<br>

<span>
      <image src="https://user-images.githubusercontent.com/19389561/207944415-db854015-f240-445c-a327-fe56d57aaec6.png" width="250px" />
      <image src="https://user-images.githubusercontent.com/19389561/207944256-7c3ed00b-634a-4ffe-89fb-d8aa6efcfcd4.png" width="250px" />
</span>

<br><br>

## Event Tab

Users could see their upcoming events on the `Events Tab`. Then, users would select an event to navigate to the `EventView`, which listed which friends would be attending and provided a way for our users to cash-in on the event's achieved promotions/discounts.

<br>

<image src="https://user-images.githubusercontent.com/19389561/207943725-8d5151ca-7d0d-4c47-afa2-d33752fcaf0b.png" width="250px" />

<br><br>

## Activity Feed

The `Stream` tab (`Activity Feed` would have probably been a more fitting name in retrospect) displayed the venues that a user's Facebook friends were going to on a given night.

<br>

<image src="https://user-images.githubusercontent.com/19389561/207944625-2e597dd1-0c70-4c5a-8c03-04d8786386db.png" width="250px" />
