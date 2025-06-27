import apm from 'elastic-apm-node';

export default apm.start({
  serviceName: 'apollo-service',
  serverUrl: 'http://localhost:8200',
  environment: 'production',
  captureBody: 'all',
  logLevel: 'debug'
});