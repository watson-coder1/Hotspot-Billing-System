{include file="sections/header.tpl"}

<div class="row">
	<div class="col-sm-12 col-md-12">
		<div class="panel panel-primary panel-hovered panel-stacked mb30">
			<div class="panel-heading">{Lang::T('Edit Pool')}</div>
			<div class="panel-body">

				<form class="form-horizontal" method="post" role="form" action="{Text::url('')}pool/edit-post">
					<input type="hidden" name="id" value="{$d['id']}">
					<div class="form-group">
						<label class="col-md-2 control-label">{Lang::T('Name Pool')}</label>
						<div class="col-md-6">
							<input type="text" class="form-control" id="name" name="name" value="{$d['pool_name']}"
								readonly>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">{Lang::T('Local IP')}</label>
						<div class="col-md-6">
							<input type="text" class="form-control" id="local_ip" name="local_ip"
								value="{$d['local_ip']}" placeholder="192.168.88.1">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">{Lang::T('Range IP')}</label>
						<div class="col-md-6">
							<input type="text" class="form-control" id="ip_address" name="ip_address"
								value="{$d['range_ip']}">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">{Lang::T('Routers')}</label>
						<div class="col-md-6">
							<input type="text" class="form-control" id="routers" name="routers" value="{$d['routers']}"
								readonly>
						</div>
						{if $_c['radius_enable']}
							<p class="help-block col-md-4">{Lang::T('For Radius, you need to add')} <b>{Lang::T('Name')}
									Pool</b> {Lang::T('in Mikrotik manually')}</p>
						{/if}
					</div>

					<div class="form-group">
						<div class="col-lg-offset-2 col-lg-10">
							<button class="btn btn-success"
								onclick="return ask(this, '{Lang::T("Continue the Port change process?")}')"
								type="submit">{Lang::T('Save Changes')}</button>
							Or <a href="{Text::url('')}pool/list">{Lang::T('Cancel')}</a>
						</div>
					</div>
				</form>

			</div>
		</div>
	</div>
</div>

{include file="sections/footer.tpl"}