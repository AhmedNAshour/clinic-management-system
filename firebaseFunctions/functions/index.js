const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.deleteUser = functions.https.onCall((data,context) => {
    admin.auth().deleteUser(data.uid)
    .then(function() {
        console.log('Successfully deleted user');
    }).catch(function(error) {
        console.log('Error deleting user:', error);
        });  
})

exports.doctorBookingTrigger = functions.firestore.document('appointments/{appointmentId}').onCreate
(
    async (snapshot , context) =>
    {
        var tokens=[];
        tokens.push(snapshot.data().doctorToken);
        var payload = {notification: {title: 'New Appointment', body: 'You have a new appointment'}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
        console.log(tokens[0]);
        const response = await admin.messaging().sendToDevice(tokens , payload)
    }
)

exports.doctorCancellingTrigger = functions.firestore.document('appointments/{appointmentId}').onDelete
(
    async (snapshot , context) =>
    {
        var tokens=[];
        tokens.push(snapshot.data().doctorToken);
        var payload = {notification: {title: 'Appointment Cancelled', body: 'One appointment was cancelled'}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
        console.log(tokens[0]);
        const response = await admin.messaging().sendToDevice(tokens , payload)
    }
)