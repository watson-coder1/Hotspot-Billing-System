{include file="sections/header.tpl"}

<div class="row">
    <div class="col-sm-7">
        <div class="panel panel-primary">
            <div class="panel-heading">{Lang::T('Backup Database')}</div>
            <form method="post" action="{Text::url('')}settings/dbbackup">
                <div class="table-responsive">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th width="50%">{Lang::T('Table Name')}</th>
                                <th>{Lang::T('Rows')}</th>
                                <th>{Lang::T('Choose')}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $tables as $tbl}
                                <tr>
                                    <td>{$tbl['name']}</td>
                                    <td>{$tbl['rows']}</td>
                                    <td><input type="checkbox" checked name="tables[]" value="{$tbl['name']}"></td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-md-6">{Lang::T('Don\'t select logs if it failed')}</div>
                        <div class="col-md-4 text-right">
                            <button type="submit" class="btn btn-primary btn-xs btn-block" aria-label="Download Backup Database">
                                <i class="fa fa-download"></i> {Lang::T('Download Backup Database')}
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="col-sm-5">
        <div class="panel panel-primary">
            <div class="panel-heading">{Lang::T('Restore Database')}</div>
            <form method="post" action="{Text::url('')}settings/dbrestore" enctype="multipart/form-data">
                <div class="panel-body">
                    <div class="row">
                        <div class="col-md-7"><input type="file" name="json" accept="application/json"></div>
                        <div class="col-md-5 text-right">
                            <button type="submit" class="btn btn-primary btn-block btn-xs" aria-label="Restore Database">
                                <i class="fa fa-upload"></i> {Lang::T('Restore Database')}
                            </button>
                        </div>
                    </div>
                </div>
            </form>
            <div class="panel-footer">{Lang::T('Restoring the database will clean up data and then restore all the data.')}</div>
        </div>
    </div>
</div>

{include file="sections/footer.tpl"}
