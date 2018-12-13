# TicketBash
## Description
An iOS app written in Swift that lets you dispute your SF/NYC parking tickets from your phone. Built in 2016.

## Features
1. Take pictures of your parking ticket and any photographic evidence
2. User authentication to save your previous disputes and use them as a starter template
3. Add your address using Google Autocomplete (from Google Maps API)
4. Generate PDF of complaint using appropriate local dispute form (custom, built in Python
   --> You can find the [PDF-generation server-side code here]((https://bitbucket.org/adamreis/ticketbash-server/src/master/)). Note that you may have to request access.
5. Pay using credit card or Apple Pay using the Stripe API
6. We get the dispute form printed and mailed automatically using the Stripe API.

## Technologies
This project uses Swift, Google Maps API, Lob API, Stripe API

See screenshots of the app here: [http://nicolaisafai.com/ticketbashwebsite](http://nicolaisafai.com/ticketbashwebsite)
