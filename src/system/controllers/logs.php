<?php

/**
 *  PHP Mikrotik Billing (https://github.com/hotspotbilling/phpnuxbill/)
 *  by https://t.me/ibnux
 **/

_admin();
$ui->assign('_title', 'PHPNuxBill Logs');
$ui->assign('_system_menu', 'logs');

$action = $routes['1'];
$ui->assign('_admin', $admin);

if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
    _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
}


switch ($action) {
    case 'list-csv':
        $logs = ORM::for_table('tbl_logs')
            ->select('id')
            ->select('date')
            ->select('type')
            ->select('description')
            ->select('userid')
            ->select('ip')
            ->order_by_asc('id')->find_array();
        $h = false;
        set_time_limit(-1);
        header('Pragma: public');
        header('Expires: 0');
        header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
        header("Content-type: text/csv");
        header('Content-Disposition: attachment;filename="activity-logs_' . date('Y-m-d_H_i') . '.csv"');
        header('Content-Transfer-Encoding: binary');
        foreach ($logs as $log) {
            $ks = [];
            $vs = [];
            foreach ($log as $k => $v) {
                $ks[] = $k;
                $vs[] = $v;
            }
            if (!$h) {
                echo '"' . implode('";"', $ks) . "\"\n";
                $h = true;
            }
            echo '"' . implode('";"', $vs) . "\"\n";
        }
        break;
    case 'radius-csv':
        $logs = ORM::for_table('radpostauth')
            ->select('id')
            ->select('username')
            ->select('pass')
            ->select('reply')
            ->select('authdate')
            ->order_by_asc('id')->find_array();
        $h = false;
        set_time_limit(-1);
        header('Pragma: public');
        header('Expires: 0');
        header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
        header("Content-type: text/csv");
        header('Content-Disposition: attachment;filename="radius-logs_' . date('Y-m-d_H_i') . '.csv"');
        header('Content-Transfer-Encoding: binary');
        foreach ($logs as $log) {
            $ks = [];
            $vs = [];
            foreach ($log as $k => $v) {
                $ks[] = $k;
                $vs[] = $v;
            }
            if (!$h) {
                echo '"' . implode('";"', $ks) . "\"\n";
                $h = true;
            }
            echo '"' . implode('";"', $vs) . "\"\n";
        }
        break;

    case 'message-csv':
        $logs = ORM::for_table('tbl_message_logs')
            ->select('id')
            ->select('message_type')
            ->select('recipient')
            ->select('message_content')
            ->select('status')
            ->select('error_message')
            ->select('sent_at')
            ->order_by_asc('id')->find_array();
        $h = false;
        set_time_limit(-1);
        header('Pragma: public');
        header('Expires: 0');
        header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
        header("Content-type: text/csv");
        header('Content-Disposition: attachment;filename="message-logs_' . date('Y-m-d_H_i') . '.csv"');
        header('Content-Transfer-Encoding: binary');
        foreach ($logs as $log) {
            $ks = [];
            $vs = [];
            foreach ($log as $k => $v) {
                $ks[] = $k;
                $vs[] = $v;
            }
            if (!$h) {
                echo '"' . implode('";"', $ks) . "\"\n";
                $h = true;
            }
            echo '"' . implode('";"', $vs) . "\"\n";
        }
        break;

    case 'list':
        $q = (_post('q') ? _post('q') : _get('q'));
        $keep = _post('keep');
        if (!empty($keep)) {
            ORM::raw_execute("DELETE FROM tbl_logs WHERE UNIX_TIMESTAMP(date) < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL $keep DAY))");
            r2(getUrl('logs/list/'), 's', "Delete logs older than $keep days");
        }
        if ($q != '') {
            $query = ORM::for_table('tbl_logs')->where_like('description', '%' . $q . '%')->order_by_desc('id');
            $d = Paginator::findMany($query, ['q' => $q]);
        } else {
            $query = ORM::for_table('tbl_logs')->order_by_desc('id');
            $d = Paginator::findMany($query);
        }

        $ui->assign('d', $d);
        $ui->assign('q', $q);
        $ui->display('admin/logs/system.tpl');
        break;
    case 'radius':
        $q = (_post('q') ? _post('q') : _get('q'));
        $keep = _post('keep');
        if (!empty($keep)) {
            ORM::raw_execute("DELETE FROM radpostauth WHERE UNIX_TIMESTAMP(authdate) < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL $keep DAY))", [], 'radius');
            r2(getUrl('logs/radius/'), 's', "Delete logs older than $keep days");
        }
        if ($q != '') {
            $query = ORM::for_table('radpostauth', 'radius')->where_like('username', '%' . $q . '%')->order_by_desc('id');
            $d = Paginator::findMany($query, ['q' => $q]);
        } else {
            $query = ORM::for_table('radpostauth', 'radius')->order_by_desc('id');
            $d = Paginator::findMany($query);
        }

        $ui->assign('d', $d);
        $ui->assign('q', $q);
        $ui->display('admin/logs/radius.tpl');
        break;

    case 'message':
        $q = _post('q') ?: _get('q');
        $keep = (int) _post('keep');
        if (!empty($keep)) {
            ORM::raw_execute("DELETE FROM tbl_message_logs WHERE UNIX_TIMESTAMP(sent_at) < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL $keep DAY))");
            r2(getUrl('logs/message/'), 's', "Deleted logs older than $keep days");
        }

        if ($q !== null && $q !== '') {
            $query = ORM::for_table('tbl_message_logs')
            ->whereRaw("message_type LIKE '%$q%' OR recipient LIKE '%$q%' OR message_content LIKE '%$q%' OR status LIKE '%$q%' OR error_message LIKE '%$q%'")
                ->order_by_desc('sent_at');
            $d = Paginator::findMany($query, ['q' => $q]);
        } else {
            $query = ORM::for_table('tbl_message_logs')->order_by_desc('sent_at');
            $d = Paginator::findMany($query);
        }

        if ($d) {
            $ui->assign('d', $d);
        } else {
            $ui->assign('d', []);
        }

        $ui->assign('q', $q);
        $ui->display('admin/logs/message.tpl');
        break;

    default:
        r2(getUrl('logs/list/'), 's', '');
}
