{include file="sections/header.tpl"}

<div class="row">
	<div class="col-sm-12 col-md-12">
		<div class="panel panel-primary panel-hovered panel-stacked mb30">
			<div class="panel-heading">{Lang::T('Send Personal Message')}</div>
			<div class="panel-body">
				<form class="form-horizontal" method="post" role="form" action="{Text::url('message/send-post')}">
					<div class="form-group">
						<label class="col-md-2 control-label">{Lang::T('Customer')}</label>
						<div class="col-md-6">
							<select {if $cust}{else}id="personSelect" {/if} class="form-control select2"
								name="id_customer" style="width: 100%"
								data-placeholder="{Lang::T('Select a customer')}...">
								{if $cust}
									<option value="{$cust['id']}">{$cust['username']} &bull; {$cust['fullname']} &bull;
										{$cust['email']}</option>
								{/if}
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">{Lang::T('Send Via')}</label>
						<div class="col-md-6">
							<select class="form-control" name="via" id="via">
								<option value="sms" selected> {Lang::T('via SMS')}</option>
								<option value="wa"> {Lang::T('Via WhatsApp')}</option>
								<option value="both"> {Lang::T('Via WhatsApp and SMS')}</option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">{Lang::T('Message')}</label>
						<div class="col-md-6">
							<textarea class="form-control" id="message" name="message"
								placeholder="{Lang::T('Compose your message...')}" rows="5"></textarea>
						</div>
						<p class="help-block col-md-4">
							{Lang::T('Use placeholders:')}
							<br>
							<b>[[name]]</b> - {Lang::T('Customer Name')}
							<br>
							<b>[[user_name]]</b> - {Lang::T('Customer Username')}
							<br>
							<b>[[phone]]</b> - {Lang::T('Customer Phone')}
							<br>
							<b>[[company_name]]</b> - {Lang::T('Your Company Name')}
							<br>
							<b>[[payment_link]]</b> - <a href="{Text::url('docs')}/#Reminder%20with%20payment%20link"
								target="_blank">{Lang::T('Read documentation')}</a>.
						</p>
					</div>

					<div class="form-group">
						<div class="col-lg-offset-2 col-lg-10">
							<button class="btn btn-success"
								onclick="return ask(this, '{Lang::T('Continue the process of sending messages')}?')"
								type="submit">{Lang::T('Send Message')}</button>
							<a href="{Text::url('dashboard')}" class="btn btn-default">{Lang::T('Cancel')}</a>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>


{include file="sections/footer.tpl"}