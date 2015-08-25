#/usr/bin/env ruby

require 'rubygems'
require 'logger'
require 'json'
require 'aws-sdk'
require 'zlib'
require 'redis'
require "daemons"
require "yaml"

class Cloudtrail2Logstash

  def initialize config
    # Set up logging
    @log = Logger.new("#{config[:logpath]}/ct2ls_log.json", 'weekly')
    @log.level = Logger.const_get config[:loglevel]
    @log.progname = 'cloudtrail2logstash'
    @log.formatter = proc do |serverity, time, progname, msg|
      message = { :serverity => serverity, :time => time, :progname => progname, :message => msg}.to_json
      "#{message}\n"
    end

    # Set up AWS
    AWS.config(:access_key_id => config[:access_key_id], :secret_access_key => config[:secret_access_key], :region => config[:region])
    @queue = AWS::SQS.new.queues.named(config[:sqs_queue])
    @s3 = AWS::S3.new

    # Set up redis
    @redis = Redis.new(:host => config[:redis_host], :port => config[:redis_port], :db => config[:redis_db])

    # Local temp file
    @local_file = "#{config[:tmp_path]}/cloudtrail_tmp.gz"
    @remove_original = config[:remove_original]
    @redis_list = config[:redis_list]
  end

  def run
    # Constant SQS poll
    @log.info "Waiting for a message...\n"
    @queue.poll(:batch_size => 1, :wait_time_seconds => 20) do |orig_msg|
      @log.info "Message #{orig_msg.id} recieved"
      msg = JSON.parse(orig_msg.body)
      message = JSON.parse(msg['Message'])

      bucket = @s3.buckets[message['s3Bucket']]

      message['s3ObjectKey'].each do |key|
        @log.debug "fetching #{message['s3Bucket']}:#{key}"
        obj = bucket.objects[key]

        # Fetch the file from S3
        begin
          File.open(@local_file, 'wb') do |file|
            obj.read do |chunk|
               file.write(chunk)
            end
          end
        rescue => e
          @log.error "There was an error fetching the file from S3"
          @log.error "#{e.message} #{e.class}"
          @log.error e.backtrace.join("\n")
          exit
        end

        # Read cloudtrail file
        file = File.open(@local_file, mode='r')
        file_stream = Zlib::GzipReader.new(file)
        file_stream.each_line do |line|
          begin
            records = JSON.parse(line)
          rescue => e
            @log.error "Line '#{line}' is not valid JSON"
            @log.error "#{e.message} #{e.class}"
            @log.error e.backtrace.join("\n")
            exit
          end

          records['Records'].each do |record|
            record['type'] = 'cloudtrail'
            record['@version'] = 1
            record['@timestamp'] = record.delete('eventTime')
            begin
              @log.debug "pushing #{record.to_json} to redis"
              @redis.lpush(@redis_list, record.to_json)
            rescue => e
              @log.error "There was a problem pushing to redis"
              @log.error "#{e.message} #{e.class}"
              @log.error e.backtrace.join("\n")
              exit
            end
          end
        end
        file.close

        # Clean up local file
        @log.debug "Cleaning up #{@local_file}"
        File.delete(@local_file)
        # Remove original from S3
        @log.debug "Cleaning up #{message['s3Bucket']}:#{key}" if @remove_original
        obj.delete if @remove_original
      end

      @log.info "Waiting for a message...\n"
    end
  end
end


# Read config
cfg_file = '/etc/ct2ls.yaml'
if File.exist?(cfg_file)
  begin
    config =  YAML.load_file(cfg_file)
  rescue
    puts "#{cfg_file} is not valid YAML"
    exit
  else
    puts "Loading config from #{cfg_file}"
  end
else
  puts "#{cfg_file} not found"
  exit
end

daemon_options = {
  :multiple   => false,
  :dir_mode   => :normal,
  :dir        => '/var/run/ct2ls/',
  :backtrace  => true
}

Daemons.run_proc("ct2ls", daemon_options) do
  if ARGV.include?("--")
    ARGV.slice! 0..ARGV.index("--")
  else
    ARGV.clear
  end
  Cloudtrail2Logstash.new(config).run
end
