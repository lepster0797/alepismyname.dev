FROM jekyll/jekyll:latest
COPY . /srv/jekyll
WORKDIR /srv/jekyll
RUN rm Gemfile.lock
RUN bundle install
EXPOSE 4000
CMD ["jekyll", "serve", "--host", "0.0.0.0"]

