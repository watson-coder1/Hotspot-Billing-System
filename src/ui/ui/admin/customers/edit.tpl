{include file="sections/header.tpl"}

<form class="form-horizontal" enctype="multipart/form-data" method="post" role="form" action="{Text::url('customers/edit-post')}">
    <input type="hidden" name="csrf_token" value="{$csrf_token}">
    <div class="row">
        <div class="col-md-6">
            <div
                class="panel panel-{if $d['status']=='Active'}primary{else}danger{/if} panel-hovered panel-stacked mb30">
                <div class="panel-heading">{Lang::T('Edit Contact')}</div>
                <div class="panel-body">
                    <center>
                        <img src="{$app_url}/{$UPLOAD_PATH}{$d['photo']}.thumb.jpg" width="200"
                            onerror="this.src='{$app_url}/{$UPLOAD_PATH}/user.default.jpg'" class="img-circle img-responsive"
                            alt="Photo" onclick="return deletePhoto({$d['id']})">
                    </center><br>
                    <input type="hidden" name="id" value="{$d['id']}">
                    <div class="form-group">
                        <label class="col-md-3 col-xs-12 control-label">{Lang::T('Photo')}</label>
                        <div class="col-md-6 col-xs-8">
                            <input type="file" class="form-control" name="photo" accept="image/*">
                        </div>
                        <div class="form-group col-md-3 col-xs-4" title="Not always Working">
                            <label class=""><input type="checkbox" checked name="faceDetect" value="yes"> {Lang::T("Face Detection")}</label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Usernames')}</label>
                        <div class="col-md-9">
                            <div class="input-group">
                                {if $_c['country_code_phone']!= ''}
                                    <span class="input-group-addon" id="basic-addon1"><i
                                            class="glyphicon glyphicon-phone-alt"></i></span>
                                {else}
                                    <span class="input-group-addon" id="basic-addon1"><i
                                            class="glyphicon glyphicon-user"></i></span>
                                {/if}
                                <input type="text" class="form-control" name="username" value="{$d['username']}"
                                    required
                                    placeholder="{if $_c['country_code_phone']!= ''}{$_c['country_code_phone']} {Lang::T('Phone Number')}{else}{Lang::T('Usernames')}{/if}">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Full Name')}</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" id="fullname" name="fullname"
                                value="{$d['fullname']}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Email')}</label>
                        <div class="col-md-9">
                            <input type="email" class="form-control" id="email" name="email" value="{$d['email']}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Phone Number')}</label>
                        <div class="col-md-9">
                            <div class="input-group">
                                {if $_c['country_code_phone']!= ''}
                                    <span class="input-group-addon" id="basic-addon1">+</span>
                                {else}
                                    <span class="input-group-addon" id="basic-addon1"><i
                                            class="glyphicon glyphicon-phone-alt"></i></span>
                                {/if}
                                <input type="text" class="form-control" name="phonenumber" value="{$d['phonenumber']}"
                                    placeholder="{if $_c['country_code_phone']!= ''}{$_c['country_code_phone']}{/if} {Lang::T('Phone Number')}">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Password')}</label>
                        <div class="col-md-9">
                            <input type="password" autocomplete="off" class="form-control" id="password" name="password"
                                onmouseleave="this.type = 'password'" onmouseenter="this.type = 'text'"
                                value="{$d['password']}">
                            <span class="help-block">{Lang::T('Keep Blank to do not change Password')}</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Home Address')}</label>
                        <div class="col-md-9">
                            <textarea name="address" id="address" class="form-control">{$d['address']}</textarea>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Service Type')}</label>
                        <div class="col-md-9">
                            <select class="form-control" id="service_type" name="service_type">
                                <option value="Hotspot" {if $d['service_type'] eq 'Hotspot' }selected{/if}>Hotspot
                                </option>
                                <option value="PPPoE" {if $d['service_type'] eq 'PPPoE' }selected{/if}>PPPoE</option>
                                <option value="VPN" {if $d['service_type'] eq 'VPN' }selected{/if}>VPN</option>
                                <option value="Others" {if $d['service_type'] eq 'Others' }selected{/if}>{Lang::T("Other")}</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Account Type')}</label>
                        <div class="col-md-9">
                            <select class="form-control" id="account_type" name="account_type">
                                <option value="Personal" {if $d['account_type'] eq 'Personal' }selected{/if}>{Lang::T("Personal")}
                                </option>
                                <option value="Business" {if $d['account_type'] eq 'Business' }selected{/if}>{Lang::T("Business")}
                                </option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Coordinates')}</label>
                        <div class="col-md-9">
                            <input name="coordinates" id="coordinates" class="form-control" value="{$d['coordinates']}"
                                placeholder="6.465422, 3.406448">
                            <div id="map" style="width: '100%'; height: 200px; min-height: 150px;"></div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Status')}</label>
                        <div class="col-md-9">
                            <select class="form-control" id="status" name="status">
                                {foreach $statuses as $status}
                                    <option value="{$status}" {if $d['status'] eq $status }selected{/if}>{Lang::T($status)}
                                    </option>
                                {/foreach}
                            </select>
                            <span class="help-block">
                                {Lang::T('Banned')}: {Lang::T('Customer cannot login again')}.<br>
                                {Lang::T('Disabled')}:
                                {Lang::T('Customer can login but cannot buy internet package, Admin cannot recharge customer')}.<br>
                                {Lang::T("Don't forget to deactivate all active package too")}.
                            </span>
                        </div>
                    </div>
                </div>
                <div class="panel-heading">PPPoE</div>
                <div class="panel-body">
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Usernames')} <span class="label label-danger"
                                id="warning_username"></span></label>
                        <div class="col-md-9">
                            <input type="username" class="form-control" id="pppoe_username" name="pppoe_username"
                                onkeyup="checkUsername(this, {$d['id']})" value="{$d['pppoe_username']}">
                            <span class="help-block">{Lang::T('Not Working with Freeradius Mysql')}</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Password')}</label>
                        <div class="col-md-9">
                            <input type="password" class="form-control" id="pppoe_password" name="pppoe_password"
                                value="{$d['pppoe_password']}" onmouseleave="this.type = 'password'"
                                onmouseenter="this.type = 'text'">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">Remote IP <span class="label label-danger"
                                id="warning_ip"></span></label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" id="pppoe_ip" name="pppoe_ip"
                                onkeyup="checkIP(this, {$d['id']})" value="{$d['pppoe_ip']}">
                            <span class="help-block">{Lang::T('Not Working with Freeradius Mysql')}</span>
                        </div>
                    </div>
                    <span class="help-block">
                        {Lang::T('User Cannot change this, only admin. if it Empty it will use Customer Credentials')}
                    </span>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="panel panel-primary panel-hovered panel-stacked mb30">
                <div class="panel-heading">{Lang::T('Attributes')}</div>
                <div class="panel-body">
                    <!--Customers Attributes edit start -->
                    {if $customFields}
                        {foreach $customFields as $customField}
                            <div class="form-group">
                                <label class="col-md-4 control-label"
                                    for="{$customField.field_name}">{$customField.field_name}</label>
                                <div class="col-md-6">
                                    <input class="form-control" type="text" name="custom_fields[{$customField.field_name}]"
                                        id="{$customField.field_name}" value="{$customField.field_value}">
                                </div>
                                <label class="col-md-2">
                                    <input type="checkbox" name="delete_custom_fields[]" value="{$customField.field_name}">
                                    {Lang::T('Delete')}
                                </label>
                            </div>
                        {/foreach}
                    {/if}
                    <!--Customers Attributes edit end -->
                    <!-- Customers Attributes add start -->
                    <div id="custom-fields-container">
                    </div>
                    <!-- Customers Attributes add end -->
                </div>
                <div class="panel-footer">
                    <button class="btn btn-success btn-block" type="button"
                        id="add-custom-field">{Lang::T('Add')}</button>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="box box-primary box-solid collapsed-box">
                <div class="box-header with-border">
                    <h3 class="box-title">{Lang::T('Additional Information')}</h3>
                    <div class="box-tools pull-right">
                        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body" style="display: none;">
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('City')}</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" id="city" name="city" value="{$d['city']}">
                            <small class="form-text text-muted">{Lang::T('City of Resident')}</small>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('District')}</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" id="district" name="district"
                                value="{$d['district']}">
                            <small class="form-text text-muted">{Lang::T('District')}</small>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('State')}</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" id="state" name="state" value="{$d['state']}">
                            <small class="form-text text-muted">{Lang::T('State of Resident')}</small>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Zip Code')}</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" id="zip" name="zip" value="{$d['zip']}">
                            <small class="form-text text-muted">{Lang::T('Zip Code')}</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <center>
        <button class="btn btn-primary" onclick="return ask(this, '{Lang::T("Continue the Customer Data change process?")}')"
            type="submit">
            {Lang::T('Save Changes')}
        </button>
        <br><a href="{Text::url('')}customers/list" class="btn btn-link">{Lang::T('Cancel')}</a>
    </center>
</form>

{literal}
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function() {
            var customFieldsContainer = document.getElementById('custom-fields-container');
            var addCustomFieldButton = document.getElementById('add-custom-field');

            addCustomFieldButton.addEventListener('click', function() {
                var fieldIndex = customFieldsContainer.children.length;
                var newField = document.createElement('div');
                newField.className = 'form-group';
                newField.innerHTML = `
                <div class="col-md-4">
                    <input type="text" class="form-control" name="custom_field_name[]" placeholder="Name">
                </div>
                <div class="col-md-6">
                    <input type="text" class="form-control" name="custom_field_value[]" placeholder="Value">
                </div>
                <div class="col-md-2">
                    <button type="button" class="remove-custom-field btn btn-danger btn-sm">-</button>
                </div>
            `;
                customFieldsContainer.appendChild(newField);
            });

            customFieldsContainer.addEventListener('click', function(event) {
                if (event.target.classList.contains('remove-custom-field')) {
                    var fieldContainer = event.target.parentNode.parentNode;
                    fieldContainer.parentNode.removeChild(fieldContainer);
                }
            });
        });
    </script>

    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
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
            L.tileLayer('https://{s}.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}&s=Ga', {
            subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                maxZoom: 20
        }).addTo(map);
        var marker = L.marker([lat, lon]).addTo(map);
        map.on('click', function(e) {
            var coord = e.latlng;
            var lat = coord.lat;
            var lng = coord.lng;
            var newLatLng = new L.LatLng(lat, lng);
            marker.setLatLng(newLatLng);
            $('#coordinates').val(lat + ',' + lng);
        });
        }
        window.onload = function() {
        {/literal}
        {if $d['coordinates']}
            setupMap({$d['coordinates']});
        {else}
            getLocation();
        {/if}
        {literal}
        }
    </script>
{/literal}

<script>
    function deletePhoto(id) {
        if (confirm('Delete photo?')) {
            if (confirm('Are you sure to delete photo?')) {
                window.location.href = '{Text::url('')}customers/edit/'+id+'/deletePhoto'
            }
        }
    }
</script>

{include file="sections/footer.tpl"}
