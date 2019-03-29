UAR Trial task
===================

Rails API application that allows to create objects with tags and filter them.

Developed by: `Jonathan Cabas Candama`

Task duration: ~ 7 Hours 30 minutes

# Requirements

* Ruby 2.6.0
* Rails 5.1.7
* Postgres

# Setting up Database

Copy the existing format of the database.yml and add your custom setup if needed

``
  $ cp config/database.yml.example config/database.yml
``

Then run the following to setup rails db and populate it immediately

`$ rake db:setup`
`$ rake db:migrate`
`$ rake db:seed`

# Design

I've decided to make requests and responses complying JSON API specifications with some differences to make responses readable and easier to use. The jsonapi-resources gem built the responses itself.

There is a module called `error_handler` that rescue exceptions from the controller and display a nice and readable output with the status and exception message.

The additional attributes such as `total_records`, `related_tags` and `file_count` required for the `Filter files by tags` endpoint were added in the meta section of the response because they are not part per sé of the file resources, but is related information.

There was no significant difference in getting the `file count` either by Ruby or using the database, however for this exercise I chose to use the DB since the field involved (`tags`) is indexed and we were using a chainable ActiveRecord::Relation even if that requires query the database per every related tag.

The path for files creation is defined in plural form so is RESTFUL. For this same endpoint, the header `'Content-Type: application/json'` is mandatory otherwise you'll get an error.

Since there was the need to capture a set of tags but a separate table and join table feels like overkill, the tags attribute in the files table is an indexed array of strings.

# Getting Started

Before starting to run the application make sure Postgres is up and running

The following command will start the server

``
  $ rails s
``

# Testing

The testing framework that was used is `RSpec`

In order to run test, it is just a matter to run the following command:

``
  $ rspec spec
``

# Endpoints Documentation

### Files creation

```sh

    POST http://localhost:{{port}}/api/v1/files
    Headers: 'Content-Type: application/json'
    Request body
      {
        "data": {
          "type": "files",
          "attributes": {
            "name": "test1",
            "tags": ["tags1", "tags2"]
          }
        }
      }

    Response body
    {
      "data": {
        "id": "7f71865f-8d4e-4154-b7fa-d13cccd0692d",
        "type": "files",
        "links": {
            "self": "/api/v1/files/7f71865f-8d4e-4154-b7fa-d13cccd0692d"
        }
      }
    }

```


### Filter files by tag

```sh

    GET http://localhost:{{port}}/api/v1/files/+tag2 +tag3 -tag4/1
    Headers: 'Content-Type: application/json'

    Response body
    {
      "data": [
        {
          "id": "8b107952-a873-4bb1-9735-255cd830aad8",
          "type": "custom-files",
          "links": {
            "self": "/api/v1/custom-files/8b107952-a873-4bb1-9735-255cd830aad8"
          },
          "attributes": {
            "name": "file1"
          }
        },
        {
          "id": "7927c65e-cfb4-4368-9d1c-27c86a12fbee",
          "type": "custom-files",
          "links": {
            "self": "/api/v1/custom-files/7927c65e-cfb4-4368-9d1c-27c86a12fbee"
          },
          "attributes": {
            "name": "file3"
          }
        }
      ],
      "meta": {
        "total_records": 2,
        "related_tags": [
          {
            "tag": "tag1",
            "file_count": 1
          },
          {
            "tag": "tag5",
            "file_count": 2
          }
        ]
      }
    }

```