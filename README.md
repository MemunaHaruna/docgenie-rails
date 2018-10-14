# docgenie-rails-api
A document management system that allows users create documents, set access privileges for their documents, and view other users' public documents, save private for-your-eyes-only documents and also edit or delete your own saved documents.

### About the application

#### API Features

The following features make up the Document Management System API:

##### Authentication

* Uses JSON Web Token (JWT) for authentication.
* Generates a token upon successul login / account creation and returns it to the client.
* Verifies the token to ensures a user is authenticated to access some endpoints.

##### Users

* Allows users to be created.
* Allows users to login and obtain a token
* Allows authenticated users to retrieve and edit their information only.
* Ensures all users can be retrieved and modified by an admin user.

##### Roles

* Ensures that users have roles.
* Ensures user roles could be admin or member.
* Ensures user roles can be updated by an admin user.

##### Documents

* Allows new documents to be created by authenticated users.
* Ensures all documents have access roles defined as public or private.
* Allows the admin user to retrieve all documents, except private documents.
* Ensures users can retrieve, delete, and update documents that they own.

##### Tech Stack
* **Rails** - Ruby framework
* **JWT** - Used to authenticate users, to enable them access the app routes

* **Postgresql**: object-relational database management system (ORDBMS)

* **Bcrypt** - A password hashing function designed by Niels Provos and David Mazières, based on the Blowfish cipher.

##### Test Dependencies

* **Shoulda-Matcher**

* **FactoryBot**

* **Database Cleaner**

##### How To Use

nstall and use locally

##### How To Install

* Clone/download this repository then run the following commands:
```
$ cd docgenie-rails-api
$ rails s
```

##### Run in Postman

* Download and install Postman and check the API Documentation for the endpoints.

##### API Documentation

The API has routes, each dedicated to a single task that uses HTTP response codes to indicate API status and error messages.

##### Authentication

* Users are assigned a token on signup or signin. This token is needed for subsequent HTTP requests to the API for authentication and can be attached as values to the header's x-access-token or authorization key. API requests made without authentication will fail with the status code `401: Unauthorized Access`.

##### Contributing

- Contributors are welcome to further enhance the features of this API by contributing to its development. The following guidelines should guide you in contributing to this project:

* Fork this repository to your own account.
* Download/Clone your own forked repository to your local machine.
* Create a new branch: `git checkout -b new-branch-name`.
* Install the dependencies using `bundle install`.
* Run `rails s` to start the application in development mode.
* Work on a new feature and push to your remote branch: `git push origin your-branch-name`
* Raise a pull request to the master branch of this repo.
* For the branch-naming, commit messages and pull request conventions used for this project, kindly check the wiki
of this repo here: <https://github.com/andela-mharuna/DocGenie/wiki>
