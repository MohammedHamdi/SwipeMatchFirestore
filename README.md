# SwipeMatchFirestore
* An iOS app that clone the functionality of apps like tinder using firestore as backend.
* The user can view other users in the form of cards and can show interset by swiping on these cards.
* The app is done using MVVM.


## Features

### Register and Login
<p align="center"><img src="https://raw.githubusercontent.com/MohammedHamdi/SwipeMatchFirestore/master/Screenshots/LoginView.png" alt="LoginView" width="250" height="541">   <img src="https://raw.githubusercontent.com/MohammedHamdi/SwipeMatchFirestore/master/Screenshots/RegisterView.png" alt="RegisterView" width="250" height="541"></p>

<p align="center"><img src="https://github.com/MohammedHamdi/SwipeMatchFirestore/blob/master/Screenshots/RegisterView.gif" alt="RegisterViewGIF" width="250" height="541"></p>

#### Registering and Login is handled by firebase authentication.

#
### Swipe View
#### The data is handled by firestore real-time database.

<p align="center"><img src="https://raw.githubusercontent.com/MohammedHamdi/SwipeMatchFirestore/master/Screenshots/MainView.png" alt="MainView" width="250" height="541">   <img src="https://raw.githubusercontent.com/MohammedHamdi/SwipeMatchFirestore/master/Screenshots/MatchView.png" alt="MatchView" width="250" height="541"></p>

<p align="center"><img src="https://raw.githubusercontent.com/MohammedHamdi/SwipeMatchFirestore/master/Screenshots/SwipeView.gif" alt="SwipeViewGIF" width="250" height="541"></p>

- The user can view other users' cards and swipe right if he is interseted in the other user or swipe left if he isn't interseted.
- The user can view more photos if he tapped on the right or left side of other user's card.
- The another user swiped also right on the current user, they will be matched and will be able to chat with each other.

#
### Detail View

<p align="center"><img src="https://raw.githubusercontent.com/MohammedHamdi/SwipeMatchFirestore/master/Screenshots/DetailView.png" alt="DetailView" width="250" height="541">   <img src="https://raw.githubusercontent.com/MohammedHamdi/SwipeMatchFirestore/master/Screenshots/DetailView.gif" alt="DetailViewGIF" width="250" height="541"></p>

#### On each user's card there is a more info button which shows a more detailed view of other users including more photos by swiping on the photos.

#
### Settings View

<p align="center"><img src="https://raw.githubusercontent.com/MohammedHamdi/SwipeMatchFirestore/master/Screenshots/SettingsView.png" alt="SettingsView" width="250" height="541">   <img src="https://raw.githubusercontent.com/MohammedHamdi/SwipeMatchFirestore/master/Screenshots/SettingsView.gif" alt="SettingsViewGIF" width="250" height="541"></p>

#### The user can view and edit his profile info, photos and the age which he seeks.

#
### Messages View

<p align="center"><img src="https://raw.githubusercontent.com/MohammedHamdi/SwipeMatchFirestore/master/Screenshots/MessagesView.png" alt="MessagesView" width="250" height="541">   <img src="https://raw.githubusercontent.com/MohammedHamdi/SwipeMatchFirestore/master/Screenshots/MessagesView.gif" alt="MessagesViewGIF" width="250" height="541"></p>

- After the user has found a match he will be able to see the other matched user and chat with him.
- In the messages view the user can view the recent matched users at the top and latest messages at the bottom.

<p align="center"><img src="https://raw.githubusercontent.com/MohammedHamdi/SwipeMatchFirestore/master/Screenshots/ChatLogView.png" alt="ChatLogView" width="250" height="541">   <img src="https://raw.githubusercontent.com/MohammedHamdi/SwipeMatchFirestore/master/Screenshots/RealtimeMessage.gif" alt="RealtimeMessageGIF" width="250" height="541"></p>

- The chat log and messages view is updated in real-time.


#
## Pods used
- **Firestore**: For authentication and real-time database
- **SDWebImage**: For loading and caching images.
- **JGProgressHUD**: A HUD to show activity in the app and any error messages.



#
This app was developed by the help of letsbuildthatapp [Tinder Firestore Swipe and Match](https://www.letsbuildthatapp.com/course/Tinder-Firestore-Swipe-and-Match) tutorial.
