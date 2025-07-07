{include file="sections/header.tpl"}

		<div class="row">
			<div class="col-sm-12 col-md-12">
				<div class="panel panel-primary panel-hovered panel-stacked mb30">
					<div class="panel-heading">{Lang::T('Add Pool')}</div>
						<div class="panel-body">

                <form class="form-horizontal" method="post" role="form" action="{Text::url('')}pool/add-post" >
                    <div class="form-group">
						<label class="col-md-2 control-label">{Lang::T('Name Pool')}</label>
						<div class="col-md-6">
							<input type="text" class="form-control" id="name" name="name">
						</div>
                    </div>
                    <div class="form-group">
						<label class="col-md-2 control-label">{Lang::T('Local IP')}</label>
						<div class="col-md-6">
							<input type="text" class="form-control" id="local_ip" name="local_ip" placeholder="192.168.88.1">
						</div>
                    </div>
                    <div class="form-group">
						<label class="col-md-2 control-label">{Lang::T('Range IP')}</label>
						<div class="col-md-6">
							<input type="text" class="form-control" id="ip_address" name="ip_address" placeholder="192.168.88.2-192.168.88.254">
						</div>
                    </div>
                    <div class="form-group">
						<label class="col-md-2 control-label"><a href="{Text::url('')}routers/add">{Lang::T('Routers')}</a></label>
						<div class="col-md-6">
							<select id="routers" name="routers" class="form-control select2">
                                {if $_c['radius_enable']}
                                    <option value="radius">Radius</option>
                                {/if}
                                {foreach $r as $rs}
									<option value="{$rs['name']}">{$rs['name']}</option>
                                {/foreach}
                            </select>
						</div>
                    </div>
					<div class="form-group">
						<div class="col-lg-offset-2 col-lg-10">
							<button class="btn btn-primary" onclick="return ask(this, '{Lang::T("Continue the Pool addition process?")}')" type="submit">{Lang::T('Save Changes')}</button>
							Or <a href="{Text::url('')}pool/list">{Lang::T('Cancel')}</a>
						</div>
					</div>
                </form>

					</div>
				</div>
			</div>
		</div>

{include file="sections/footer.tpl"}
