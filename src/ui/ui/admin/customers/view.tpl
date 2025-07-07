{include file="sections/header.tpl"}

<div class="row">
    <div class="col-sm-4 col-md-4">
        <div class="box box-{if $d['status']=='Active'}primary{else}danger{/if}">
            <div class="box-body box-profile">
                <img class="profile-user-img img-responsive img-circle"
                    onclick="window.location.href = '{$app_url}/{$UPLOAD_PATH}{$d['photo']}'"
                    src="{$app_url}/{$UPLOAD_PATH}{$d['photo']}.thumb.jpg"
                    onerror="this.src='{$app_url}/{$UPLOAD_PATH}/user.default.jpg'" alt="avatar">
                <h3 class="profile-username text-center">{$d['fullname']}</h3>
                <ul class="list-group list-group-unbordered">
                    <li class="list-group-item">
                        <b>{Lang::T('Status')}</b> <span
                            class="pull-right {if $d['status'] !='Active'}bg-red{/if}">&nbsp;{Lang::T($d['status'])}&nbsp;</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Username')}</b> <span class="pull-right">{$d['username']}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Phone Number')}</b> <span class="pull-right">{$d['phonenumber']}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Email')}</b> <span class="pull-right">{$d['email']}</span>
                    </li>
                    <li class="list-group-item">{Lang::nl2br($d['address'])}</li>
                    <li class="list-group-item">
                        <b>{Lang::T('City')}</b> <span class="pull-right">{$d['city']}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('District')}</b> <span class="pull-right">{$d['district']}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('State')}</b> <span class="pull-right">{$d['state']}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Zip')}</b> <span class="pull-right">{$d['zip']}</span>
                    </li>
                    {if in_array($_admin['user_type'],['SuperAdmin','Admin'])}
                        <li class="list-group-item">
                            <b>{Lang::T('Password')}</b> <input type="password" value="{$d['password']}"
                                style=" border: 0px; text-align: right;" class="pull-right"
                                onmouseleave="this.type = 'password'" onmouseenter="this.type = 'text'"
                                onclick="this.select()">
                        </li>
                    {/if}
                    {if $d['pppoe_username'] != ''}
                        <li class="list-group-item">
                            <b>PPPOE {Lang::T('Username')}</b> <span class="pull-right">{$d['pppoe_username']}</span>
                        </li>
                    {/if}
                    {if $d['pppoe_password'] != '' && in_array($_admin['user_type'],['SuperAdmin','Admin'])}
                        <li class="list-group-item">
                            <b>PPPOE {Lang::T('Password')}</b> <input type="password" value="{$d['pppoe_password']}"
                                style=" border: 0px; text-align: right;" class="pull-right"
                                onmouseleave="this.type = 'password'" onmouseenter="this.type = 'text'"
                                onclick="this.select()">
                        </li>
                    {/if}
                    {if $d['pppoe_ip'] != ''}
                        <li class="list-group-item">
                            <b>{Lang::T('PPPoE Remote IP')}</b> <span class="pull-right">{$d['pppoe_ip']}</span>
                        </li>
                    {/if}
                    <!--Customers Attributes view start -->
                    {if $customFields}
                        {foreach $customFields as $customField}
                            <li class="list-group-item">
                                <b>{$customField.field_name}</b> <span class="pull-right">
                                    {if strpos($customField.field_value, ':0') === false}
                                        {$customField.field_value}
                                    {else}
                                        <b>{Lang::T('Paid')}</b>
                                    {/if}
                                </span>
                            </li>
                        {/foreach}
                    {/if}
                    <!--Customers Attributes view end -->
                    <li class="list-group-item">
                        <b>{Lang::T('Service Type')}</b> <span class="pull-right">{Lang::T($d['service_type'])}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Account Type')}</b> <span class="pull-right">{Lang::T($d['account_type'])}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Balance')}</b> <span class="pull-right">{Lang::moneyFormat($d['balance'])}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Auto Renewal')}</b> <span class="pull-right">{if
                            $d['auto_renewal']}yes{else}no
                            {/if}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Created On')}</b> <span
                            class="pull-right">{Lang::dateTimeFormat($d['created_at'])}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Last Login')}</b> <span
                            class="pull-right">{Lang::dateTimeFormat($d['last_login'])}</span>
                    </li>
                    {if $d['coordinates']}
                        <li class="list-group-item">
                            <b>{Lang::T('Coordinates')}</b> <span class="pull-right">
                                <i class="glyphicon glyphicon-road"></i> <a style="color: black;"
                                    href="https://www.google.com/maps/dir//{$d['coordinates']}/"
                                    target="_blank">{Lang::T('Get Directions')}</a>
                            </span>
                            <div id="map" style="width: '100%'; height: 100px;"></div>
                        </li>
                    {/if}
                </ul>
                <div class="row">
                    <div class="col-xs-4">
                        <a href="{Text::url('customers/delete/', $d['id'], '&token=', $csrf_token)}" id="{$d['id']}"
                            class="btn btn-danger btn-block btn-sm"
                            onclick="return ask(this, '{Lang::T('Delete')}?')"><span class="fa fa-trash"></span></a>
                    </div>
                    <div class="col-xs-8">
                        <a href="{Text::url('customers/edit/', $d['id'], '&token=', $csrf_token)}"
                            class="btn btn-warning btn-sm btn-block">{Lang::T('Edit')}</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-sm-8 col-md-8">
        <div class="box box-info">
            <ul class="nav nav-tabs">
                <li role="presentation" {if $v=='order' }class="active" {/if}><a
                        href="{Text::url('customers/view/', $d['id'], '/order')}">30 {Lang::T('Order History')}</a></li>
                <li role="presentation" {if $v=='activation' }class="active" {/if}><a
                        href="{Text::url('customers/view/', $d['id'], '/activation')}">30
                        {Lang::T('Activation History')}</a></li>
            </ul>
            <div class="table-responsive" style="background-color: white;">
                <table id="datatable" class="table table-bordered table-striped">
                    {if Lang::arrayCount($activation)}
                        <thead>
                            <tr>
                                <th>{Lang::T('Invoice')}</th>
                                <th>{Lang::T('Username')}</th>
                                <th>{Lang::T('Plan Name')}</th>
                                <th>{Lang::T('Plan Price')}</th>
                                <th>{Lang::T('Type')}</th>
                                <th>{Lang::T('Created On')}</th>
                                <th>{Lang::T('Expires On')}</th>
                                <th>{Lang::T('Method')}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $activation as $ds}
                                <tr onclick="window.location.href = '{Text::url('plan/view/', $ds['id'])}'"
                                    style="cursor:pointer;">
                                    <td>{$ds['invoice']}</td>
                                    <td>{$ds['username']}</td>
                                    <td>{$ds['plan_name']}</td>
                                    <td>{Lang::moneyFormat($ds['price'])}</td>
                                    <td>{$ds['type']}</td>
                                    <td class="text-success">
                                        {Lang::dateAndTimeFormat($ds['recharged_on'],$ds['recharged_time'])}
                                    </td>
                                    <td class="text-danger">{Lang::dateAndTimeFormat($ds['expiration'],$ds['time'])}</td>
                                    <td>{$ds['method']}</td>
                                </tr>
                            {/foreach}
                        </tbody>
                    {/if}
                    {if Lang::arrayCount($order)}
                        <thead>
                            <tr>
                                <th>{Lang::T('Plan Name')}</th>
                                <th>{Lang::T('Gateway')}</th>
                                <th>{Lang::T('Routers')}</th>
                                <th>{Lang::T('Type')}</th>
                                <th>{Lang::T('Plan Price')}</th>
                                <th>{Lang::T('Created On')}</th>
                                <th>{Lang::T('Expires On')}</th>
                                <th>{Lang::T('Date Done')}</th>
                                <th>{Lang::T('Method')}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $order as $ds}
                                <tr>
                                    <td>{$ds['plan_name']}</td>
                                    <td>{$ds['gateway']}</td>
                                    <td>{$ds['routers']}</td>
                                    <td>{$ds['payment_channel']}</td>
                                    <td>{Lang::moneyFormat($ds['price'])}</td>
                                    <td class="text-primary">{Lang::dateTimeFormat($ds['created_date'])}</td>
                                    <td class="text-danger">{Lang::dateTimeFormat($ds['expired_date'])}</td>
                                    <td class="text-success">{if $ds['status']!=1}{Lang::dateTimeFormat($ds['paid_date'])}{/if}
                                    </td>
                                    <td>{if $ds['status']==1}{Lang::T('UNPAID')}
                                        {elseif $ds['status']==2}{Lang::T('PAID')}
                                        {elseif $ds['status']==3}{$_L['FAILED']}
                                        {elseif $ds['status']==4}{Lang::T('CANCELED')}
                                        {elseif $ds['status']==5}{Lang::T('UNKNOWN')}
                                        {/if}</td>
                                </tr>
                            {/foreach}
                        </tbody>
                    {/if}
                </table>
            </div>
            {include file="pagination.tpl"}
        </div>
        <div class="row">
            {foreach $packages as $package}
                <div class="col-md-6">
                    <div class="box box-{if $package['status']=='on'}success{else}danger{/if}">
                        <div class="box-body box-profile">
                            <h4 class="text-center">{$package['type']} - {$package['namebp']} <span
                                    api-get-text="{Text::url('autoload/customer_is_active/')}{$package['username']}/{$package['plan_id']}"></span>
                            </h4>
                            <ul class="list-group list-group-unbordered">
                                <li class="list-group-item">
                                    {Lang::T('Active')} <span class="pull-right">{if
                        $package['status']=='on'}yes{else}no
                                    {/if}</span>
                            </li>
                            <li class="list-group-item">
                                {Lang::T('Type')} <span class="pull-right">
                                    {if $package['prepaid'] eq yes}Prepaid{else}<b>{Lang::T('Postpaid')}</b>{/if}</span>
                            </li>
                            <li class="list-group-item">
                                {Lang::T('Bandwidth')} <span class="pull-right">
                                    {$package['name_bw']}</span>
                            </li>
                            <li class="list-group-item">
                                {Lang::T('Created On')} <span
                                    class="pull-right">{Lang::dateAndTimeFormat($package['recharged_on'],$package['recharged_time'])}</span>
                            </li>
                            <li class="list-group-item">
                                {Lang::T('Expires On')} <span class="pull-right">{Lang::dateAndTimeFormat($package['expiration'],
                        $package['time'])}</span>
                            </li>
                            <li class="list-group-item">
                                {$package['routers']} <span class="pull-right">{$package['method']}</span>
                            </li>
                        </ul>
                        <div class="row">
                            <div class="col-xs-4">
                                <a href="{Text::url('customers/deactivate/', $d['id'],'/',$package['plan_id'], '&token=', $csrf_token)}"
                                    id="{$d['id']}" class="btn btn-danger btn-block btn-sm"
                                    onclick="return ask(this, '{Lang::T('This will deactivate Customer Plan, and make it expired')}')">{Lang::T('Deactivate')}</a>
                            </div>
                            <div class="col-xs-8">
                                <a href="{Text::url('customers/recharge/', $d['id'], '/', $package['plan_id'], '&token=', $csrf_token)}"
                                    class="btn btn-success btn-sm btn-block">{Lang::T('Recharge')}</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            {/foreach}
        </div>
    </div>
</div>
<hr>
<div class="row">
    <div class="col-xs-6 col-md-3">
        <a href="{Text::url('customers/list')}" class="btn btn-primary btn-sm btn-block">{Lang::T('Back')}</a>
    </div>
    <div class="col-xs-6 col-md-3">
        <a href="{Text::url('customers/sync/', $d['id'], '&token=', $csrf_token)}"
            onclick="return ask(this, '{Lang::T('This will sync Customer to Mikrotik')}?')"
            class="btn btn-info btn-sm btn-block">{Lang::T('Sync')}</a>
    </div>
    <div class="col-xs-6 col-md-3">
        <a href="{Text::url('message/send/', $d['id'], '&token=', $csrf_token)}"
            class="btn btn-success btn-sm btn-block">
            {Lang::T('Send Message')}
        </a>
    </div>
    <div class="col-xs-6 col-md-3">
        <a href="{Text::url('customers/login/', $d['id'], '&token=', $csrf_token)}" target="_blank"
            class="btn btn-warning btn-sm btn-block">
            {Lang::T('Login as Customer')}
        </a>
    </div>
</div>

{if $d['coordinates']}
    {literal}
        <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
        <script>
            function setupMap(lat, lon) {
                var map = L.map('map').setView([lat, lon], 17);
                L.tileLayer('https://{s}.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}&s=Ga', {
                subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                    maxZoom: 20
            }).addTo(map);
            var marker = L.marker([lat, lon]).addTo(map);
            }
            window.onload = function() {
                {/literal}setupMap({$d['coordinates']});{literal}
            }
        </script>
    {/literal}
{/if}
{include file="sections/footer.tpl"}