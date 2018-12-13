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

## Screenshots / Read More
![Screenshot of TicketBash](https://previews.dropbox.com/p/thumb/AARDdcsgBAs8M6QdgKGW4j7oo9p0ZZ0AMLTKhiXMxYxqUpGaq0SwJuFQbElEz5LyQliyee6jhgXZ9StUBaJQMCsB6lznyMmVulhBowmLjlh9_p75PbbgtbkEweXXd2Ht7_hgnPSC9ntavInskuV8RvAoHUBFg0pVvhzE3JdElF6Uo4sIL0ktmbZm969lal6bD2ZdYLpfzWrOIpJkcUiIy89FLdCURRvoALe2QzqfC0iOW19pDvwhJa77UD14yo_4SiOt8QQQr1E0h2NutWQ3zVOIwhOaNPUOAF_JYppTLmLwxZhP2sZe4rVtDFEy1__5nH4K6LOZ-2M1-N5bx3c2FxNh/p.png?size=2048x1536&size_mode=3)

See more about the app here: [http://nicolaisafai.com/ticketbashwebsite](http://nicolaisafai.com/ticketbashwebsite)
