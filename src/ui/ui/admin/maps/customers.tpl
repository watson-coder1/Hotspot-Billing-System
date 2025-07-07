{include file="sections/header.tpl"}


<form id="site-search" method="post" action="{Text::url('map/customer/')}">
    <input type="hidden" name="_route" value="map/customer">
    <div class="input-group">
        <div class="input-group-addon">
            <span class="fa fa-search"></span>
        </div>
        <input type="text" name="search" class="form-control" value="{$search}" placeholder="{Lang::T('Search')}...">
        <div class="input-group-btn">
            <button class="btn btn-success" type="submit">{Lang::T('Search')}</button>
        </div>
    </div>
</form>

<!-- Map container div -->
<div id="map" class="well" style="width: '100%'; height: 70vh; margin: 20px auto"></div>

{include file="pagination.tpl"}

{literal}
    <script>
        function getLocation() {
            if (window.location.protocol == "https:" && navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(showPosition);
            } else {
                setupMap(51.505, -0.09);
            }
        }

        function showPosition(position) {
            setupMap(position.coords.latitude, position.coords.longitude);
        }

        function setupMap(lat, lon) {
            var map = L.map('map').setView([lat, lon], 13);
            var group = L.featureGroup().addTo(map);

            var customers = {/literal}{$customers|json_encode}{literal};

            L.tileLayer('https://{s}.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}&s=Ga', {
            subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                maxZoom: 20
        }).addTo(map);

        customers.forEach(function(customer) {
            var name = customer.id;
            var name = customer.name;
            var info = customer.info;
            var direction = customer.direction;
            var coordinates = customer.coordinates;
            var balance = customer.balance;
            var address = customer.address;

            // Create a popup for the marker
            var popupContent = "<strong>Name</strong>: " + name + "<br>" +
                "<strong>Info</strong>: " + info + "<br>" +
                "<strong>Balance</strong>: " + balance + "<br>" +
                "<strong>Address</strong>: " + address + "<br>" +
                "<a href='{/literal}{Text::url('customers/view/')}{literal}"+ customer.id +"'>More Info</a> &bull; " +
                "<a href='https://www.google.com/maps/dir//" + direction + "' target='maps'>Get Direction</a><br>";

            // Add marker to map
            var marker = L.marker(JSON.parse(coordinates)).addTo(group);
            marker.bindTooltip(name, { permanent: true }).bindPopup(popupContent);
        });

        map.fitBounds(group.getBounds());
        }
        window.onload = function() {
            getLocation();
        }
    </script>
{/literal}
{include file="sections/footer.tpl"}