# Stock Tracker Social Media App

This web application was built while doing "The Complete Ruby on Rails Developer Course" on Udemy. Users can track stocks (up to 10), and their profile page will display all the stocks they are tracking with their current price. Users can search for stocks, add and remove them from their portfolio, look for friends or other users of the app by name or email, and view the portfolio of stocks their friends are tracking for investing ideas.

The goal with this app was to learn some of the next topics which are different from previous apps:

* Use (and customization) of devise gem for authentication so users can sign-up, edit their profile, login/logout
* Ajax for form submission, in-depth
* Work with IEX Cloud API to get stock quote information
* Work with sensitive credentials (such as API keys) within the app
* Faster development of resources using generators

## Clone Repository

If you are going to clone this repository, remember to execute these steps before you run the app locally:

* yarn add bootstrap@4.6.1 jquery popper.js
* bundle install
* rails db:migrate

### General Information

* Ruby version: 2.7.5
* Rails version: 6.1.5.1
* Bootstrap version: 4.6.1
* Status: Completed
