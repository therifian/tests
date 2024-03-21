const yaml = require('yamljs');
const fs = require('fs');

// Read YAML contract file
const contractData = fs.readFileSync('contract.yaml', 'utf8');

// Parse YAML data
const parsedData = yaml.parse(contractData);

// Extract routes
const routes = [];

if (parsedData.paths) {
    for (const [path, methods] of Object.entries(parsedData.paths)) {
        for (const [method, details] of Object.entries(methods)) {
            for (const [status, response] of Object.entries(details.responses)) {
                routes.push({
                    method: method.toUpperCase(),
                    status: status,
                    path: path
                });
            }
        }
    }
}

// Format routes
const formattedRoutes = routes.map(route => `[${route.method}][${route.status}] ${route.path}`);

// Display formatted routes
console.log(formattedRoutes);
