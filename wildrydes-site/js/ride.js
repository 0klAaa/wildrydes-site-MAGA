var WildRydes = window.WildRydes || {};
WildRydes.map = WildRydes.map || {};

(function rideScopeWrapper($) {
    var authToken;
    WildRydes.authToken.then(function setAuthToken(token) {
        if (token) {
            authToken = token;
        } else {
            window.location.href = '/signin.html';
        }
    }).catch(function handleTokenError(error) {
        alert(error);
        window.location.href = '/signin.html';
    });

    function requestUnicorn(pickupLocation) {
        $.ajax({
            method: 'POST',
            url: _config.api.invokeUrl + '/ride',
            headers: {
                Authorization: authToken
            },
            data: JSON.stringify({
                PickupLocation: {
                    Latitude: pickupLocation.latitude,
                    Longitude: pickupLocation.longitude
                }
            }),
            contentType: 'application/json',
            success: completeRequest,
            error: function ajaxError(jqXHR, textStatus, errorThrown) {
                console.error('Error requesting ride: ', textStatus, ', Details: ', errorThrown);
                console.error('Response: ', jqXHR.responseText);
                alert('An error occured when requesting your unicorn:\n' + jqXHR.responseText);
            }
        });
    }

    function completeRequest(result) {
        console.log('Response received from API: ', result);

    
        var unicorn = result.Unicorn;

        var name;
        var color;
        var pronoun;

        if (typeof unicorn === 'string') {
            name = unicorn;
            color = 'mystic';       
            pronoun = 'their';      
        } else if (unicorn && typeof unicorn === 'object') {

            name = unicorn.Name || 'Your';
            color = unicorn.Color || 'mystic';
            var gender = unicorn.Gender || 'Unknown';
            pronoun = gender === 'Male' ? 'his' : 'her';
        } else {
            name = 'Your';
            color = 'mystic';
            pronoun = 'their';
        }

        displayUpdate(name + ', your ' + color + ' unicorn, is on ' + pronoun + ' way.');
        animateArrival(function animateCallback() {
            playSound('arrival');
            displayUpdate(name + ' has arrived. Giddy up!');
            WildRydes.map.unsetLocation();
            $('#request').prop('disabled', 'disabled');
            $('#request').text('Set Pickup');
        });
    }

    // handler for #request button and play sound : login / click for request unicorn
    $(function onDocReady() {
        $('#request').click(handleRequestClick);
        $(WildRydes.map).on('pickupChange', handlePickupChanged);

        WildRydes.authToken.then(function updateAuthMessage(token) {
            if (token) {
                playSound('login');
                displayUpdate('You are authenticated. Click to see your <a href="#authTokenModal" data-toggle="modal">auth token</a>.');
                $('.authToken').text(token);
            }
        });

        if (!_config.api.invokeUrl) {
            $('#noApiMessage').show();
        }
    });

    function handlePickupChanged() {
        var requestButton = $('#request');
        requestButton.text('Request Unicorn');
        requestButton.prop('disabled', false);
        
        unlockAudioOnce();
        playSound('click');
    }

    function handleRequestClick(event) {
        var pickupLocation = WildRydes.map.selectedPoint;
        event.preventDefault();
        requestUnicorn(pickupLocation);
    }

    function animateArrival(callback) { 
        var dest = WildRydes.map.selectedPoint;
        var origin = {};

        if (dest.latitude > WildRydes.map.center.latitude) {
            origin.latitude = WildRydes.map.extent.minLat;
        } else {
            origin.latitude = WildRydes.map.extent.maxLat;
        }

        if (dest.longitude > WildRydes.map.center.longitude) {
            origin.longitude = WildRydes.map.extent.minLng;
        } else {
            origin.longitude = WildRydes.map.extent.maxLng;
        }

        WildRydes.map.animate(origin, dest, callback);
    }

    function displayUpdate(text) {
        $('#updates').append($('<li>' + text + '</li>'));
    }
}(jQuery));

var audioUnlocked = false;
    var sounds = {
        login: new Audio('/audio/login.mp3'),
        click: new Audio('/audio/click.mp3'),
        arrival: new Audio('/audio/arrival.mp3')
    };

    Object.keys(sounds).forEach(function (k) {
        try { sounds[k].preload = 'auto'; } catch (e) {}
    });

    function unlockAudioOnce() {
        if (audioUnlocked) return;
        audioUnlocked = true;

        try {
            Object.keys(sounds).forEach(function (k) {
                sounds[k].volume = 0;
                sounds[k].currentTime = 0;
                var p = sounds[k].play();
                if (p && p.then) {
                    p.then(function () {
                        sounds[k].pause();
                        sounds[k].currentTime = 0;
                        sounds[k].volume = 1;
                    }).catch(function () {
                        sounds[k].volume = 1;
                    });
                } else {
                    sounds[k].pause();
                    sounds[k].currentTime = 0;
                    sounds[k].volume = 1;
                }
            });
        } catch (e) {
            
        }
    }
    // restart sound even if it was played recently
    function playSound(name) {
        try {
            if (!sounds[name]) return;
            sounds[name].pause();
            sounds[name].currentTime = 0;
            var p = sounds[name].play();
            if (p && p.catch) p.catch(function () {});
        } catch (e) {}
    }