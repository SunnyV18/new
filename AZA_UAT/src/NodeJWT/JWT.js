const jwt = require('jsonwebtoken');
const https = require('https');

const apiKey = '43d2bae1-da50-44b5-8dc4-806451f92445';
const secretKey = 'PRNF6S49QawyeUlu5UqtY7UgmM1jEKcGeIf3kczhy';
const tokenCreationTime = Math.floor(Date.now() / 1000);
const payload = { iss: apiKey, iat: tokenCreationTime };

//jwt library uses HS256 as default.
const token = jwt.sign(payload, secretKey);
const options = {
  host: 'api.ristaapps.com',
  path: '/v1/branch/list',
  headers: {
    'x-api-key': apiKey,
    'x-api-token': token,
    'content-type': 'application/json'
  }
};