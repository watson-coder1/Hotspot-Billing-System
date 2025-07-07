{include file="sections/header.tpl"}
<!-- pool -->
<div class="row">
    <div class="col-sm-12">
        <div class="panel panel-hovered mb20 panel-primary">
            <div class="panel-heading">
                Radius
            </div>
            <div class="panel-body">
                <div class="md-whiteframe-z1 mb20 text-center" style="padding: 15px">
                    <div class="col-md-8">
                        <form id="site-search" method="post" action="{Text::url('')}radius/nas-list">
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <span class="fa fa-search"></span>
                                </div>
                                <input type="text" name="name" class="form-control" value="{$name}"
                                    placeholder="{Lang::T('Search by Name')}...">
                                <div class="input-group-btn">
                                    <button class="btn btn-success" type="submit">{Lang::T('Search')}</button>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="col-md-4">
                        <a href="{Text::url('')}radius/nas-add" class="btn btn-primary btn-block"><i
                                class="ion ion-android-add"> </i> {Lang::T('New NAS')}</a>
                    </div>&nbsp;
                </div>
                <div class="table-responsive">
                    <table class="table table-bordered table-striped table-condensed">
                        <thead>
                            <tr>
                                <th>{Lang::T('Name')}</th>
                                <th>IP</th>
                                <th>{Lang::T('Type')}</th>
                                <th>Port</th>
                                <th>Server</th>
                                <th>Community</th>
                                <th>Routers</th>
                                <th>{Lang::T('Manage')}</th>
                                <th>ID</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $nas as $ds}
                                <tr>
                                    <td>{$ds['shortname']}</td>
                                    <td>{$ds['nasname']}</td>
                                    <td>{$ds['type']}</td>
                                    <td>{$ds['ports']}</td>
                                    <td>{$ds['server']}</td>
                                    <td>{$ds['community']}</td>
                                    <td>{$ds['routers']}</td>
                                    <td align="center">
                                        <a href="{Text::url('')}radius/nas-edit/{$ds['id']}"
                                            class="btn btn-info btn-xs">{Lang::T('Edit')}</a>
                                        <a href="{Text::url('')}radius/nas-delete/{$ds['id']}" id="{$ds['id']}"
                                            onclick="return ask(this, '{Lang::T('Delete')}?')"
                                            class="btn btn-danger btn-xs"><i class="glyphicon glyphicon-trash"></i></a>
                                    </td>
                                    <td align="center">{$ds['id']}</td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
                {include file="pagination.tpl"}
                <div class="bs-callout bs-callout-info" id="callout-navbar-role">
                    <h4>RADIUS REST</h4>
                    <p>{Lang::T("For Radius REST, you don't need to add NAS, NAS need to add to client.conf manually")}
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="sections/footer.tpl"}