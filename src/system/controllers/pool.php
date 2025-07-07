<?php

/**
 *  PHP Mikrotik Billing (https://github.com/hotspotbilling/phpnuxbill/)
 *  by https://t.me/ibnux
 **/

_admin();
$ui->assign('_title', Lang::T('Network'));
$ui->assign('_system_menu', 'network');

$action = $routes['1'];
$ui->assign('_admin', $admin);

if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
    _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
}

require_once $DEVICE_PATH . DIRECTORY_SEPARATOR . 'MikrotikPppoe' . '.php';

switch ($action) {
    case 'list':

        $name = _post('name');
        if ($name != '') {
            $query = ORM::for_table('tbl_pool')->where_like('pool_name', '%' . $name . '%')->order_by_desc('id');
            $d = Paginator::findMany($query, ['name' => $name]);
        } else {
            $query = ORM::for_table('tbl_pool')->order_by_desc('id');
            $d = Paginator::findMany($query);
        }

        $ui->assign('d', $d);
        run_hook('view_pool'); #HOOK
        $ui->display('admin/pool/list.tpl');
        break;

    case 'add':
        $r = ORM::for_table('tbl_routers')->find_many();
        $ui->assign('r', $r);
        run_hook('view_add_pool'); #HOOK
        $ui->display('admin/pool/add.tpl');
        break;

    case 'edit':
        $id  = $routes['2'];
        $d = ORM::for_table('tbl_pool')->find_one($id);
        if ($d) {
            $ui->assign('d', $d);
            run_hook('view_edit_pool'); #HOOK
            $ui->display('admin/pool/edit.tpl');
        } else {
            r2(getUrl('pool/list'), 'e', Lang::T('Account Not Found'));
        }
        break;

    case 'delete':
        $id  = $routes['2'];
        run_hook('delete_pool'); #HOOK
        $d = ORM::for_table('tbl_pool')->find_one($id);
        if ($d) {
            if ($d['routers'] != 'radius') {
                (new MikrotikPppoe())->remove_pool($d);
            }
            $d->delete();

            r2(getUrl('pool/list'), 's', Lang::T('Data Deleted Successfully'));
        }
        break;

    case 'sync':
        $pools = ORM::for_table('tbl_pool')->find_many();
        $log = '';
        foreach ($pools as $pool) {
            if ($pool['routers'] != 'radius') {
                (new MikrotikPppoe())->update_pool($pool, $pool);
                $log .= 'DONE: ' . $pool['pool_name'] . ': ' . $pool['range_ip'] . '<br>';
            }
        }
        r2(getUrl('pool/list'), 's', $log);
        break;
    case 'add-post':
        $name = _post('name');
        $ip_address = _post('ip_address');
        $local_ip = _post('local_ip');
        $routers = _post('routers');
        run_hook('add_pool'); #HOOK
        $msg = '';
        if (Validator::Length($name, 30, 2) == false) {
            $msg .= 'Name should be between 3 to 30 characters' . '<br>';
        }
        if ($ip_address == '' or $routers == '') {
            $msg .= Lang::T('All field is required') . '<br>';
        }

        $d = ORM::for_table('tbl_pool')->where('pool_name', $name)->find_one();
        if ($d) {
            $msg .= Lang::T('Pool Name Already Exist') . '<br>';
        }
        if ($msg == '') {
            $b = ORM::for_table('tbl_pool')->create();
            $b->local_ip = $local_ip;
            $b->pool_name = $name;
            $b->range_ip = $ip_address;
            $b->routers = $routers;
            if ($routers != 'radius') {
                (new MikrotikPppoe())->add_pool($b);
            }
            $b->save();
            r2(getUrl('pool/list'), 's', Lang::T('Data Created Successfully'));
        } else {
            r2(getUrl('pool/add'), 'e', $msg);
        }
        break;


    case 'edit-post':
        $local_ip = _post('local_ip');
        $ip_address = _post('ip_address');
        $routers = _post('routers');
        run_hook('edit_pool'); #HOOK
        $msg = '';

        if ($ip_address == '' or $routers == '') {
            $msg .= Lang::T('All field is required') . '<br>';
        }

        $id = _post('id');
        $d = ORM::for_table('tbl_pool')->find_one($id);
        $old = ORM::for_table('tbl_pool')->find_one($id);
        if (!$d) {
            $msg .= Lang::T('Data Not Found') . '<br>';
        }

        if ($msg == '') {
            $d->local_ip = $local_ip;
            $d->range_ip = $ip_address;
            $d->routers = $routers;
            $d->save();

            if ($routers != 'radius') {
                (new MikrotikPppoe())->update_pool($old, $d);
            }

            r2(getUrl('pool/list'), 's', Lang::T('Data Updated Successfully'));
        } else {
            r2(getUrl('pool/edit/') . $id, 'e', $msg);
        }

    case 'port':

        $name = _post('name');
        if ($name != '') {
            $query = ORM::for_table('tbl_port_pool')->where_like('pool_name', '%' . $name . '%')->order_by_desc('id');
            $d = Paginator::findMany($query, ['name' => $name]);
        } else {
            $query = ORM::for_table('tbl_port_pool')->order_by_desc('id');
            $d = Paginator::findMany($query);
        }

        $ui->assign('d', $d);
        run_hook('view_port'); #HOOK
        $ui->display('admin/port/list.tpl');
        break;

    case 'add-port':
        $r = ORM::for_table('tbl_routers')->find_many();
        $ui->assign('r', $r);
        run_hook('view_add_port'); #HOOK
        $ui->display('admin/port/add.tpl');
        break;

    case 'edit-port':
        $id  = $routes['2'];
        $d = ORM::for_table('tbl_port_pool')->find_one($id);
        if ($d) {
            $ui->assign('d', $d);
            run_hook('view_edit_port'); #HOOK
            $ui->display('admin/port/edit.tpl');
        } else {
            r2(getUrl('pool/port'), 'e', Lang::T('Account Not Found'));
        }
        break;

    case 'delete-port':
        $id  = $routes['2'];
        run_hook('delete_port'); #HOOK
        $d = ORM::for_table('tbl_port_pool')->find_one($id);
        if ($d) {
            $d->delete();

            r2(getUrl('pool/port'), 's', Lang::T('Data Deleted Successfully'));
        }
        break;

    case 'sync':
        $pools = ORM::for_table('tbl_port_pool')->find_many();
        $log = '';
        foreach ($pools as $pool) {
            if ($pool['routers'] != 'radius') {
                (new MikrotikPppoe())->update_pool($pool, $pool);
                $log .= 'DONE: ' . $pool['port_name'] . ': ' . $pool['range_port'] . '<br>';
            }
        }
        r2(getUrl('pool/list'), 's', $log);
        break;
    case 'add-port-post':
        $name = _post('name');
        $port_range = _post('port_range');
        $public_ip = _post('public_ip');
        $routers = _post('routers');
        run_hook('add_pool'); #HOOK
        $msg = '';
        if (Validator::Length($name, 30, 2) == false) {
            $msg .= 'Name should be between 3 to 30 characters' . '<br>';
        }
        if ($port_range == '' or $routers == '') {
            $msg .= Lang::T('All field is required') . '<br>';
        }

        $d = ORM::for_table('tbl_port_pool')->where('routers', $routers)->find_one();
        if ($d) {
            $msg .= Lang::T('Routers already have ports, each router can only have 1 port range!') . '<br>';
        }
        if ($msg == '') {
            $b = ORM::for_table('tbl_port_pool')->create();
            $b->public_ip = $public_ip;
            $b->port_name = $name;
            $b->range_port = $port_range;
            $b->routers = $routers;
            $b->save();
            r2(getUrl('pool/port'), 's', Lang::T('Data Created Successfully'));
        } else {
            r2(getUrl('pool/add-port'), 'e', $msg);
        }
        break;


    case 'edit-port-post':
        $name = _post('name');
        $public_ip = _post('public_ip');
        $range_port = _post('range_port');
        $routers = _post('routers');
        run_hook('edit_port'); #HOOK
        $msg = '';
        $msg = '';
        if (Validator::Length($name, 30, 2) == false) {
            $msg .= 'Name should be between 3 to 30 characters' . '<br>';
        }
        if ($range_port == '' or $routers == '') {
            $msg .= Lang::T('All field is required') . '<br>';
        }

        $id = _post('id');
        $d = ORM::for_table('tbl_port_pool')->find_one($id);
        $old = ORM::for_table('tbl_port_pool')->find_one($id);
        if (!$d) {
            $msg .= Lang::T('Data Not Found') . '<br>';
        }

        if ($msg == '') {
            $d->port_name = $name;
            $d->public_ip = $public_ip;
            $d->range_port = $range_port;
            $d->routers = $routers;
            $d->save();

            r2(getUrl('pool/port'), 's', Lang::T('Data Updated Successfully'));
        } else {
            r2(getUrl('pool/edit-port/') . $id, 'e', $msg);
        }
        break;

    default:
        r2(getUrl('pool/list/'), 's', '');
}
