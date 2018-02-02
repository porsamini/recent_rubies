require 'net/http'
require 'rvm'

##
# This script installs the recently released & stable versions of rubies
# including all their fix versions from the ruby community.
# The number of recent versions can be optionally provided in the arguments
# to this scripts, otherwise, the number of recent versions defaults to 2
#
#
class RecentRubies
  DEFAULT_COUNT = 2

  def initialize
    @recent_versions = []
    @installed_rubies = []
    @recent_count = recent_count
  end

  def run
    install
    cleanup
  end

  # Cleans up rubies older than the specified number of versions(defaults to 2 versions)
  def cleanup
    begin
      stale_rubies.each do |ruby|
        RVM.run "rvm remove #{ruby}"
      end
      return true
    rescue Exception => e
      return false
    end
  end

  # Installs the recent versions of ruby specified number of versions(defaults to 2 versions)
  def install
    begin
      new_rubies.each do |ruby|
        RVM.run "rvm install #{ruby}"
      end
      return true
    rescue Exception => e
      return false
    end
  end

  def new_rubies
    recent_versions - installed_rubies
  end

  def stale_rubies
    installed_rubies - recent_versions
  end

  private

  # For DEFAULT_COUNT = 2
  # Scan all ruby versions from ruby-lang website in descending order
  # until the loop runs into "patch versions"(version[4] == '0'), twice
  # => ["2.5.0", "2.4.3", "2.4.2", "2.4.1", "2.4.0"]
  def recent_versions
    return @recent_versions unless @recent_versions.empty?
    uri = URI('https://www.ruby-lang.org/en/downloads/releases/')
    response = Net::HTTP.get(uri)
    versions = response.scan(/Ruby\s(\d.\d.\d)+/).flatten.uniq.sort_by{|i| i}.reverse
    count = 0
    versions.each do |version|
      break if count == @recent_count
      @recent_versions << version
      count += 1 if version[4] == "0"
    end
    @recent_versions
  end

  def installed_rubies
    return @installed_rubies unless @installed_rubies.empty?
    rvm_list = RVM.run 'rvm list'
    @installed_rubies = rvm_list.stdout.scan(/\d.\d.\d/).flatten.uniq
  end

  def recent_count
    return DEFAULT_COUNT if ARGV.empty?
    recent_count = ARGV[0].to_i
    raise InvalidArgument, 'Argument must be an integer value more than 1' if recent_count == 0
    recent_count
  end
end

class InvalidArgument < Exception; end;

RecentRubies.new.run
