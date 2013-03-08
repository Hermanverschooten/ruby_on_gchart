# ruby_on_gchart

This gem allows you to generate Google Chart graphics within Ruby/Rails.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby_on_gchart'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_on_gchart

## Usage


Example
=======

GoogleChart::Chart.new({
    :type => :line,
    :height => 200,
    :width => 1000,
    :encoding => :simple,
    :datas => [25, 50],
    :labels => ['First Label', 'Second Label']
}).to_url


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Copyright (c) 2009 Damien MATHIEU, (c) 2013 Herman verschooten, released under the MIT license