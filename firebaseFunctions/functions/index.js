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

exports.secretaryBookingTrigger = functions.firestore.document('appointments/{appointmentId}').onCreate
(
    async (snapshot , context) =>
    {
        var payload = {notification: {title: 'New Appointment', body: 'Appointment added in ' + snapshot.data().branch}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
        const response = await admin.messaging().sendToTopic('reservationIn' + snapshot.data().branch + 'Branch',payload)
    }
)

exports.secretaryCancellingTrigger = functions.firestore.document('appointments/{appointmentId}').onDelete
(
    async (snapshot , context) =>
    {
        var payload = {notification: {title: 'Appointment Cancelled', body: 'Appointment cancelled in ' + snapshot.data().branch}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
        const response = await admin.messaging().sendToTopic('reservationIn' + snapshot.data().branch + 'Branch',payload)
    }
)