function specifylocation() 
{
    var markers = [];
    var kor = new google.maps.LatLng(41.314105, -72.93077);
    var mapOptions = {
       zoom: 12,
       center: kor,
       mapTypeId: google.maps.MapTypeId.TERRAIN
    };
    var map = new google.maps.Map(document.getElementById('map'), mapOptions);

    // Adds a marker at the center of the map.
    addMarker(kor);

    // This event listener will call addMarker() when the map is clicked.
    google.maps.event.addListener(map, 'click', function(event) {
       clearMarkers();
       addMarker(event.latLng);
       document.getElementById("map_lat").value = event.latLng.lat();
       document.getElementById("map_lng").value = event.latLng.lng();
    });

    //Override our map zoom level once our fitBounds function runs (Make sure it only runs once)
    var boundsListener = google.maps.event.addListener((map), 'bounds_changed', function(event) {
        this.setZoom(14);
        google.maps.event.removeListener(boundsListener);
    });
    
    // Sets the map on all markers in the array.
    function setAllMap(map) {
     for (var i = 0; i < markers.length; i++) {
        markers[i].setMap(map);
     }
   }

   // Add a marker to the map and push to the array.
   function addMarker(location) {
    var marker = new google.maps.Marker({
       position: location,
       map: map
    });
    markers.push(marker);
   }

   function clearMarkers() {
        setAllMap(null);
    }

}

var map;
var bounds;

function show_members(memberships) 
{
  l = memberships.length;
  var memlatlong = [];
  var k = 0;
  for (var i=0; i<l; i++) 
  {
    membership = memberships[i];
    if ((membership.lat == null) || (membership.lng == null) ) {    // validation check if coordinates are there
    }
    else 
    {
      //Save Latitude and Longitude
      memlatlong[k] = [membership.lat, membership.lng];
      k = k+1;
    }
  }
    bounds = new google.maps.LatLngBounds();
    var mapOptions = {
        mapTypeId: 'roadmap'
    };
                    
    // Display a map on the page
    map = new google.maps.Map(document.getElementById("map"), mapOptions);
    map.setTilt(45);
        
    // Multiple Markers
    var markers = memlatlong;
                        
    // Display multiple markers on a map
    //var infoWindow = new google.maps.InfoWindow(), marker, i;
    
    // Loop through our array of markers & place each one on the map  
    for( i = 0; i < markers.length; i++ ) {
        var position = new google.maps.LatLng(markers[i][0], markers[i][1]);
        bounds.extend(position);
        marker = newGoogleMapsMarker({
            position: position,
            map: map,
            icon: "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
            //title: "Friend",
        });
        
    }

    // Automatically center the map fitting all markers on the screen
    map.fitBounds(bounds);

}

function newGoogleMapsMarker(param) {
    var r = new google.maps.Marker({
        map: param.map,
        position: param.position,
        icon: param.icon,
    });
    if (param.title) {
        google.maps.event.addListener(r, 'click', function() {
            // this -> the marker on which the onclick event is being attached
            if (!this.getMap()._infoWindow) {
                this.getMap()._infoWindow = new google.maps.InfoWindow();
            }
            this.getMap()._infoWindow.close();
            this.getMap()._infoWindow.setContent(param.title);
            this.getMap()._infoWindow.open(this.getMap(), this);
        });
    }
    return r;
}

var centralloc;
var places;

function calculateCentralLocation(memberships)
{
  l = memberships.length;
  var memlatlong = [];
  var vertices = [];
  var k = 0;
  for (var i=0; i<l; i++) 
  {
    membership = memberships[i];
    if ((membership.lat == null) || (membership.lng == null) ) {    // validation check if coordinates are there
    }
    else 
    {
      //Save Latitude and Longitude
      memlatlong[k] = [membership.lat, membership.lng];
      vertices[k] = {'lat':0, 'lng':0};
      vertices[k]['lat'] = membership.lat;
      vertices[k]['lng'] = membership.lng;
      k = k+1;
    }
  }
   
  // [ {'x':12.89962,'y':77.48270},{'x':12.92792,'y':77.62711},{'x':12.95917,'y':77.69742},{'x':12.977008,'y':77.725893}];
  X = 0.0;
  Y = 0.0;
  Z = 0.0;
  var num_coords=vertices.length;
  for(i=0;i<vertices.length;i++)
  {
      lat = vertices[i].lat * Math.PI / 180;
      lon = vertices[i].lng* Math.PI / 180;
      a = Math.cos(lat) * Math.cos(lon);
      b = Math.cos(lat) * Math.sin(lon);
      c = Math.sin(lat);

      X += a;
      Y += b;
      Z += c;
  }

  X /= num_coords;
  Y /= num_coords;
  Z /= num_coords;

  lon = Math.atan2(Y, X);
  hyp = Math.sqrt(X * X + Y * Y);
  lat = Math.atan2(Z, hyp);

  finallat = lat* 180 / Math.PI;
  finallng = lon* 180 / Math.PI;

  centralloc = new google.maps.LatLng(finallat, finallng);
  
  var marker = newGoogleMapsMarker({
       position: centralloc,
       map: map,
       animation: google.maps.Animation.DROP,
       icon: "http://maps.google.com/mapfiles/ms/icons/purple-dot.png",
       title: "Central Location"
    });
  map.fitBounds(bounds);
  places = new google.maps.places.PlacesService(map);
  document.controls.style.visibility = "visible";
  //displayPlaces(finallat, finallng); 
   //Override our map zoom level once our fitBounds function runs (Make sure it only runs once)
    //var boundsListener = google.maps.event.addListener((map), 'bounds_changed', function(event) {
    //    this.setZoom(14);
    //    google.maps.event.removeListener(boundsListener);
    //});
}


var iw;
var pmarkers = [];


function blockEvent(event) {
if (event.which == 13) {
  event.cancelBubble = true;
  event.returnValue = false;
}
}

function updateRankByCheckbox() {
var types = getTypes();
var disabled = !types.length;
var label = document.getElementById('rankbylabel');
label.style.color = disabled ? '#cccccc' : '#333';
}

function getTypes() {
var types = []
for (var i = 0; i < document.controls.type.length; i++) {
  if (document.controls.type[i].checked) {
    types.push(document.controls.type[i].value);
  }
}
return types;
}

function search(event) {
if (event) {
  event.cancelBubble = true;
  event.returnValue = false;
}

var search = {};

// Set desired types.
var types = getTypes();
if (types.length) {
  search.types = types;
}

// Set ranking.
if (!document.controls.rankbydistance.disabled &&
    document.controls.rankbydistance.checked) {
  search.rankBy = google.maps.places.RankBy.DISTANCE;
  search.location = centralloc;
} else {
  search.rankBy = google.maps.places.RankBy.PROMINENCE;
  search.bounds = map.getBounds()
}

// Search.
places.search(search, function(results, status) {
  if (status == google.maps.places.PlacesServiceStatus.OK) {
    clearResults();
    clearPMarkers();
    alert('adding result');
    for (var i = 0; i < results.length; i++) {
      var letter = String.fromCharCode(65 + i);
      alert("letter is" + letter);
      pmarkers[i] = new google.maps.Marker({
        position: results[i].geometry.location,
        animation: google.maps.Animation.DROP,
        icon: 'http://maps.gstatic.com/intl/en_us/mapfiles/marker' +
            letter + '.png',
        key: 'AIzaSyBDUoe2_d_LIRiOcRbiKe780eAp40ob_uM'
      });
      google.maps.event.addListener(
          pmarkers[i], 'click', getDetails(results[i], i));
      dropPMarker(pmarkers[i], i * 100);
      alert('adding result');
      addResult(results[i], i);
    }
  }
});
}

function clearPMarkers() {
for (var i = 0; i < pmarkers.length; i++) {
  if (pmarkers[i]) {
    pmarkers[i].setMap(null);
    delete pmarkers[i]

  }
}
}

function dropPMarker(marker, delay) {
window.setTimeout(function() {
  marker.setMap(map);
}, delay);
}

function addResult(result, i) {
var results = document.getElementById('results');
alert('adding result');
var tr = document.createElement('tr');
tr.style.backgroundColor = i % 2 == 0 ? '#F0F0F0' : '#FFFFFF';
tr.onclick = function() {
  google.maps.event.trigger(markers[i], 'click');
};

var iconTd = document.createElement('td');
var nameTd = document.createElement('td');
var icon = document.createElement('img');
icon.src = result.icon;
icon.className = 'placeIcon';
var name = document.createTextNode(result.name);
iconTd.appendChild(icon);
nameTd.appendChild(name);
tr.appendChild(iconTd);
tr.appendChild(nameTd);
results.appendChild(tr);
}

function clearResults() {
var results = document.getElementById('results');
while (results.childNodes[0]) {
  results.removeChild(results.childNodes[0]);
}
}

function getDetails(result, i) {
return function() {
  places.getDetails({
    reference: result.reference
  }, showInfoWindow(i));
}
}

function showInfoWindow(i) {
return function(place, status) {
  if (iw) {
    iw.close();
    iw = null;
  }

  if (status == google.maps.places.PlacesServiceStatus.OK) {
    iw = new google.maps.InfoWindow({
      content: getIWContent(place)
    });
    iw.open(map, pmarkers[i]);
  }
}
}

function getIWContent(place) {
var content = '<table style="border:0"><tr><td style="border:0;">';
content += '<img class="placeIcon" src="' + place.icon + '"></td>';
content += '<td style="border:0;"><b><a href="' + place.url + '">';
content += place.name + '</a></b>';
content += '</td></tr></table>';
return content;
}
