const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { user } = require('firebase-functions/lib/providers/auth');
admin.initializeApp(functions.config().firebase);


// exports.addUser = functions.https.onCall((data,context) => {
//     admin
//     .auth()
//     .createUser({
//       email: data.email,
//       password: data.password,
//       disabled: false,
//     })
//     .then((userRecord) => {
//       // See the UserRecord reference doc for the contents of userRecord.
//       return {'uid':userRecord.uid};
//     })
//     .catch((error) => {
//         return {'uid':'fail'};
//     });
// })


exports.registrationRequestTrigger = functions.firestore.document('users/{userId}').onCreate
(
    async (snapshot , context) =>
    {
        if(snapshot.role == 'client' && snapshot.status == 2){
            var payload = {notification: {title: 'Registration Request', body: 'A new registration request was made'}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
            console.log(tokens[0]);
            const response = await admin.messaging().sendToTopic('registrationRequests',payload)
        }    
    }
)

exports.doctorBookingTrigger = functions.firestore.document('appointments/{appointmentId}').onCreate
(
    async (snapshot , context) =>
    {
        var payload = {notification: {title: 'New Appointment', body: 'You have a new appointment'}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
        const response = await admin.messaging().sendToTopic('reservationBookedForDoctor' + snapshot.data().doctorID,payload)
    }
)

exports.doctorCancellingTrigger = functions.firestore.document('appointments/{appointmentId}').onDelete
(
    async (snapshot , context) =>
    {
        // var tokens=[];
        // tokens.push(snapshot.data().doctorToken);
        // console.log(tokens[0]);
        // const response = await admin.messaging().sendToDevice(tokens , payload)
        var payload = {notification: {title: 'Appointment Cancelled', body: 'One appointment was cancelled'}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
        const response = await admin.messaging().sendToTopic('reservationCancelledForDoctor' + snapshot.data().doctorID,payload)
    }
)

exports.requestStatusTrigger = functions.https.onCall((data,context) => {
    async (snapshot , context) =>
    {
        if(data.status == 1){
            var payload = {notification: {title: 'Request Accepted', body: 'Your registration request was accepted.'}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
        }else{
            var payload = {notification: {title: 'Request Denied', body: 'Sorry, Your registration request was denied.'}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
        }
        const response = await admin.messaging().sendToTopic(data.client+'requestStatus',payload)
    }
})


exports.secretaryBookingTrigger = functions.https.onCall((data,context) => {
    async (snapshot , context) =>
    {
        var payload = {notification: {title: 'New Appointment', body:data.client +  ' booked an appointment with Dr. ' + data.doctorName}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
        const response = await admin.messaging().sendToTopic('reservationIn' + data.branch + 'Branch',payload)
    }
})

exports.secretaryCancellingTrigger = functions.https.onCall((data,context) => {
    async (snapshot , context) =>
    {
        var payload = {notification: {title: data.client + ' cancelled an appointment with Dr. ' + data.doctor}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
        const response = await admin.messaging().sendToTopic('cancelledReservationIn' + data.branch + 'Branch',payload)
    }
})

exports.clientBookingTrigger = functions.https.onCall((data,context) => {
    async (snapshot , context) =>
    {
        var payload = {notification: {title: 'New Appointment', body: 'An appointment was booked with Dr. ' + data.doctorName + ' on ' + data.time}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
        const response = await admin.messaging().sendToTopic('reservationForClient' + data.client,payload)
    }
})

exports.clientCancellingTrigger = functions.https.onCall((data,context) => {
    async (snapshot , context) =>
    {
        var payload = {notification: {title: 'Your appointment with Dr. ' + data.doctor + ' was cancelled'}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
        const response = await admin.messaging().sendToTopic('cancelledReservationForClient' + data.client,payload)
    }
})

// exports.secretaryBookingTrigger = functions.firestore.document('appointments/{appointmentId}').onCreate
// (
//     async (snapshot , context) =>
//     {
//         var payload = {notification: {title: 'New Appointment', body: 'Appointment added in ' + snapshot.data().branch}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
//         const response = await admin.messaging().sendToTopic('reservationIn' + snapshot.data().branch + 'Branch',payload)
//     }
// )

// exports.secretaryCancellingTrigger = functions.firestore.document('appointments/{appointmentId}').onDelete
// (
//     async (snapshot , context) =>
//     {
//         var payload = {notification: {title: 'Appointment Cancelled', body: 'Appointment cancelled in ' + snapshot.data().branch}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
//         const response = await admin.messaging().sendToTopic('cancelledReservationIn' + snapshot.data().branch + 'Branch',payload)
//     }
// )




