var AWS = require('aws-sdk');
var sns = new AWS.SNS();

var SNSTopic = process.env.sns;

console.log('Loading SNS');

exports.handler = async (event, context, callback) => {
  return new Promise((resolve) => {
    if (event.queryStringParameters && event.queryStringParameters.phoneNumber) {
      let phoneNumber = event.queryStringParameters.phoneNumber;
      const subscription = new Promise((resolve, reject) => {
          var params = {
            Protocol: 'sms',
            TopicArn: SNSTopic,
            Endpoint: `+1${phoneNumber}`
          };
          sns.subscribe(params, (err, data) => {
            if (err) {
              reject(new Error(`Failed to subscribe: ${err}`));
            } else {
              resolve(data);
            }
          });
        });
      const subscriptionMessage = new Promise((resolve, reject) => {
        var params = {
          Message: `Successfully subscribed ${phoneNumber} to SNS (SMS) UBC Hotel`, /* required */
          PhoneNumber: `+1${phoneNumber}`
        };
        sns.publish(params, (err, data) => {
          if (err) {
            reject(new Error(`Failed to publish message to phone number ${phoneNumber}: ${err}`));
          } else {
            resolve(data);
          }
        })
      });
      console.log("Received phone number: " + event.queryStringParameters.phoneNumber);
      subscription.then((_) => {
        console.log(`Subscription succeeded`);
        return subscriptionMessage;
      }, (err) => {
        console.log(`Subscription failed: ${err}`);
        return new Promise((resolve) => {
          resolve({
            body: 'Subscription failed due to internal server error',
            statusCode: 500,
            headers: {
              'Content-Type': 'application/json'
            }
          });
        });
      })
      .then((_) => {
        console.log(`Subscription message successfully sent`);
        resolve({
          body: `Subscribed ${phoneNumber} to SNS (SMS) hotel service!`,
          statusCode: 200,
          headers: {
            'Content-Type': 'application/json'
          }
        });
      }, (err) => {
        resolve({
          body: `Unable to publish message to ${phoneNumber}: ${err}`,
          statusCode: 500,
          headers: {
            'Content-Type': 'application/json'
          }
        });
      });
    } else {
      resolve({
        body: `Bad request parameters: ${event.queryStringParameters}`,
        statusCode: 400,
        headers: {
          'Content-Type': 'application/json'
        }
      });
    }
  });
};