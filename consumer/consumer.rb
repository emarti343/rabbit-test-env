#!/usr/bin/env ruby
require 'bunny'
require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

host = ENV["RABBITMQ_HOST"] || "127.0.0.1"
connection = Bunny.new(host: host)
connection.start

channel = connection.create_channel
queue = channel.queue('hello')

begin
    logger.debug ' [*] Waiting for messages. To exit press CTRL+C'
    queue.subscribe(block: true) do |_delivery_info, _properties, body|
      logger.debug " [#{host}] Received #{body}"
    end
  rescue Interrupt => _
    connection.close
  
    exit(0)
  end
  