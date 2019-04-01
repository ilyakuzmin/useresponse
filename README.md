# Useresponse

Useresponse OneLogin URL generator

This is a raw gem based on official PHP script

more info: https://help.useresponse.com/knowledge-base/article/single-sign-on

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'useresponse', git: 'git@github.com:ilyakuzmin/useresponse.git'
```

## Usage

```ruby
class UseresponseController < ApplicationController
  def index
    config = {
      source: 'mydomain.com',
      domain: 'https://mydomain.useresponse.com',
      secret: '680f9e64a62898047662780816f4418a9681c72c59ad30ff19cce8d4bf112ecb'
    }
    attributes = {
      fullname: 'John Bobson',
      email:    'john@example.com',
      user_id:  '1'
    }

    redirect_to Useresponse::OneLogin.new(config).url(attributes)
  end
end
```
