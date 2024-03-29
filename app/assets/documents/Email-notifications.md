# Setting Up Email Notifications for Announcements

In our web app, we provide email notifications for announcements to keep your users informed about important updates. This does require a bit of technical setup, but do not worry! If everything is done right, these emails will operate seemlessly and automatically in the background whenever an Announcement is Created or Updated.

One and just ONE gmail account will handle sending all emails. If the app is already sending out emails from the correct address, then there is nothing to do!

---

## Quick Notes:

 * You will be generating an App Password and adding that to Heroku. This will require you to enable 2-Step Authentication.
 * Some email domains do not allow App Passwords. You might not be able to follow these steps with an **@tamu.edu** account. Try an account with the domain **@gmail.com**.
 * Be sure to use the official gmail address associated with your MABS team.

---

### Step 1: Navigate to the Google Account Home Page

First navigate to [https://myaccount.google.com/](https://myaccount.google.com/) and make sure you are signed in with the account your team wants to send the emails from.

<img src="/assets/google_acct.png" alt="Manage Google Account" style="max-width: 100%; max-height: 300px; width: auto; display: block; margin: 20px auto;">

### Step 2: Enable 2-Step Verification

Go to the "Security" tab. Scroll down to the "How you sign in to Google" section.

<img src="/assets/manage_google_account.png" alt="Google Security Tab" style="max-width: 100%; max-height: 300px; width: auto; display: block; margin: 20px auto;">

In this section, click where it says "2-Step Verification."

<img src="/assets/security_tab.png" alt="Google 2-Step Verification" style="max-width: 100%; max-height: 300px; width: auto; display: block; margin: 20px auto;">

If you have already enabled 2-Step Verification before, then you can move on to Step 3.
If not, just follow Google's easy instructions for adding a phone number and setting up 2-Step Verification.


### Step 3: Generating the App Password

Scroll to the bottom of the "2-Step Verification" page. Click on where it says "App Passwords."

<img src="/assets/2FA.png" alt="App Password Link" style="max-width: 100%; max-height: 300px; width: auto; display: block; margin: 20px auto;">

On this new page, type in the name for your App Password (this can be anything). Click Create.

<img src="/assets/create_app_pswrd.png" alt="Generate App Password" style="max-width: 100%; max-height: 300px; width: auto; display: block; margin: 20px auto;">

You will see a new pop-up containing your uniquely generated App Password.

**STOP HERE** for just a second! This is the **ONLY** time you will **EVER** see this password!
Copy it and save it somewhere secure. I recommend leaving this open until you have entered the password into Heroku.

<img src="/assets/app_pswrd.png" alt="App Password" style="max-width: 100%; max-height: 300px; width: auto; display: block; margin: 20px auto;">

Click the "Done" button to close the pop-up whenever you are ready.


### Step 4: Go to the Heroku App

Go to your [Heroku Dashboard](https://dashboard.heroku.com/apps) and navigate to the pipeline.
Inside your Pipeline, click on the name of the app you want to add the email to.

<img src="/assets/heroku_pipeline.png" alt="Heroku Pipeline" style="max-width: 100%; max-height: 300px; width: auto; display: block; margin: 20px auto;">

### Step 5: Set the Config Vars in the App Settings

Click on the Settings tab.

<img src="/assets/settings_heroku_app.png" alt="Heroku App" style="max-width: 100%; max-height: 300px; width: auto; display: block; margin: 20px auto;">

Click where it says "Reveal Config Vars"

<img src="/assets/reveal_vars.png" alt="Reveal Config Vars Button" style="max-width: 100%; max-height: 300px; width: auto; display: block; margin: 20px auto;">

At the bottom of the list of Config Vars is a field where you can create new Vars.

<img src="/assets/add_var.png" alt="Create new Config Vars field" style="max-width: 100%; max-height: 300px; width: auto; display: block; margin: 20px auto;">

You will create 2 Config Vars:

 * EMAIL\_USERNAME<span style="padding-left: 2em;"></span> "\<your email address\>"
 * EMAIL\_PASSWORD<span style="padding-left: 2em;"></span> "\<your App Password\>"

Use quotation marks around the values for each Var as shown. Click the "Add" button when you finish filling in each Var.

<img src="/assets/add_password.png" alt="Add Config Vars Button" style="max-width: 100%; max-height: 300px; width: auto; display: block; margin: 20px auto;">


## Sending an Email
Whenever a new announcement is created or updated, our system automatically sends an email notification to all registered users.
The email contains the details of the announcement, including the subject and body.

 * The Subject of the Announcement is also a link to the Announcement's page in the web app

<img src="/assets/email_ex.png" alt="Sample Email" style="max-width: 100%; max-height: 300px; width: auto; display: block; margin: 20px auto;">

- Emails about New Announcements will have the subject line: "New MABS Announcement - \<Announcement Subject\>"
- Emails about Updated Announcements will have the subject line: "Update to MABS Announcement - \<Announcement Subject\>"

By providing email notifications, we aim to improve communication and ensure that your users never miss any important announcements.

---

## Advice about Announcement Practices

When you update Announcements, it is good practice to indicate what has changed. Maybe use the strikethrough or explain your changes at the end of the Announcement.

Try not to update or create announcements too frequently. No one want to get bombarded with emails, and Heroku can only handle so much.

EVERYONE gets an email about EVERY Announcement. Be careful what you say!

---

## Don't Like the Email Feature?

That's ok! Just remove the 2 Config Vars you created in Step 5 from the Heroku App.

---

## Troubleshooting

If you are unable to create an App Password it may be because your domain has restricted that security feature.

 - **@tamu.edu** accounts cannot create app passwords. Try with an **@gmail.com** account instead!

Make sure that you entered the Config Vars correctly!

 - Double check spelling
 - Make sure you have added the Vars to the correct app on Heroku

App Passwords only work if 2-Step Verification is enabled. Make sure you did not turn it off by mistake!

**Did you forget your App Password? Did it get leaked?**
In either case, the fix is simple!

 - Go back to your gmail's App Passwords
 - Click the garbage can icon next to your App Password
 - This revokes and deletes it forever! It can never be used or misused again!
 - Now just create a new App Password and add it to your Heroku Config Vars


If you have any further questions or need assistance, feel free to reach out to our support team.
