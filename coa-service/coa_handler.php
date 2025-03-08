<?php
/**
 * CoA Request Handler
 * 
 * This script handles CoA requests from the main application.
 * It should be placed in the FreeRADIUS container.
 */

// Only allow POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

// Get the request body
$requestData = json_decode(file_get_contents('php://input'), true);

// Validate the request
if (!isset($requestData['username']) || !isset($requestData['type']) || !isset($requestData['nas_ip']) || !isset($requestData['secret'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing required parameters']);
    exit;
}

$username = $requestData['username'];
$type = $requestData['type']; // 'disconnect' or 'coa'
$nasIp = $requestData['nas_ip'];
$secret = $requestData['secret'];
$attributes = $requestData['attributes'] ?? [];

// Log the request
error_log("CoA request received for user: $username, type: $type");

// Build the base attributes string
$attrString = "User-Name=$username";

// Add additional attributes for CoA requests
if (!empty($attributes)) {
    foreach ($attributes as $name => $value) {
        $attrString .= ",$name=$value";
    }
}

// Determine the command type
$commandType = ($type === 'disconnect') ? 'disconnect' : 'coa';
error_log('Command Type: ' . $commandType);
error_log('Attributes: ' . json_encode($attributes));

// Construct the radclient command
$command = "echo '$attrString' | radclient -x {$nasIp}:3799 $commandType $secret";
// dumpt above command into the console
print_r($command);

// Execute the command
exec($command, $output, $returnVar);

// Build the response
$response = [
    'success' => ($returnVar === 0),
    'output' => $output,
    'command' => $command
];

// Log the result
if ($returnVar === 0) {
    error_log("RADIUS $commandType successful for user: $username");
} else {
    error_log($command);
    error_log('\n');
    error_log($output);
    error_log('\n');
    error_log($returnVar);
    error_log('\n');
    error_log("RADIUS $commandType failed for user: $username: " . implode("\n", $output));
}

// Return the result
header('Content-Type: application/json');
echo json_encode($response); 