{include file="sections/header.tpl"}

<div class="row">
	<div class="col-sm-12">
		<div class="panel panel-hovered mb20 panel-primary">
			<div class="panel-heading">{Lang::T('Balance Package')}</div>
			<div class="panel-body">
				<div class="md-whiteframe-z1 mb20 text-center" style="padding: 15px">
					<div class="col-md-8">
						<form id="site-search" method="post" action="{Text::url('services/balance/')}">
							<div class="input-group">
								<div class="input-group-addon">
									<span class="fa fa-search"></span>
								</div>
								<input type="text" name="name" class="form-control"
									placeholder="{Lang::T('Search by Name')}...">
								<div class="input-group-btn">
									<button class="btn btn-success" type="submit">{Lang::T('Search')}</button>
								</div>
							</div>
						</form>
					</div>
					<div class="col-md-4">
						<a href="{Text::url('services/balance-add')}" class="btn btn-primary btn-block"><i
								class="ion ion-android-add"> </i> {Lang::T('New Service Package')}</a>
					</div>&nbsp;
				</div>
				<div class="table-responsive">
					<table class="table table-bordered table-striped table-condensed">
						<thead>
							<tr>
								<th>{Lang::T('Package Name')}</th>
								<th>{Lang::T('Package Price')}</th>
								<th>{Lang::T('Manage')}</th>
							</tr>
						</thead>
						<tbody>
							{foreach $d as $ds}
								<tr {if $ds['enabled'] != 1}class="danger" title="disabled" {/if}>
									<td>{$ds['name_plan']}</td>
									<td>{Lang::moneyFormat($ds['price'])}{if !empty($ds['price_old'])}
											<sup
												style="text-decoration: line-through; color: red">{Lang::moneyFormat($ds['price_old'])}</sup>
										{/if}
									</td>
									<td>
										<a href="{Text::url('services/balance-edit/',$ds['id'])}"
											class="btn btn-info btn-xs">{Lang::T('Edit')}</a>
										<a href="{Text::url('services/balance-delete/',$ds['id'])}"
											onclick="return ask(this, '{Lang::T('Delete')}?')" id="{$ds['id']}"
											class="btn btn-danger btn-xs"><i class="glyphicon glyphicon-trash"></i></a>
									</td>
								</tr>
							{/foreach}
						</tbody>
					</table>
				</div>
				{include file="pagination.tpl"}

			</div>
		</div>
	</div>
</div>

{include file="sections/footer.tpl"}