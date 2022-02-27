<h1 align="center">Shape your Failures</i></h1>
<h2 align="center"><i>Show off your Failures</i></h2>
<h2 align="center">✨Submitted to Buildgroop Hacks✨</h4>
<p align="center"><img alt="pic" height="600" width="300px"  src="https://user-images.githubusercontent.com/99386803/155870067-40a76286-aefc-4e29-aa49-616ce949d0ad.gif"/>
</p>
<hr>

# Table of Contents

- [ Inspiration ](#inspiration)
- [ What it does ](#features)
- [ How we built it ](#made)
- [Challenges we ran into](#challenges)
- [What's next for Shape your Failures](#future)
- [ Contributors ](#contributors)
- [ Images ](#images)

# <a name="inspiration"></a>Inspiration

On social media, most of the things that come up are success stories. I've seen a lot of our friends complain that there are platforms where people keep bragging about what they've been achieving in life, but not a single one showing their failures.
<br><br>
I realized that there's a need for a platform where people can share their failure episodes for open and free discussion.
So I have now decided to take matters in our own hands and are creating `Shape your Failure` to break the taboo around failures! On `Shape your Failure`, you realize - "You're NOT alone!"

# <a name="features"></a>What it does

- It is a no-judgment platform to learn to celebrate failure tales.
- Enabled User to add failure episodes (anonymously/non-anonymously), allowing others to react and comment.
- Each episode on the platform has #tags associated with it, which helps filter out the episodes easily. A user's recommendation is based on the #tags with which they usually interact
- Implemented sentiment analysis to predict the sentiment score of a user from the episodes and comments posted.
- We have a motivational bot to lighten the user's mood.
- Allowed the users to report the episodes and comments for
  - NSFW images (integrated ML check to detect nudity)
  - Abusive language (integrated ML check to classify texts)
  - Spam (Checking the previous activity and finding similarities)
  - Flaunting success (Manual checks)

# <a name="made"></a>How we built it

- We used Node for building REST API and MongoDb as database.
- For the client side we used flutter.
- Also we used tensorflow library and its built in models for NSFW, abusive text checks and sentiment analysis.

# <a name="challenges"></a>Challenges we ran into

- It was the first time we tried using Flutter-beta instead of React with MongoDB and node. It took a little longer than usual to integrate the server-side with the client-side.
- Finding the versions of tensorflow and other libraries which could integrate with the remaining code.

# <a name="future"></a>What's next for Shape your Failure

- Improve the model of sentiment analysis to get more accurate results so we can understand the users and recommend them famous failure to success stories using web scraping.
- Create separate discussion rooms for each #tag, facilitating users to communicate and discuss their failures.
- Also provide the option to follow/unfollow a user.

# <a name="contributors"></a>Contributors

- [Ankush](https://github.com/an-prog-hub)

# <a name="images"></a>Images

<div align="left">
    <img height="500px" width="250px" src="https://user-images.githubusercontent.com/67872399/155870299-a6f2b2b9-5b6e-453a-a612-619d9a95b2f3.png"  hspace="10px"/>
    <img height="500px" width="250px"src="https://user-images.githubusercontent.com/67872399/155870301-cb2ffd4a-b0fe-45f7-86fa-5b9b0b0a3e19.png"  hspace="10px"/>
    <img height="500px" width="250px"src="https://user-images.githubusercontent.com/67872399/155870303-5852eaed-4b9b-44ce-b36c-fffaeb083be0.png"  hspace="10px"/>
    <br><br>
    <img height="500px" width="250px" src="https://user-images.githubusercontent.com/67872399/155870304-d22cd28d-dade-471f-9c5e-d18110c7a605.png" hspace="10px"/>
    <img height="500px" width="250px" src="https://user-images.githubusercontent.com/59930598/136700752-59488b6d-eeb5-48d7-88c4-26b237f3d70e.png" hspace="10px"/>
    <img height="500px" width="250px" src="https://user-images.githubusercontent.com/59930598/136700760-e4c9baf8-c331-4fcc-84e4-ed740caf9a5f.png"  hspace="10px"/>
    <br><br>
    <img height="500px" width="250px" src="https://user-images.githubusercontent.com/67872399/155870305-ba1c102f-900c-4b25-b365-cf2e48db804d.gif"  hspace="10px"/>
    <img height="500px" width="250px" src="https://user-images.githubusercontent.com/59930598/136700911-2da05549-5e3c-41f8-8916-2a85a57b9934.png" hspace="10px"/>
    <img height="500px" width="250px" src="https://user-images.githubusercontent.com/59930598/136700969-f68a3233-c542-487f-82aa-f9cce2b7114e.png" hspace="10px"/>
    <br><br><br>
</div>
