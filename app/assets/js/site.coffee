# //= require js/vendor/jquery.min.js
# //= require js/vendor/bootstrap.min.js
# //= require_tree shared

data = {}

$ ->
  map = L.map 'map', { zoomControl: false }

  map.setView [42, 20], 12

  tiles = L.esri.basemapLayer("Streets").addTo map

  startSearch = L.esri.Geocoding.geosearch({
      position: 'topright',
      useMapBounds: false,
      zoomToResult: true,
      collapseAfterResult: false,
      expanded: true,
      placeholder: "Attacker base"
      title: "Start from..."
    }).addTo map

  endSearch = L.esri.Geocoding.geosearch({
      position: 'topright',
      useMapBounds: false,
      zoomToResult: false,
      collapseAfterResult: false,
      expanded: true,
      placeholder: "Target base"
      title: "End at..."
    }).addTo map

  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
    maxZoom: 18,
    id: 'mapbox.streets',
    accessToken: 'pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NDg1bDA1cjYzM280NHJ5NzlvNDMifQ.d6e-nNyBDtmQCVwVNivz7A'
    }).addTo map

  results = L.layerGroup().addTo map

  startSearch.on("results", (data) ->
    results.clearLayers()

    for result in data.results
      results.addLayer L.marker result.latlng

    window.data.start = data
    updateMap()
  )

  endSearch.on("results", (data) ->
    for result in data.results
      results.addLayer L.marker result.latlng

    window.data.end = data
    updateMap()
  )

  updateMap = ->
    if window.data.start && window.data.end
      map.fitBounds [window.data.start.bounds, window.data.end.bounds]

      L.Routing.osrmv1().route(
        [
          {latLng: window.data.start.latlng},
          {latLng: window.data.end.latlng}
        ],
        (err, routes) ->
          L.Routing.line(routes[0]).addTo map
          console.log(routes[0])
      )

  this
